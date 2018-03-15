//
//  UIColor+ZJ.h
//  UILabelLineHeighText
//
//  Created by luozhijun on 15-1-21.
//  Copyright (c) 2015年 bgyun. All rights reserved.
//

#import <UIKit/UIKit.h>

static inline bool double_equal(double a, double b)
{
    if (fabs(a - b) < 1e-6) {
        return true;
    } else {
        return false;
    }
}

@interface UIColor (ZJ)

- (BOOL)isEqualToColor:(UIColor *)color;
+ (instancetype)RGBAColorWithRGBAColor:(UIColor *)aRGBAColor;

@end
