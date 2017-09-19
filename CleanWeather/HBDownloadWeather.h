//
//  HBDownloadWeather.h
//  CleanWeather
//
//  Created by SWRD on 9/14/17.
//  Copyright © 2017 Roy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HBWeatherInfo;

typedef void (^HBWeatherInfoDownloadCompletion)(HBWeatherInfo *weatherInfo, NSError *error);

@interface HBDownloadWeather : NSObject

+ (instancetype)sharedDownload;

- (void)downloadWeatherInfoForCity:(NSString *)cityCode completion:(HBWeatherInfoDownloadCompletion)completion;

@end
