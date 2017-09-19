//
//  UILabel+HBLabel.m
//  CleanWeather
//
//  Created by Roy_Liu on 10/09/2017.
//  Copyright © 2017 Roy. All rights reserved.
//

#import "UILabel+HBLabel.h"

@implementation UILabel (HBLabel)

+ (UILabel *)infoLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:13];
    
    return label;
}

+ (UILabel *)titleLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    
    return label;
}

+ (UILabel *)tempLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    
    return label;
}

@end
