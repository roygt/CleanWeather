//
//  HBDownloadWeather.m
//  CleanWeather
//
//  Created by SWRD on 9/14/17.
//  Copyright © 2017 Roy. All rights reserved.
//

#import "HBDownloadWeather.h"
#import "HBWeatherInfo.h"
#import "DBManager.h"

#define HBCONVERT(lowestNumber,number) lowestNumber.intValue + (6 * (number.intValue - lowestNumber.intValue))

@interface HBDownloadWeather ()

@property (nonatomic,copy) NSString *apiKey;

@property (nonatomic,strong) NSDateFormatter *dateFormatter;

@end

@implementation HBDownloadWeather

+ (instancetype)sharedDownload{
    static HBDownloadWeather *sharedDownload = nil;
    
    if (!sharedDownload) {
        sharedDownload = [[self alloc] initPrivate];
    }
    
    return sharedDownload;
}

- (instancetype)initPrivate{
    self = [super init];
    
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"HH:mm";
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"APIKEY" ofType:@""];
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        _apiKey = [content stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
    
    return self;
}

- (void)downloadWeatherInfoForCity:(NSString *)cityCode completion:(HBWeatherInfoDownloadCompletion)completion{
    NSString *httpURL = @"https://free-api.heweather.com/v5/weather";
    NSString *httpArgs = [NSString stringWithFormat:@"city=%@&key=%@",cityCode,_apiKey];
    NSString *urlString = [NSString stringWithFormat:@"%@?%@",httpURL,httpArgs];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[[NSOperationQueue alloc] init]];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completion(nil,error);
        } else {
            HBWeatherInfo *weatherInfo = [self weatherInfoWithData:data];
            completion(weatherInfo,error);
        }
    }];
    [dataTask resume];
}

- (HBWeatherInfo *)weatherInfoWithData:(NSData *)data{
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *weatherArray = jsonObject[@"HeWeather5"];
    NSLog(@"%@",weatherArray);
    
    HBWeatherInfo *currentWeatherInfo = [[HBWeatherInfo alloc] init];
    
    currentWeatherInfo.weatherDescription = weatherArray[0][@"now"][@"cond"][@"txt"];
    currentWeatherInfo.currentTemperature = weatherArray[0][@"now"][@"tmp"];
    currentWeatherInfo.lastUpdatedTime = [_dateFormatter stringFromDate:[NSDate date]];
    
    NSString *dayOneLowTemp = weatherArray[0][@"daily_forecast"][0][@"tmp"][@"min"];
    NSNumber *dayOneLowTempNumber = @([dayOneLowTemp integerValue]);
    NSString *dayTwoLowTemp = weatherArray[0][@"daily_forecast"][1][@"tmp"][@"min"];
    NSNumber *dayTwoLowTempNumber = @([dayTwoLowTemp integerValue]);
    NSString *dayThreeLowTemp = weatherArray[0][@"daily_forecast"][2][@"tmp"][@"min"];
    NSNumber *dayThreeLowTempNumber = @([dayThreeLowTemp integerValue]);
    currentWeatherInfo.minTempOfThreeDays = @[dayOneLowTempNumber,dayTwoLowTempNumber,dayThreeLowTempNumber];
    
    NSString *dayOneHighTemp = weatherArray[0][@"daily_forecast"][0][@"tmp"][@"max"];
    NSNumber *dayOneHighTempNumber = @([dayOneHighTemp integerValue]);
    NSString *dayTwoHighTemp = weatherArray[0][@"daily_forecast"][1][@"tmp"][@"max"];
    NSNumber *dayTwoHighTempNumber = @([dayTwoHighTemp integerValue]);
    NSString *dayThreeHighTemp = weatherArray[0][@"daily_forecast"][2][@"tmp"][@"max"];
    NSNumber *dayThreeHighTempNumber = @([dayThreeHighTemp integerValue]);
    currentWeatherInfo.maxTempOfThreeDays = @[dayOneHighTempNumber,dayTwoHighTempNumber,dayThreeHighTempNumber];
    
    NSNumber *lowestNumber = [[currentWeatherInfo.minTempOfThreeDays sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:0];
    NSNumber *convert_dayOneLow = [NSNumber numberWithInt:HBCONVERT(lowestNumber, dayOneLowTempNumber)];
    NSNumber *convert_dayTwoLow = [NSNumber numberWithInt:HBCONVERT(lowestNumber, dayTwoLowTempNumber)];
    NSNumber *convert_dayThreeLow = [NSNumber numberWithInt:HBCONVERT(lowestNumber, dayThreeLowTempNumber)];
    currentWeatherInfo.convert_minTempOfThreeDays = @[convert_dayOneLow,convert_dayTwoLow,convert_dayThreeLow];
    
    NSNumber *convert_dayOneHigh = [NSNumber numberWithInt:HBCONVERT(lowestNumber, dayOneHighTempNumber) + 30];
    NSNumber *convert_dayTwoHigh = [NSNumber numberWithInt:HBCONVERT(lowestNumber, dayTwoHighTempNumber) + 30];
    NSNumber *convert_dayThreeHigh = [NSNumber numberWithInt:HBCONVERT(lowestNumber, dayThreeHighTempNumber) + 30];
    currentWeatherInfo.convert_maxTempOfThreeDays = @[convert_dayOneHigh,convert_dayTwoHigh,convert_dayThreeHigh];
    
    NSString *dayOneDate = [(NSString *)weatherArray[0][@"daily_forecast"][0][@"date"] substringFromIndex:5];
    NSString *dayTwoDate = [(NSString *)weatherArray[0][@"daily_forecast"][1][@"date"] substringFromIndex:5];
    NSString *dayThreeDate = [(NSString *)weatherArray[0][@"daily_forecast"][2][@"date"] substringFromIndex:5];
    currentWeatherInfo.dateOfThreeDays = @[dayOneDate,dayTwoDate,dayThreeDate];
    
    NSString *dayOneWeatherDes = weatherArray[0][@"daily_forecast"][0][@"cond"][@"txt_d"];
    NSString *dayTwoWeatherDes = weatherArray[0][@"daily_forecast"][1][@"cond"][@"txt_d"];
    NSString *dayThreeWeatherDes = weatherArray[0][@"daily_forecast"][2][@"cond"][@"txt_d"];
    currentWeatherInfo.weatherDesOfThreeDays = @[dayOneWeatherDes,dayTwoWeatherDes,dayThreeWeatherDes];
    
    NSString *dayOneWeatherCode = weatherArray[0][@"daily_forecast"][0][@"cond"][@"code_d"];
    //NSString *dayOneWeatherIcon = [[DBManager sharedManager] queryWeatherIcon:dayOneWeatherCode];
    NSString *dayTwoWeatherCode = weatherArray[0][@"daily_forecast"][1][@"cond"][@"code_d"];
    //NSString *dayTwoWeatherIcon = [[DBManager sharedManager] queryWeatherIcon:dayTwoWeatherCode];
    NSString *dayThreeWeatherCode = weatherArray[0][@"daily_forecast"][2][@"cond"][@"code_d"];
    //NSString *dayThreeWeatherIcon = [[DBManager sharedManager] queryWeatherIcon:dayThreeWeatherCode];
    currentWeatherInfo.weatherIconOfThreeDays = @[dayOneWeatherCode,dayTwoWeatherCode,dayThreeWeatherCode];
    
    currentWeatherInfo.windDirection = weatherArray[0][@"daily_forecast"][0][@"wind"][@"dir"];
    currentWeatherInfo.windPower = weatherArray[0][@"daily_forecast"][0][@"wind"][@"sc"];
    currentWeatherInfo.windSpeed = weatherArray[0][@"daily_forecast"][0][@"wind"][@"spd"];
    currentWeatherInfo.wetLevel = weatherArray[0][@"daily_forecast"][0][@"hum"];
    
    currentWeatherInfo.pm25 = weatherArray[0][@"aqi"][@"city"][@"pm25"];
    currentWeatherInfo.pm10 = weatherArray[0][@"aqi"][@"city"][@"pm10"];
    currentWeatherInfo.so2 = weatherArray[0][@"aqi"][@"city"][@"so2"];
    currentWeatherInfo.no2 = weatherArray[0][@"aqi"][@"city"][@"no2"];
    currentWeatherInfo.weatherQuality = weatherArray[0][@"aqi"][@"city"][@"qlty"];
    
    currentWeatherInfo.sunRise = weatherArray[0][@"daily_forecast"][0][@"astro"][@"sr"];
    currentWeatherInfo.sunGoesDown = weatherArray[0][@"daily_forecast"][0][@"astro"][@"ss"];
    
    currentWeatherInfo.comfortSuggest = weatherArray[0][@"suggestion"][@"comf"][@"brf"];
    currentWeatherInfo.carWashSuggest = weatherArray[0][@"suggestion"][@"cw"][@"brf"];
    currentWeatherInfo.dressSuggest = weatherArray[0][@"suggestion"][@"drsg"][@"brf"];
    currentWeatherInfo.fluSuggest = weatherArray[0][@"suggestion"][@"flu"][@"brf"];
    currentWeatherInfo.sportSuggest = weatherArray[0][@"suggestion"][@"sport"][@"brf"];
    currentWeatherInfo.travelSuggest = weatherArray[0][@"suggestion"][@"trav"][@"brf"];
    currentWeatherInfo.uvSuggest = weatherArray[0][@"suggestion"][@"uv"][@"brf"];
    
    return currentWeatherInfo;
}

@end
