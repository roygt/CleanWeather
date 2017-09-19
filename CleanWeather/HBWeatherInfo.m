//
//  HBWeatherInfo.m
//  CleanWeather
//
//  Created by SWRD on 9/5/17.
//  Copyright © 2017 Roy. All rights reserved.
//

#import "HBWeatherInfo.h"

@implementation HBWeatherInfo

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_weatherDescription forKey:@"weatherDescription"];
    [aCoder encodeObject:_lastUpdatedTime forKey:@"lastUpdatedTime"];
    [aCoder encodeObject:_currentTemperature forKey:@"currentTemperature"];
    [aCoder encodeObject:_minTempOfThreeDays forKey:@"minTempOfThreeDays"];
    [aCoder encodeObject:_maxTempOfThreeDays forKey:@"maxTempOfThreeDays"];
    [aCoder encodeObject:_convert_minTempOfThreeDays forKey:@"convert_minTempOfThreeDays"];
    [aCoder encodeObject:_convert_maxTempOfThreeDays forKey:@"convert_maxTempOfThreeDays"];
    [aCoder encodeObject:_dateOfThreeDays forKey:@"dateOfThreeDays"];
    [aCoder encodeObject:_weatherDesOfThreeDays forKey:@"weatherDesOfThreeDays"];
    [aCoder encodeObject:_weatherIconOfThreeDays forKey:@"weatherIconOfThreeDays"];
    [aCoder encodeObject:_windDirection forKey:@"windDirection"];
    [aCoder encodeObject:_windPower forKey:@"windPower"];
    [aCoder encodeObject:_windSpeed forKey:@"windSpeed"];
    [aCoder encodeObject:_wetLevel forKey:@"wetLevel"];
    [aCoder encodeObject:_pm25 forKey:@"pm25"];
    [aCoder encodeObject:_pm10 forKey:@"pm10"];
    [aCoder encodeObject:_so2 forKey:@"so2"];
    [aCoder encodeObject:_no2 forKey:@"no2"];
    [aCoder encodeObject:_weatherQuality forKey:@"weatherQuality"];
    [aCoder encodeObject:_sunRise forKey:@"sunRise"];
    [aCoder encodeObject:_sunGoesDown forKey:@"sunGoesDown"];
    [aCoder encodeObject:_comfortSuggest forKey:@"comfortSuggest"];
    [aCoder encodeObject:_carWashSuggest forKey:@"carWashSuggest"];
    [aCoder encodeObject:_dressSuggest forKey:@"dressSuggest"];
    [aCoder encodeObject:_fluSuggest forKey:@"fluSuggest"];
    [aCoder encodeObject:_sportSuggest forKey:@"sportSuggest"];
    [aCoder encodeObject:_travelSuggest forKey:@"travelSuggest"];
    [aCoder encodeObject:_uvSuggest forKey:@"uvSuggest"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    if (self) {
        _weatherDescription = [aDecoder decodeObjectForKey:@"weatherDescription"];
        _lastUpdatedTime = [aDecoder decodeObjectForKey:@"lastUpdatedTime"];
        _currentTemperature = [aDecoder decodeObjectForKey:@"currentTemperature"];
        _minTempOfThreeDays = [aDecoder decodeObjectForKey:@"minTempOfThreeDays"];
        _maxTempOfThreeDays = [aDecoder decodeObjectForKey:@"maxTempOfThreeDays"];
        _convert_minTempOfThreeDays = [aDecoder decodeObjectForKey:@"convert_minTempOfThreeDays"];
        _convert_maxTempOfThreeDays = [aDecoder decodeObjectForKey:@"convert_maxTempOfThreeDays"];
        _dateOfThreeDays = [aDecoder decodeObjectForKey:@"dateOfThreeDays"];
        _weatherDesOfThreeDays = [aDecoder decodeObjectForKey:@"weatherDesOfThreeDays"];
        _weatherIconOfThreeDays = [aDecoder decodeObjectForKey:@"weatherIconOfThreeDays"];
        _windDirection = [aDecoder decodeObjectForKey:@"windDirection"];
        _windPower = [aDecoder decodeObjectForKey:@"windPower"];
        _windSpeed = [aDecoder decodeObjectForKey:@"windSpeed"];
        _wetLevel = [aDecoder decodeObjectForKey:@"wetLevel"];
        _pm25 = [aDecoder decodeObjectForKey:@"pm25"];
        _pm10 = [aDecoder decodeObjectForKey:@"pm10"];
        _so2 = [aDecoder decodeObjectForKey:@"so2"];
        _no2 = [aDecoder decodeObjectForKey:@"no2"];
        _weatherQuality = [aDecoder decodeObjectForKey:@"weatherQuality"];
        _sunRise = [aDecoder decodeObjectForKey:@"sunRise"];
        _sunGoesDown = [aDecoder decodeObjectForKey:@"sunGoesDown"];
        _comfortSuggest = [aDecoder decodeObjectForKey:@"comfortSuggest"];
        _carWashSuggest = [aDecoder decodeObjectForKey:@"carWashSuggest"];
        _dressSuggest = [aDecoder decodeObjectForKey:@"dressSuggest"];
        _fluSuggest = [aDecoder decodeObjectForKey:@"fluSuggest"];
        _sportSuggest = [aDecoder decodeObjectForKey:@"sportSuggest"];
        _travelSuggest = [aDecoder decodeObjectForKey:@"travelSuggest"];
        _uvSuggest = [aDecoder decodeObjectForKey:@"uvSuggest"];
    }
    
    return self;
}

- (NSString *)lastUpdatedTime{
    return [NSString stringWithFormat:@"%@刷新",_lastUpdatedTime];
}

- (NSString *)currentTemperature{
    return [NSString stringWithFormat:@"%@º",_currentTemperature];
}

- (NSString *)windDirection{
    return [NSString stringWithFormat:@"风向  %@",_windDirection];
}

- (NSString *)windPower{
    return [NSString stringWithFormat:@"风力  %@",_windPower];
}

-(NSString *)windSpeed{
    return [NSString stringWithFormat:@"风速  %@",_windSpeed];
}

- (NSString *)wetLevel{
    return [NSString stringWithFormat:@"湿度  %@",_wetLevel];
}

- (NSString *)pm25{
    return [NSString stringWithFormat:@"PM2.5[细颗粒物]  %@",_pm25];
}

- (NSString *)pm10{
    return [NSString stringWithFormat:@"PM10[可吸入颗粒物]  %@",_pm10];
}

- (NSString *)so2{
    return [NSString stringWithFormat:@"SO2[二氧化硫]  %@",_so2];
}

- (NSString *)no2{
    return [NSString stringWithFormat:@"NO2[二氧化氮]  %@",_no2];
}

- (NSString *)weatherQuality{
    return [NSString stringWithFormat:@"空气质量  %@",_weatherQuality];
}

- (NSString *)sunRise{
    return [NSString stringWithFormat:@"日出时间  %@",_sunRise];
}

- (NSString *)sunGoesDown{
    return [NSString stringWithFormat:@"日落时间  %@",_sunGoesDown];
}

- (NSString *)comfortSuggest{
    return [NSString stringWithFormat:@"舒适指数：%@",_comfortSuggest];
}

- (NSString *)carWashSuggest{
    return [NSString stringWithFormat:@"洗车指数：%@",_carWashSuggest];
}

- (NSString *)dressSuggest{
    return [NSString stringWithFormat:@"穿衣指数：%@",_dressSuggest];
}

- (NSString *)fluSuggest{
    return [NSString stringWithFormat:@"流感指数：%@",_fluSuggest];
}

- (NSString *)sportSuggest{
    return [NSString stringWithFormat:@"运动指数：%@",_sportSuggest];
}

- (NSString *)travelSuggest{
    return [NSString stringWithFormat:@"旅行指数：%@",_travelSuggest];
}

- (NSString *)uvSuggest{
    return [NSString stringWithFormat:@"紫外线指数：%@",_uvSuggest];
}


@end
