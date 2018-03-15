//
//  UIColor+ZJ.m
//  UILabelLineHeighText
//
//  Created by luozhijun on 15-1-21.
//  Copyright (c) 2015年 bgyun. All rights reserved.
//

#import "UIColor+ZJ.h"

@implementation UIColor (ZJ)

- (BOOL)isEqualToColor:(UIColor *)color
{
    CGFloat red1 = 0, green1 = 0, blue1 = 0, alpha1 = 0;
    CGFloat red2 = 0, green2 = 0, blue2 = 0, alpha2 = 0;
    
    [self getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    [color getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    if (double_equal(red1, red2) && double_equal(green1, green2) && double_equal(blue1, blue2) && double_equal(alpha1, alpha2)) {
        return YES;
    } else {
        return NO;
    }
}

+ (instancetype)RGBAColorWithRGBAColor:(UIColor *)aRGBAColor
{
    CGFloat red = 0, green = 0, blue = 0, alpha = 0;
    [aRGBAColor getRed:&red green:&green blue:&blue alpha:&alpha];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
