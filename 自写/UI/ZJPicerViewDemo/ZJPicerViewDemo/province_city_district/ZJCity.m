//
//  BGYCity.m
//  mobiportal
//
//  Created by luozhijun on 14-12-12.
//  Copyright (c) 2014年 bgyun. All rights reserved.
//

#import "ZJCity.h"

@implementation ZJCity

#pragma mark - ZJPickerViewRowProtocol
- (id<ZJPickerViewComponent>)subComponent
{
    if (self.districts.count) {
        return self.districts[0];
    }
    return nil;
}

- (NSArray<ZJPickerViewRow> *)rows
{
    return (NSArray<ZJPickerViewRow> *)self.districts;
}

@end
