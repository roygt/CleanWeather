//
//  HBCityStore.h
//  CleanWeather
//
//  Created by SWRD on 9/5/17.
//  Copyright © 2017 Roy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HBWeatherInfo;

@interface HBCityStore : NSObject

@property (nonatomic,readonly) NSArray *allCitys;

+ (instancetype)sharedStore;

- (BOOL)addNewCity:(NSString *)city;
- (BOOL)removeCity:(NSString *)city;

- (NSString *)singleCityWeatherPath:(NSString *)city;

@end
