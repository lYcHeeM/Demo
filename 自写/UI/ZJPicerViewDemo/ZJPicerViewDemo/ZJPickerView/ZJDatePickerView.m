//
//  ZJDatePickerView.m
//  mobiportal
//
//  Created by JC.Wang on 14/11/23.
//  Copyright (c) 2014年 bgyun. All rights reserved.
//

#import "ZJDatePickerView.h"

@interface ZJDatePickerView ()

@end

@implementation ZJDatePickerView

+ (instancetype)datePickerView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIDatePicker *picker = [[UIDatePicker alloc] init];
        picker.backgroundColor = [UIColor whiteColor];
        picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        picker.datePickerMode = UIDatePickerModeDateAndTime;
        [self.internalPickerContainerView addSubview:picker];
        self.datePicker = picker;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.datePicker.frame = self.internalPickerContainerView.bounds;
}

@end
