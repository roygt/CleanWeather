//
//  HBWeatherView.h
//  CleanWeather
//
//  Created by SWRD on 9/5/17.
//  Copyright © 2017 Roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBWeatherInfo.h"

@interface HBWeatherView : UIScrollView

@property (nonatomic,strong) HBWeatherInfo *weatherInfo;

@property (nonatomic,assign) CGFloat height;

@end
