//
//  HBWeatherInfo.h
//  CleanWeather
//
//  Created by SWRD on 9/5/17.
//  Copyright © 2017 Roy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBWeatherInfo : NSObject <NSCoding>

@property (nonatomic,copy) NSString *weatherDescription; //天气描述，eg，多云，晴
@property (nonatomic,copy) NSString *lastUpdatedTime; //上次刷新时间
@property (nonatomic,copy) NSString *currentTemperature; //当前温度

@property (nonatomic,copy) NSArray *minTempOfThreeDays; //未来3天的最低温度
@property (nonatomic,copy) NSArray *maxTempOfThreeDays; //未来3天的最高温度
@property (nonatomic,copy) NSArray *convert_minTempOfThreeDays; //未来3天的最低温度,转化后
@property (nonatomic,copy) NSArray *convert_maxTempOfThreeDays; //未来3天的最高温度，转化后
@property (nonatomic,copy) NSArray *dateOfThreeDays; //未来3天日期
@property (nonatomic,copy) NSArray *weatherDesOfThreeDays; //未来3天天气描述，eg，多云，晴
@property (nonatomic,copy) NSArray *weatherIconOfThreeDays; //未来3天天气图标，存放的是IconCode,eg,100,101

@property (nonatomic,copy) NSString *windDirection; //风向
@property (nonatomic,copy) NSString *windPower; //风力
@property (nonatomic,copy) NSString *windSpeed; //风速
@property (nonatomic,copy) NSString *wetLevel; //湿度

@property (nonatomic,copy) NSString *pm25; //PM2.5
@property (nonatomic,copy) NSString *pm10; //PM10
@property (nonatomic,copy) NSString *so2; //二氧化硫
@property (nonatomic,copy) NSString *no2; //二氧化氮
@property (nonatomic,copy) NSString *weatherQuality; //空气质量

@property (nonatomic,copy) NSString *sunRise; //日出时间
@property (nonatomic,copy) NSString *sunGoesDown; //日落时间

@property (nonatomic,copy) NSString *comfortSuggest; //舒适指数
@property (nonatomic,copy) NSString *carWashSuggest; //洗车指数
@property (nonatomic,copy) NSString *dressSuggest; //穿衣指数
@property (nonatomic,copy) NSString *fluSuggest; //流感指数
@property (nonatomic,copy) NSString *sportSuggest; //运动指数
@property (nonatomic,copy) NSString *travelSuggest; //旅行指数
@property (nonatomic,copy) NSString *uvSuggest; //紫外线指数

@end
