//
//  HBSavedCityViewController.h
//  CleanWeather
//
//  Created by SWRD on 9/5/17.
//  Copyright © 2017 Roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBWeatherViewController.h"

@interface HBSavedCityViewController : UITableViewController

@property (nonatomic,strong) id<HBCityDelegate> delegate;

@end
