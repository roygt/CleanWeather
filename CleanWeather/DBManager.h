//
//  DBManager.h
//  CleanWeather
//
//  Created by SWRD on 9/6/17.
//  Copyright © 2017 Roy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (nonatomic,readonly) NSArray *allChinaCitys;

+ (instancetype)sharedManager;

- (NSString *)queryCityCode:(NSString *)cityName;
- (NSString *)queryWeatherIcon:(NSString *)weatherCode;

@end
