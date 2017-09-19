//
//  HBAddCityViewController.m
//  CleanWeather
//
//  Created by SWRD on 9/5/17.
//  Copyright © 2017 Roy. All rights reserved.
//

#import "HBAddCityViewController.h"
#import "DBManager.h"
#import "HBCityStore.h"

@interface HBAddCityViewController () <UISearchBarDelegate>

@property (nonatomic,copy) NSArray *allCitys;
@property (nonatomic,retain) NSMutableArray *filteredCitys;

@end

@implementation HBAddCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self loadCityInfo];
}

- (void)setupUI{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackGround"]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissVC)];
    self.navigationItem.rightBarButtonItem = cancelBarBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, 255, 44)];
    searchBar.delegate = self;
    searchBar.placeholder = @"输入要查找的城市名";
    [searchBar sizeToFit];
    [self.navigationController.navigationBar addSubview:searchBar];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)loadCityInfo{
    NSArray *cityArray = [[DBManager sharedManager] allChinaCitys];
    self.allCitys = cityArray;
    
    self.filteredCitys = [[NSMutableArray alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.filteredCitys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allCitys"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"allCitys"];
    }

    NSString *filterName = self.filteredCitys[indexPath.row];
    cell.textLabel.text = filterName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *savedCity = [[HBCityStore sharedStore] allCitys];
    
    NSString *selectedFilterCity = self.filteredCitys[indexPath.row];
    
    if ([savedCity containsObject:selectedFilterCity]) {
        NSLog(@"之前已经添加过 %@!",selectedFilterCity);
    } else {
        BOOL isFilterCitySaved = [[HBCityStore sharedStore] addNewCity:selectedFilterCity];
        if (isFilterCitySaved) {
            NSLog(@"保存 %@ 成功!",selectedFilterCity);
        } else {
            NSLog(@"保存 %@ 失败!",selectedFilterCity);
        }
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissVC{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.filteredCitys removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",searchText];
    NSArray *match = [self.allCitys filteredArrayUsingPredicate:predicate];
    [self.filteredCitys addObjectsFromArray:match];
    NSLog(@"%@",self.filteredCitys);
    
    [self.tableView reloadData];
}

@end
