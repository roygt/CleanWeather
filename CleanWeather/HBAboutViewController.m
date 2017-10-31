//
//  HBAboutViewController.m
//  CleanWeather
//
//  Created by SWRD on 10/31/17.
//  Copyright © 2017 Roy. All rights reserved.
//

#import "HBAboutViewController.h"
#import "UIImage+HBImage.h"

#define SCREEN_WIDTH self.view.bounds.size.width
#define SCREEN_HEIGHT self.view.bounds.size.height

@interface HBAboutViewController (){
    UILabel *_titleLabel;
    UIImageView *_imageView;
    UILabel *_nameLabel;
    UILabel *_thanksLabel;
}

@end

@implementation HBAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    [self showAboutInfo];
}

- (void)setupUI{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(10, 30, self.view.bounds.size.width - 20, 30);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_titleLabel];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.frame = CGRectMake(130, 80, 60, 60);
    [self.view addSubview:_imageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.frame = CGRectMake(10, 150, self.view.bounds.size.width - 20, 30);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_nameLabel];
    
    _thanksLabel = [[UILabel alloc] init];
    _thanksLabel.frame = CGRectMake(10, 200, self.view.bounds.size.width - 20, SCREEN_HEIGHT - 200 - 25);
    _thanksLabel.numberOfLines = 0;
    _thanksLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _thanksLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_thanksLabel];
    
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissBtn.frame = CGRectMake(15, SCREEN_HEIGHT - 25, 20, 20);
    [dismissBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissBtn];
}

- (void)showAboutInfo{
    _titleLabel.text = @"关于";
    _imageView.image = [[UIImage imageNamed:@"103"] imageWithColor:[UIColor blackColor]];
    _nameLabel.text = @"CleanWeather - 1.0.3";
    
    //UILabel文字顶端对齐--在文本后面加多一些\n，简单粗暴，但\n后面加个空格，否则多余的\n会被忽略
    _thanksLabel.text = @"引用\n\nFMDB\nhttps://github.com/ccgus/fmdb\n\nMJRefresh\nhttps://github.com/CoderMJLee/MJRefresh\n\nBubbleTransition\nhttps://github.com/andreamazz/BubbleTransition\n\nIconfont\nhttp://www.iconfont.cn/ \n \n \n \n \n \n \n \n \n \n \n \n \n \n ";
}

- (void)dismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
