//
//  DBManager.m
//  CleanWeather
//
//  Created by SWRD on 9/6/17.
//  Copyright © 2017 Roy. All rights reserved.
//

#import "DBManager.h"
#import "FMDB.h"

@interface DBManager ()

@property (nonatomic,copy) NSString *dbPath;

@end

@implementation DBManager

+ (instancetype)sharedManager{
    static DBManager *sharedManager = nil;
    
    if (!sharedManager) {
        sharedManager = [[self alloc] initPrivate];
    }
    
    return sharedManager;
}

- (instancetype)initPrivate{
    self = [super init];
    
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Weather" ofType:@"sqlite"];
        self.dbPath = path;
    }
    
    return self;
}

- (NSArray *)allChinaCitys{
    NSMutableArray *allCitys = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"select Chinese from CityList"];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *city = [rs stringForColumn:@"Chinese"];
            [allCitys addObject:city];
        }
        [db close];
    }
    
    return allCitys;
}

- (NSString *)queryCityCode:(NSString *)cityName{
    NSString *cityCode = [[NSString alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"select CityCode from CityList where Chinese='%@'",cityName];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *city = [rs stringForColumn:@"CityCode"];
            cityCode = city;
        }
        [db close];
    }
    
    return cityCode;
}

- (NSString *)queryWeatherIcon:(NSString *)weatherCode{
    NSString *WeatherIcon = [[NSString alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"select IconUrl from WeatherCondition where WeatherCode='%@'",weatherCode];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *icon = [rs stringForColumn:@"IconUrl"];
            WeatherIcon = icon;
        }
        [db close];
    }
    
    return WeatherIcon;
}


@end
