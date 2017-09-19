//
//  HBSavedCityViewController.m
//  CleanWeather
//
//  Created by SWRD on 9/5/17.
//  Copyright © 2017 Roy. All rights reserved.
//

#import "HBSavedCityViewController.h"
#import "HBCityStore.h"
#import "HBAddCityViewController.h"
#import "DBManager.h"
#import "HBWeatherInfo.h"

@interface HBSavedCityViewController ()

@end

@implementation HBSavedCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackGround"]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationItem.title = @"城市";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewCity)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.tableView.rowHeight = 50;
    self.tableView.separatorColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)addNewCity{
    HBAddCityViewController *addCityVC = [[HBAddCityViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addCityVC];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[HBCityStore sharedStore] allCitys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SavedCitys"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SavedCitys"];
    }
    
    NSString *cityName = [[HBCityStore sharedStore] allCitys][indexPath.row];
    cell.textLabel.text = cityName;
    cell.detailTextLabel.text = [self getLocalWeatherInfo:cityName];
    
    return cell;
}

- (NSString *)getLocalWeatherInfo:(NSString *)cityName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    HBWeatherInfo *weatherInfo = [[HBWeatherInfo alloc] init];
    
    NSString *code = [[DBManager sharedManager] queryCityCode:cityName];
    NSString *filePath = [[HBCityStore sharedStore] singleCityWeatherPath:code];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        weatherInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        NSLog(@"filePath = %@ , city = %@",filePath,cityName);
        if (weatherInfo) {
            return weatherInfo.currentTemperature;
        } else {
            NSLog(@"从本地读取 %@ 天气信息失败!",cityName);
            return @"N/A";
        }
    } else {
        return @"N/A";
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *cityName = [[HBCityStore sharedStore] allCitys][indexPath.row];
        
        BOOL isRemoved = [[HBCityStore sharedStore] removeCity:cityName];
        if (isRemoved) {
            NSLog(@"删除 %@ 成功!",cityName);
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            NSLog(@"删除 %@ 失败!",cityName);
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selectedCity = [[HBCityStore sharedStore] allCitys][indexPath.row];
    
    //调用代理传参
    [self.delegate showCityWeather:selectedCity];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
