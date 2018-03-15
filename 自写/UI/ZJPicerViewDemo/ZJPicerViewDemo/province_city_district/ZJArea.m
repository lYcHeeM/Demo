//
//  BGYArea.m
//  mobiportal
//
//  Created by luozhijun on 14-12-12.
//  Copyright (c) 2014年 bgyun. All rights reserved.
//

#import "ZJArea.h"

@implementation ZJArea

#pragma mark - ZJPickerViewRowProtocol
- (NSString *)titleForRow
{
    return self.AreaName;
}

- (void)setTitleForRow:(NSString *)titleForRow
{
    self.AreaName = titleForRow;
}

- (void)setSubComponent:(id<ZJPickerViewComponent>)subComponent
{
    
}

- (id<ZJPickerViewComponent>)subComponent
{
    return nil;
}

- (void)setRows:(NSArray<ZJPickerViewRow> *)rows
{
    
}

- (NSArray<ZJPickerViewRow> *)rows
{
    return nil;
}


@end
