//
//  HBWeatherView.m
//  CleanWeather
//
//  Created by SWRD on 9/5/17.
//  Copyright © 2017 Roy. All rights reserved.
//

#import "HBWeatherView.h"
#import "UIImage+HBImage.h"
#import "UILabel+HBLabel.h"

#define VIEW_WIDTH self.bounds.size.width
#define CONTROL_SPACE 10

#define HBTEMPLABEL_WIDTH 30
#define HBTEMPLABEL_HEIGHT HBTEMPLABEL_WIDTH
#define HBTEMPLABEL_OFFSET_X 10
#define HBTEMPLABEL_OFFSET_Y 30

#define WEATHERICON_WIDTH 60
#define WEATHERICON_HEIGHT WEATHERICON_WIDTH

#define INFOLABEL_HEIGHT 20
#define SUGGESTLABEL_HEIGHT 48

#define IMAGE_WIDTH 120
#define IMAGE_HEIGHT IMAGE_WIDTH

#define SUGGEST_IMAGE_WIDTH 48
#define SUGGEST_IMAGE_HEIGHT SUGGEST_IMAGE_WIDTH

@interface HBWeatherView () <CAAnimationDelegate> {
    UILabel *_weatherDescriptionLabel; //天气描述，ex,多云，晴
    UILabel *_lastUpdatedTimeLabel; //上次刷新时间
    UILabel *_currentTemperatureLabel; //当前温度
    
    UIView *_threeDaysWeatherChart; //3日天气折线图
    CAShapeLayer *_dotLayerLow;
    CAShapeLayer *_dotLayerHigh;
    
    //风和湿度
    UILabel *_windTitleLabel;
    UIImageView *_windImageView;
    UILabel *_windDirectionLabel;
    UILabel *_windPowerLabel;
    UILabel *_windSpeedLabel;
    UILabel *_wetLabel;
    
    //空气质量指数
    UILabel *_weatherQualityTitleLabel;
    UIImageView *_weatherQualityImageView;
    UILabel *_PM25Label;
    UILabel *_PM10Label;
    UILabel *_SO2Label;
    UILabel *_NO2Label;
    UILabel *_weatherQualityLabel;
    
    //日出和日落
    UILabel *_sunTitleLabel;
    UIImageView *_sunImageView;
    UILabel *_sunRiseLabel;
    UILabel *_SunDownLabel;
    
    //生活指数
    UILabel *_lifeTitleLabel;
    UIImageView *_comfortImageView;
    UILabel *_comfortLabel;
    UIImageView *_carWashImageView;
    UILabel *_carWashLabel;
    UIImageView *_dressImageView;
    UILabel *_dressLabel;
    UIImageView *_fluImageView;
    UILabel *_fluLabel;
    UIImageView *_sportImageView;
    UILabel *_sportLabel;
    UIImageView *_travelImageView;
    UILabel *_travelLabel;
    UIImageView *_uvImageView;
    UILabel *_uvLabel;
    
    //天气信息来源
    UILabel *_weatherSource;
}

//折线图上的温度信息
@property (nonatomic,retain) NSMutableArray *lowTempArray;
@property (nonatomic,retain) NSMutableArray *highTempArray;

@property (nonatomic,retain) NSMutableArray *dateLabelArray; //未来3天的日期
@property (nonatomic,retain) NSMutableArray *weatherIconArray; //未来3天的天气图标
@property (nonatomic,retain) NSMutableArray *weatherDesArray; //未来3天的天气描述

@end

@implementation UIImageView (HBImageView)

+ (UIImageView *)HB_imageView{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return imageView;
}

@end

@implementation HBWeatherView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _lowTempArray = [[NSMutableArray alloc] initWithCapacity:3];
        _highTempArray = [[NSMutableArray alloc] initWithCapacity:3];
        _dateLabelArray = [[NSMutableArray alloc] initWithCapacity:3];
        _weatherIconArray = [[NSMutableArray alloc] initWithCapacity:3];
        _weatherDesArray = [[NSMutableArray alloc] initWithCapacity:3];
        
        for (int i = 0; i < 3; i++) {
            UILabel *label = [UILabel tempLabel];
            [_lowTempArray addObject:label];
        }
        
        for (int i = 0; i < 3; i++) {
            UILabel *label = [UILabel tempLabel];
            [_highTempArray addObject:label];
        }
        
        for (int i = 0; i < 3; i++) {
            UILabel *label = [UILabel tempLabel];
            [_dateLabelArray addObject:label];
        }
        
        for (int i = 0; i < 3; i++) {
            UILabel *label = [UILabel tempLabel];
            [_weatherDesArray addObject:label];
        }
        
        for (int i = 0; i < 3; i++) {
            UIImageView *imageView = [UIImageView HB_imageView];
            [_weatherIconArray addObject:imageView];
        }
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI{
    //天气描述，ex,多云，晴
    _weatherDescriptionLabel = [UILabel titleLabel];
    [self addSubview:_weatherDescriptionLabel];
    
    //上次刷新时间
    _lastUpdatedTimeLabel = [UILabel tempLabel];
    [self addSubview:_lastUpdatedTimeLabel];
    
    //当前温度
    _currentTemperatureLabel = [UILabel titleLabel];
    _currentTemperatureLabel.font = [UIFont systemFontOfSize:50];
    [self addSubview:_currentTemperatureLabel];
    
    //3日天气折线图
    _threeDaysWeatherChart = [[UIView alloc] init];
    [self addSubview:_threeDaysWeatherChart];
    
    _dotLayerLow = [CAShapeLayer layer];
    _dotLayerLow.strokeColor = [UIColor whiteColor].CGColor;
    _dotLayerLow.fillColor = [UIColor clearColor].CGColor;
    _dotLayerLow.lineWidth = 2;
    
    _dotLayerHigh = [CAShapeLayer layer];
    _dotLayerHigh.strokeColor = [UIColor whiteColor].CGColor;
    _dotLayerHigh.fillColor = [UIColor clearColor].CGColor;
    _dotLayerHigh.lineWidth = 2;
    
    for (int i = 0; i < 3; i++) {
        [_threeDaysWeatherChart addSubview:(UILabel *)_lowTempArray[i]];
        [_threeDaysWeatherChart addSubview:(UILabel *)_highTempArray[i]];
        
        [self addSubview:(UILabel *)_dateLabelArray[i]];
        [self addSubview:(UILabel *)_weatherIconArray[i]];
        [self addSubview:(UILabel *)_weatherDesArray[i]];
    }
    
    //风和湿度
    _windTitleLabel = [UILabel titleLabel];
    _windImageView = [UIImageView HB_imageView];
    _windDirectionLabel = [UILabel infoLabel];
    _windPowerLabel = [UILabel infoLabel];
    _windSpeedLabel = [UILabel infoLabel];
    _wetLabel = [UILabel infoLabel];
    [self addSubview:_windTitleLabel];
    [self addSubview:_windImageView];
    [self addSubview:_windDirectionLabel];
    [self addSubview:_windPowerLabel];
    [self addSubview:_windSpeedLabel];
    [self addSubview:_wetLabel];
    
    //空气质量指数
    _weatherQualityTitleLabel = [UILabel titleLabel];
    _weatherQualityImageView = [UIImageView HB_imageView];
    _PM25Label = [UILabel infoLabel];
    _PM10Label = [UILabel infoLabel];
    _SO2Label = [UILabel infoLabel];
    _NO2Label = [UILabel infoLabel];
    _weatherQualityLabel = [UILabel infoLabel];
    [self addSubview:_weatherQualityTitleLabel];
    [self addSubview:_weatherQualityImageView];
    [self addSubview:_PM25Label];
    [self addSubview:_PM10Label];
    [self addSubview:_SO2Label];
    [self addSubview:_NO2Label];
    [self addSubview:_weatherQualityLabel];
    
    //日出和日落
    _sunTitleLabel = [UILabel titleLabel];
    _sunImageView = [UIImageView HB_imageView];
    _sunRiseLabel = [UILabel infoLabel];
    _SunDownLabel = [UILabel infoLabel];
    [self addSubview:_sunTitleLabel];
    [self addSubview:_sunImageView];
    [self addSubview:_sunRiseLabel];
    [self addSubview:_SunDownLabel];
    
    //生活指数
    _lifeTitleLabel = [UILabel titleLabel];
    _comfortLabel = [UILabel infoLabel];
    _carWashLabel = [UILabel infoLabel];
    _dressLabel = [UILabel infoLabel];
    _fluLabel = [UILabel infoLabel];
    _sportLabel = [UILabel infoLabel];
    _travelLabel = [UILabel infoLabel];
    _uvLabel = [UILabel infoLabel];
    _comfortImageView = [UIImageView HB_imageView];
    _carWashImageView = [UIImageView HB_imageView];
    _dressImageView = [UIImageView HB_imageView];
    _fluImageView = [UIImageView HB_imageView];
    _sportImageView = [UIImageView HB_imageView];
    _travelImageView = [UIImageView HB_imageView];
    _uvImageView = [UIImageView HB_imageView];
    [self addSubview:_lifeTitleLabel];
    [self addSubview:_comfortLabel];
    [self addSubview:_carWashLabel];
    [self addSubview:_dressLabel];
    [self addSubview:_fluLabel];
    [self addSubview:_sportLabel];
    [self addSubview:_travelLabel];
    [self addSubview:_uvLabel];
    [self addSubview:_comfortImageView];
    [self addSubview:_carWashImageView];
    [self addSubview:_dressImageView];
    [self addSubview:_fluImageView];
    [self addSubview:_sportImageView];
    [self addSubview:_travelImageView];
    [self addSubview:_uvImageView];
    
    //天气信息来源
    _weatherSource = [UILabel titleLabel];
    [self addSubview:_weatherSource];
}

- (void)setWeatherInfo:(HBWeatherInfo *)weatherInfo{
    //天气描述，ex,多云，晴
    _weatherDescriptionLabel.frame = CGRectMake(0, 10, VIEW_WIDTH, INFOLABEL_HEIGHT);
    _weatherDescriptionLabel.text = weatherInfo.weatherDescription;
    
    //上次刷新时间
    _lastUpdatedTimeLabel.frame = CGRectMake(220, 10, 100, INFOLABEL_HEIGHT);
    _lastUpdatedTimeLabel.text = weatherInfo.lastUpdatedTime;
    
    //当前温度
    CGFloat currentTemperatureLabelY = CGRectGetMaxY(_weatherDescriptionLabel.frame) + CONTROL_SPACE;
    _currentTemperatureLabel.frame = CGRectMake(0, currentTemperatureLabelY, VIEW_WIDTH, 100);
    _currentTemperatureLabel.text = weatherInfo.currentTemperature;
    
    //3日天气折线图
    NSNumber *highestNumber = [[weatherInfo.convert_maxTempOfThreeDays sortedArrayUsingSelector:@selector(compare:)] lastObject];
    CGFloat threeDaysWeatherChartY = CGRectGetMaxY(_currentTemperatureLabel.frame) + CONTROL_SPACE;
    _threeDaysWeatherChart.frame = CGRectMake(0, threeDaysWeatherChartY, VIEW_WIDTH, highestNumber.floatValue + 20);
    //1.设置折线图
    _dotLayerLow.frame = CGRectMake(0, 0, _threeDaysWeatherChart.frame.size.width, _threeDaysWeatherChart.frame.size.height);
    _dotLayerLow.path = [self layerPathWithConvertedArrayY:weatherInfo.convert_minTempOfThreeDays originArrayY:weatherInfo.minTempOfThreeDays];
    if ([_threeDaysWeatherChart.layer.sublayers containsObject:_dotLayerLow]) {
        [_dotLayerLow removeFromSuperlayer];
    }
    [_threeDaysWeatherChart.layer addSublayer:_dotLayerLow];
    [self animationWithLayer:_dotLayerLow];
    
    _dotLayerHigh.frame = CGRectMake(0, 0, _threeDaysWeatherChart.frame.size.width, _threeDaysWeatherChart.frame.size.height);
    _dotLayerHigh.path = [self layerPathWithConvertedArrayY:weatherInfo.convert_maxTempOfThreeDays originArrayY:weatherInfo.maxTempOfThreeDays];
    if ([_threeDaysWeatherChart.layer.sublayers containsObject:_dotLayerHigh]) {
        [_dotLayerHigh removeFromSuperlayer];
    }
    [_threeDaysWeatherChart.layer addSublayer:_dotLayerHigh];
    [self animationWithLayer:_dotLayerHigh];
    //2.设置温度Label
    NSArray *pointX = @[@60,@160,@260];
    CGFloat height = _threeDaysWeatherChart.bounds.size.height;
    for (int i = 0; i < 3; i++) {
        //[(UILabel *)_lowTempArray[i] setText:[weatherInfo.minTempOfThreeDays[i] stringValue]];
        [(UILabel *)_lowTempArray[i] setText:[NSString stringWithFormat:@"%@º",weatherInfo.minTempOfThreeDays[i]]];
        [(UILabel *)_lowTempArray[i] setFrame:CGRectMake([pointX[i] floatValue] - HBTEMPLABEL_OFFSET_X, height - [weatherInfo.convert_minTempOfThreeDays[i] floatValue] - HBTEMPLABEL_OFFSET_Y, HBTEMPLABEL_WIDTH, HBTEMPLABEL_HEIGHT)];
        
        //[(UILabel *)_highTempArray[i] setText:[weatherInfo.maxTempOfThreeDays[i] stringValue]];
        [(UILabel *)_highTempArray[i] setText:[NSString stringWithFormat:@"%@º",weatherInfo.maxTempOfThreeDays[i]]];
        [(UILabel *)_highTempArray[i] setFrame:CGRectMake([pointX[i] floatValue] - HBTEMPLABEL_OFFSET_X, height - [weatherInfo.convert_maxTempOfThreeDays[i] floatValue] - HBTEMPLABEL_OFFSET_Y, HBTEMPLABEL_WIDTH, HBTEMPLABEL_HEIGHT)];
    }
    
    //未来3天的日期
    CGFloat dateLabeY = CGRectGetMaxY(_threeDaysWeatherChart.frame) + CONTROL_SPACE;
    for (int i = 0; i < 3; i++) {
        [(UILabel *)_dateLabelArray[i] setText:weatherInfo.dateOfThreeDays[i]];
        [(UILabel *)_dateLabelArray[i] setFrame:CGRectMake([pointX[i] floatValue] - 30, dateLabeY, 60, 20)];
    }
    
    //未来3天的天气图标
    CGFloat weatherIconY = CGRectGetMaxY([(UILabel *)_dateLabelArray[0] frame]) + CONTROL_SPACE;
    for (int i = 0; i < 3; i++) {
        //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:weatherInfo.weatherIconOfThreeDays[i]]]];
        UIImage *image = [UIImage imageNamed:weatherInfo.weatherIconOfThreeDays[i]];
        [(UIImageView *)_weatherIconArray[i] setImage:[image imageWithColor:[UIColor whiteColor]]];
        [(UIImageView *)_weatherIconArray[i] setFrame:CGRectMake([pointX[i] floatValue] - 30, weatherIconY, WEATHERICON_WIDTH, WEATHERICON_HEIGHT)];
    }
    
    //未来3天的天气描述
    CGFloat weatherDesY = CGRectGetMaxY([(UIImageView *)_weatherIconArray[0] frame]) + CONTROL_SPACE;
    for (int i = 0; i < 3; i++) {
        [(UILabel *)_weatherDesArray[i] setText:weatherInfo.weatherDesOfThreeDays[i]];
        [(UILabel *)_weatherDesArray[i] setFrame:CGRectMake([pointX[i] floatValue] - 30, weatherDesY, 60, 20)];
    }
    
    //风和湿度
    CGFloat windTitleY = CGRectGetMaxY([(UILabel *)_weatherDesArray[0] frame]) + CONTROL_SPACE * 2;
    _windTitleLabel.frame = CGRectMake(0, windTitleY, VIEW_WIDTH, INFOLABEL_HEIGHT);
    _windTitleLabel.text = @"风和湿度";
    
    CGFloat windImageY = CGRectGetMaxY(_windTitleLabel.frame) + CONTROL_SPACE;
    _windImageView.frame = CGRectMake(10, windImageY, IMAGE_WIDTH, IMAGE_HEIGHT);
    _windImageView.image = [UIImage imageNamed:@"风车"];
    
    CGFloat windDirY = windImageY;
    CGFloat windDirX = CGRectGetMaxX(_windImageView.frame) + CONTROL_SPACE;
    _windDirectionLabel.frame = CGRectMake(windDirX, windDirY, VIEW_WIDTH - windDirX - 10, INFOLABEL_HEIGHT);
    _windDirectionLabel.text = weatherInfo.windDirection;
    
    CGFloat windPowerX = windDirX;
    CGFloat windPowerY = CGRectGetMaxY(_windDirectionLabel.frame) + CONTROL_SPACE;
    _windPowerLabel.frame = CGRectMake(windPowerX, windPowerY, VIEW_WIDTH - windPowerX - 10, INFOLABEL_HEIGHT);
    _windPowerLabel.text = weatherInfo.windPower;
    
    CGFloat windSpeedX = windPowerX;
    CGFloat windSpeedY = CGRectGetMaxY(_windPowerLabel.frame) + CONTROL_SPACE;
    _windSpeedLabel.frame = CGRectMake(windSpeedX, windSpeedY, VIEW_WIDTH - windSpeedX - 10, INFOLABEL_HEIGHT);
    _windSpeedLabel.text = weatherInfo.windSpeed;
    
    CGFloat wetLabelX = windSpeedX;
    CGFloat wetLabelY = CGRectGetMaxY(_windSpeedLabel.frame) + CONTROL_SPACE;
    _wetLabel.frame = CGRectMake(wetLabelX, wetLabelY, VIEW_WIDTH - wetLabelX - 10, INFOLABEL_HEIGHT);
    _wetLabel.text = weatherInfo.wetLevel;
    
    //空气质量指数
    CGFloat weatherQualityTitleY = CGRectGetMaxY(_windImageView.frame) + CONTROL_SPACE * 2;
    _weatherQualityTitleLabel.frame = CGRectMake(0, weatherQualityTitleY, VIEW_WIDTH, INFOLABEL_HEIGHT);
    _weatherQualityTitleLabel.text = @"空气质量指数";
    
    CGFloat weatherQualityImageY = CGRectGetMaxY(_weatherQualityTitleLabel.frame) + CONTROL_SPACE;
    _weatherQualityImageView.frame = CGRectMake(10, weatherQualityImageY, IMAGE_WIDTH, IMAGE_HEIGHT);
    _weatherQualityImageView.image = [UIImage imageNamed:@"空气质量"];
    
    CGFloat weatherQulityY = CGRectGetMaxY(_weatherQualityImageView.frame) + CONTROL_SPACE;
    _weatherQualityLabel.frame = CGRectMake(10, weatherQulityY, IMAGE_WIDTH, INFOLABEL_HEIGHT);
    _weatherQualityLabel.text = weatherInfo.weatherQuality;
    
    CGFloat PM25X = CGRectGetMaxX(_weatherQualityImageView.frame) + CONTROL_SPACE;
    CGFloat PM25Y = weatherQualityImageY + 20;
    _PM25Label.frame = CGRectMake(PM25X, PM25Y, VIEW_WIDTH - PM25X - 10, INFOLABEL_HEIGHT);
    _PM25Label.text = weatherInfo.pm25;
    
    CGFloat PM10X = PM25X;
    CGFloat PM10Y = CGRectGetMaxY(_PM25Label.frame) + CONTROL_SPACE;
    _PM10Label.frame = CGRectMake(PM10X, PM10Y, VIEW_WIDTH - PM10X - 10, INFOLABEL_HEIGHT);
    _PM10Label.text = weatherInfo.pm10;
    
    CGFloat SO2X = PM10X;
    CGFloat SO2Y = CGRectGetMaxY(_PM10Label.frame) + CONTROL_SPACE;
    _SO2Label.frame = CGRectMake(SO2X, SO2Y, VIEW_WIDTH - SO2X - 10, INFOLABEL_HEIGHT);
    _SO2Label.text = weatherInfo.so2;
    
    CGFloat NO2X = SO2X;
    CGFloat NO2Y = CGRectGetMaxY(_SO2Label.frame) + CONTROL_SPACE;
    _NO2Label.frame = CGRectMake(NO2X, NO2Y, VIEW_WIDTH - NO2X - 10, INFOLABEL_HEIGHT);
    _NO2Label.text = weatherInfo.no2;
    
    //日出和日落
    CGFloat sunTitleY = CGRectGetMaxY(_weatherQualityLabel.frame) + CONTROL_SPACE * 2;
    _sunTitleLabel.frame = CGRectMake(0, sunTitleY, VIEW_WIDTH, INFOLABEL_HEIGHT);
    _sunTitleLabel.text = @"日出和日落";
    
    CGFloat sunImageY = CGRectGetMaxY(_sunTitleLabel.frame) + CONTROL_SPACE;
    _sunImageView.frame = CGRectMake(10, sunImageY, IMAGE_WIDTH, IMAGE_HEIGHT);
    _sunImageView.image = [UIImage imageNamed:@"日出"];
    
    CGFloat sunRiseX = CGRectGetMaxX(_sunImageView.frame) + CONTROL_SPACE;
    CGFloat sunRiseY = sunImageY + 30;
    _sunRiseLabel.frame = CGRectMake(sunRiseX, sunRiseY, VIEW_WIDTH - sunRiseX - 10, INFOLABEL_HEIGHT);
    _sunRiseLabel.text = weatherInfo.sunRise;
    
    CGFloat sunDownX = sunRiseX;
    CGFloat sunDownY = CGRectGetMaxY(_sunRiseLabel.frame) + CONTROL_SPACE;
    _SunDownLabel.frame = CGRectMake(sunDownX, sunDownY, VIEW_WIDTH - sunDownX - 10, INFOLABEL_HEIGHT);
    _SunDownLabel.text = weatherInfo.sunGoesDown;
    
    //生活指数
    CGFloat lifeTitleY = CGRectGetMaxY(_sunImageView.frame) + CONTROL_SPACE * 2;
    _lifeTitleLabel.frame = CGRectMake(0, lifeTitleY, VIEW_WIDTH, INFOLABEL_HEIGHT);
    _lifeTitleLabel.text = @"生活指数";
    
    CGFloat comfortImageY = CGRectGetMaxY(_lifeTitleLabel.frame) + CONTROL_SPACE;
    _comfortImageView.frame = CGRectMake(10, comfortImageY, SUGGEST_IMAGE_WIDTH, SUGGEST_IMAGE_HEIGHT);
    _comfortImageView.image = [UIImage imageNamed:@"舒适指数"];
    
    CGFloat comfortY = comfortImageY;
    CGFloat comfortX = CGRectGetMaxX(_comfortImageView.frame) + CONTROL_SPACE;
    _comfortLabel.frame = CGRectMake(comfortX, comfortY, VIEW_WIDTH - comfortX - 10, SUGGESTLABEL_HEIGHT);
    _comfortLabel.text = weatherInfo.comfortSuggest;
    
    CGFloat carWashImageY = CGRectGetMaxY(_comfortImageView.frame) + CONTROL_SPACE;
    _carWashImageView.frame = CGRectMake(10, carWashImageY, SUGGEST_IMAGE_WIDTH, SUGGEST_IMAGE_HEIGHT);
    _carWashImageView.image = [UIImage imageNamed:@"洗车指数"];
    
    CGFloat carWashY = carWashImageY;
    CGFloat carWashX = CGRectGetMaxX(_carWashImageView.frame) + CONTROL_SPACE;
    _carWashLabel.frame = CGRectMake(carWashX, carWashY, VIEW_WIDTH - carWashX - 10, SUGGESTLABEL_HEIGHT);
    _carWashLabel.text = weatherInfo.carWashSuggest;
    
    CGFloat dressImageY = CGRectGetMaxY(_carWashImageView.frame) + CONTROL_SPACE;
    _dressImageView.frame = CGRectMake(10, dressImageY, SUGGEST_IMAGE_WIDTH, SUGGEST_IMAGE_HEIGHT);
    _dressImageView.image = [UIImage imageNamed:@"穿衣指数"];
    
    CGFloat dressY = dressImageY;
    CGFloat dressX = CGRectGetMaxX(_dressImageView.frame) + CONTROL_SPACE;
    _dressLabel.frame = CGRectMake(dressX, dressY, VIEW_WIDTH - dressX - 10, SUGGESTLABEL_HEIGHT);
    _dressLabel.text = weatherInfo.dressSuggest;
    
    CGFloat fluImageY = CGRectGetMaxY(_dressImageView.frame) + CONTROL_SPACE;
    _fluImageView.frame = CGRectMake(10, fluImageY, SUGGEST_IMAGE_WIDTH, SUGGEST_IMAGE_HEIGHT);
    _fluImageView.image = [UIImage imageNamed:@"流感指数"];
    
    CGFloat fluY = fluImageY;
    CGFloat fluX = CGRectGetMaxX(_fluImageView.frame) + CONTROL_SPACE;
    _fluLabel.frame = CGRectMake(fluX, fluY, VIEW_WIDTH - fluX - 10, SUGGESTLABEL_HEIGHT);
    _fluLabel.text = weatherInfo.fluSuggest;
    
    CGFloat sportImageY = CGRectGetMaxY(_fluImageView.frame) + CONTROL_SPACE;
    _sportImageView.frame = CGRectMake(10, sportImageY, SUGGEST_IMAGE_WIDTH, SUGGEST_IMAGE_HEIGHT);
    _sportImageView.image = [UIImage imageNamed:@"运动指数"];
    
    CGFloat sportY = sportImageY;
    CGFloat sportX = CGRectGetMaxX(_sportImageView.frame) + CONTROL_SPACE;
    _sportLabel.frame = CGRectMake(sportX, sportY, VIEW_WIDTH - sportX - 10, SUGGESTLABEL_HEIGHT);
    _sportLabel.text = weatherInfo.sportSuggest;
    
    CGFloat travelImageY = CGRectGetMaxY(_sportImageView.frame) + CONTROL_SPACE;
    _travelImageView.frame = CGRectMake(10, travelImageY, SUGGEST_IMAGE_WIDTH, SUGGEST_IMAGE_HEIGHT);
    _travelImageView.image = [UIImage imageNamed:@"旅游指数"];
    
    CGFloat travelY = travelImageY;
    CGFloat travelX = CGRectGetMaxX(_travelImageView.frame) + CONTROL_SPACE;
    _travelLabel.frame = CGRectMake(travelX, travelY, VIEW_WIDTH - travelX - 10, SUGGESTLABEL_HEIGHT);
    _travelLabel.text = weatherInfo.travelSuggest;
    
    CGFloat uvImageY = CGRectGetMaxY(_travelImageView.frame) + CONTROL_SPACE;
    _uvImageView.frame = CGRectMake(10, uvImageY, SUGGEST_IMAGE_WIDTH, SUGGEST_IMAGE_HEIGHT);
    _uvImageView.image = [UIImage imageNamed:@"紫外线指数"];
    
    CGFloat uvY = uvImageY;
    CGFloat uvX = CGRectGetMaxX(_uvImageView.frame) + 10;
    _uvLabel.frame = CGRectMake(uvX, uvY, VIEW_WIDTH - uvX - 10, SUGGESTLABEL_HEIGHT);
    _uvLabel.text = weatherInfo.uvSuggest;
    
    //天气信息来源
    CGFloat weatherSourceY = CGRectGetMaxY(_uvLabel.frame) + CONTROL_SPACE * 2;
    _weatherSource.frame = CGRectMake(0, weatherSourceY, VIEW_WIDTH, INFOLABEL_HEIGHT);
    _weatherSource.text = @"天气信息来源：和风天气";
    
    _height = CGRectGetMaxY(_weatherSource.frame) + CONTROL_SPACE;
}

- (CGMutablePathRef)layerPathWithConvertedArrayY:(NSArray *)convertedArray originArrayY:(NSArray *)originArray{
    NSArray *pointX = @[@60,@160,@260];
    CGFloat height = _threeDaysWeatherChart.bounds.size.height;
    
    CGMutablePathRef path = CGPathCreateMutable();
    for (int i = 0; i < 3; i++) {
        if (i == 0) {
            CGPathMoveToPoint(path, nil, [pointX[i] floatValue], height - [convertedArray[i] floatValue]);
        } else {
            CGPathAddLineToPoint(path, nil, [pointX[i] floatValue], height - [convertedArray[i] floatValue]);
        }
    }
    
    return path;
}

- (void)animationWithLayer:(CAShapeLayer *)shapeLayer{
    for (id subview in _threeDaysWeatherChart.subviews) {
        if ([subview class] == [UILabel class]) {
            [subview setHidden:YES];
        }
    }
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    basicAnimation.toValue = [NSNumber numberWithFloat:1.0];
    basicAnimation.duration = 2.0;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.delegate = self;
    
    [shapeLayer addAnimation:basicAnimation forKey:@"basic"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    for (id subview in _threeDaysWeatherChart.subviews) {
        if ([subview class] == [UILabel class]) {
            [subview setHidden:NO];
        }
    }
}

@end
