//
//  HBWeatherViewController.m
//  CleanWeather
//
//  Created by SWRD on 9/5/17.
//  Copyright © 2017 Roy. All rights reserved.
//

#import "HBWeatherViewController.h"
#import "HBWeatherInfo.h"
#import "HBWeatherView.h"
#import "HBSavedCityViewController.h"
#import "DBManager.h"
#import "HBCityStore.h"
#import "MJRefresh.h"
#import "UILabel+HBLabel.h"
#import "HBDownloadWeather.h"

#define SCREEN_WIDTH self.view.bounds.size.width
#define SCREEN_HEIGHT self.view.bounds.size.height

@interface HBWeatherViewController () <HBCityDelegate> {
    UILabel *_cityLabel;
    UIView *_footView;
    UIPageControl *_pageControl;
}

@property (nonatomic,strong) HBWeatherView *weatherView;

@property (nonatomic,strong) HBWeatherInfo *weatherInfo;

@end

@implementation HBWeatherViewController

- (instancetype)init{
    self = [super init];
    
    if (self) {
        _weatherInfo = [[HBWeatherInfo alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self addGesture];
    
    //首次启动时
    if ([[[HBCityStore sharedStore] allCitys] count] > 0) {
        _cityLabel.text = [[HBCityStore sharedStore] allCitys][0];
        _pageControl.numberOfPages = [[[HBCityStore sharedStore] allCitys] count];
        _pageControl.currentPage = 0;
    }
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackGround"]];
}

- (void)setupUI{
    _cityLabel = [UILabel titleLabel];
    _cityLabel.frame = CGRectMake(0, 30, SCREEN_WIDTH, 20);
    [self.view addSubview:_cityLabel];
    
    _weatherView = [[HBWeatherView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 80)];
    [self.view addSubview:_weatherView];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestWeatherInfo)];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开以刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中" forState:MJRefreshStateRefreshing];
    
    header.stateLabel.textColor = [UIColor whiteColor];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    _weatherView.mj_header = header;
    
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 30)];
    _footView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_footView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.frame = CGRectMake(10, 5, 300, 20);
    [_footView addSubview:_pageControl];
    
    UIButton *cityInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityInfoBtn.frame = CGRectMake(SCREEN_WIDTH - 40, 5, 20, 20);
    [cityInfoBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [cityInfoBtn setImage:[UIImage imageNamed:@"menu_highlight"] forState:UIControlStateHighlighted];
    [cityInfoBtn addTarget:self action:@selector(showCityInfoTable) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:cityInfoBtn];
}

- (void)addGesture{
    UISwipeGestureRecognizer *swipeToRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeCity:)];
    swipeToRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeToRightGesture];
    
    UISwipeGestureRecognizer *swipeToLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeCity:)];
    swipeToLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeToLeftGesture];
}

- (void)showCityWeather:(NSString *)city{
    _cityLabel.text = city;
    
    _pageControl.numberOfPages = [[[HBCityStore sharedStore] allCitys] count];
    _pageControl.currentPage = [[[HBCityStore sharedStore] allCitys] indexOfObjectIdenticalTo:city];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self getWeatherInfoData];
}

- (void)getWeatherInfoData{
    //每次从网络获取天气之前先从本地读取，本地没有再去从网络获取
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //首次启动还没有添加城市时cityLabel为空，加个判断
    NSString *city = _cityLabel.text;
    if (city) {
        NSString *code = [[DBManager sharedManager] queryCityCode:city];
        NSString *filePath = [[HBCityStore sharedStore] singleCityWeatherPath:code];
        
        if ([fileManager fileExistsAtPath:filePath]) {
            self.weatherInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            NSLog(@"filePath = %@ , city = %@",filePath,city);
            if (self.weatherInfo) {
                [self updateWeatherView:self.weatherInfo];
            } else {
                NSLog(@"从本地读取 %@ 天气信息失败,转从网络获取!",city);
                [self requestWeatherInfo];
            }
        } else {
            [self requestWeatherInfo];
        }
    }
}

- (void)requestWeatherInfo{
    NSString *cityName = _cityLabel.text;
    if (cityName) {
        NSString *cityCode = [[DBManager sharedManager] queryCityCode:cityName];
        
        [[HBDownloadWeather sharedDownload] downloadWeatherInfoForCity:cityCode completion:^(HBWeatherInfo *weatherInfo, NSError *error) {
            if (weatherInfo && !error) {
                self.weatherInfo = weatherInfo;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateWeatherView:self.weatherInfo];
                });
                
                //每次刷新完将该城市天气信息保存到本地
                if ([self saveWeatherInfo:self.weatherInfo forCity:cityCode]) {
                    NSLog(@"保存 %@ 天气到本地成功",cityName);
                } else {
                    NSLog(@"保存 %@ 天气到本地失败",cityName);
                }
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"出问题了！" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
    }
    
    [_weatherView.mj_header endRefreshing];
}

- (void)updateWeatherView:(HBWeatherInfo *)weatherInfo{
    self.weatherView.weatherInfo = weatherInfo;
    NSLog(@"height = %f",self.weatherView.height);
    self.weatherView.contentOffset = CGPointMake(0, 0);
    self.weatherView.contentSize = CGSizeMake(SCREEN_WIDTH, self.weatherView.height);
    
    if ([weatherInfo.weatherDescription containsString:@"晴"]) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackGround"]];
    } else {
        self.view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    }
}

- (void)changeCity:(UISwipeGestureRecognizer *)gesture{
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        [self transitionAnimation:NO];
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self transitionAnimation:YES];
    }
}

- (void)swipeToChangeCity:(BOOL)isNext{
    NSArray *allCitys = [[HBCityStore sharedStore] allCitys];
    
    int currentIndex = (int)_pageControl.currentPage;
    
    int index;
    if (isNext) {
        index = (currentIndex + (int)[allCitys count] + 1) % (int)[allCitys count];
    } else {
        index = (currentIndex + (int)[allCitys count] - 1) % (int)[allCitys count];
    }
    
    _pageControl.currentPage = index;
    
    NSString *city = allCitys[index];
    _cityLabel.text = city;
}

//转场动画
-(void)transitionAnimation:(BOOL)isNext{
    CATransition *transition=[[CATransition alloc] init];
    
    transition.type = @"push";
    
    //设置子类型
    if (isNext) {
        transition.subtype = @"fromRight";
    }else{
        transition.subtype = @"fromLeft";
    }
    //设置动画时长
    transition.duration = 1.0f;
    
    [self swipeToChangeCity:isNext];
    [self getWeatherInfoData];
    
    [_weatherView.layer addAnimation:transition forKey:@"transitionAnimation"];
}

- (void)showCityInfoTable{
    HBSavedCityViewController *savedCityVC = [[HBSavedCityViewController alloc] init];
    savedCityVC.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:savedCityVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (BOOL)saveWeatherInfo:(HBWeatherInfo *)weatherInfo forCity:(NSString *)city{
    NSString *singleCityPath = [[HBCityStore sharedStore] singleCityWeatherPath:city];
    NSLog(@"singleCityPath = %@",singleCityPath);
    
    return [NSKeyedArchiver archiveRootObject:weatherInfo toFile:singleCityPath];
}

@end
