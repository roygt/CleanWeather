//
//  AppDelegate.m
//  CleanWeather
//
//  Created by SWRD on 9/5/17.
//  Copyright © 2017 Roy. All rights reserved.
//

#import "AppDelegate.h"
#import "HBWeatherViewController.h"

@interface AppDelegate ()

@property (nonatomic,strong) HBWeatherViewController *weatherVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _weatherVC = [[HBWeatherViewController alloc] init];
    
    self.window.rootViewController = _weatherVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
