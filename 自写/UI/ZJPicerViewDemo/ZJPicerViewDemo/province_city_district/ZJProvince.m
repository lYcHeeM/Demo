//
//  BGYProvince.m
//  mobiportal
//
//  Created by luozhijun on 14-12-12.
//  Copyright (c) 2014年 bgyun. All rights reserved.
//

#import "ZJProvince.h"

@implementation ZJProvince

#pragma mark - ZJPickerViewRowProtocol
- (id<ZJPickerViewComponent>)subComponent
{
    if (self.cities.count) {
        return self.cities[0];
    }
    return nil;
}

- (NSArray<ZJPickerViewRow> *)rows
{
    return (NSArray<ZJPickerViewRow> *)self.cities;
}

@end
