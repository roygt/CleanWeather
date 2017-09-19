//
//  HBWeatherViewController.h
//  CleanWeather
//
//  Created by SWRD on 9/5/17.
//  Copyright © 2017 Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HBCityDelegate <NSObject>

- (void)showCityWeather:(NSString *)city;

@end

@interface HBWeatherViewController : UIViewController

@end
