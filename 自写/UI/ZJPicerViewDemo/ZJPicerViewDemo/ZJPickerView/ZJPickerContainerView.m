//
//  ZJPickerView.m
//  supercx
//
//  Created by luozhijun on 15-5-6.
//  Copyright (c) 2015年 linuxiao. All rights reserved.
//

#import "ZJPickerContainerView.h"

@implementation ZJPickerContainerView

+ (instancetype)instance
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 40;
        
        // 顶部的工具条
        UIToolbar *topBar = [[UIToolbar alloc] init];
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"完成   "/** 右侧加空格是为了在右边留一点间距 */ style:UIBarButtonItemStylePlain target:self action:@selector(topBarDoneClick:)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        topBar.items = @[space, done];
        [self addSubview:topBar];
        self.topBar = topBar;
        
        // 填充整个窗口
        self.frame = [UIScreen mainScreen].bounds;
        
        // contentView
        UIView *internalPickerContainerView = [[UIView alloc] init];
        [self addSubview:internalPickerContainerView];
        self.internalPickerContainerView = internalPickerContainerView;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:[UIScreen mainScreen].bounds];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置internalPickerContentView的frame，默认在最底部
    CGFloat internalPickerContentViewY = self.frame.size.height - ZJPickerContainerViewInternalPickerHeight;
    self.internalPickerContainerView.frame = CGRectMake(0, internalPickerContentViewY, self.frame.size.width, ZJPickerContainerViewInternalPickerHeight);
    
    // 设置topBar的frame
    CGFloat topBarY = internalPickerContentViewY - ZJPickerContainerViewTopBarHeight;
    self.topBar.frame = CGRectMake(0, topBarY, self.frame.size.width, ZJPickerContainerViewTopBarHeight);
}

- (void)show:(BOOL)animated
{
    if (!self.superview) { // 如果没有父视图，加在窗口上
        [[[UIApplication sharedApplication].windows lastObject] addSubview:self];
    }
    
    if (!animated) return;
    
    CGFloat minimumHeight = ZJPickerContainerViewInternalPickerHeight + ZJPickerContainerViewTopBarHeight;
    self.transform = CGAffineTransformMakeTranslation(0, minimumHeight);
    [UIView animateWithDuration:ZJPickerContainerViewAnimationDuration animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(pickerContainerViewDidShow:)]) {
            [self.delegate pickerContainerViewDidShow:self];
        }
    }];
}

- (void)hide:(BOOL)animated
{
    if (!animated) {
        [self removeFromSuperview];
    }
    else {
        CGFloat minimumHeight = ZJPickerContainerViewInternalPickerHeight + ZJPickerContainerViewTopBarHeight;
        [UIView animateWithDuration:ZJPickerContainerViewAnimationDuration animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, minimumHeight);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - -监听按钮点击
- (void)topBarDoneClick:(UIBarButtonItem *)item
{
    [self hide:YES];
    if ([self.delegate respondsToSelector:@selector(pickerContainerView:topBarDoneButtonClick:)]) {
        [self.delegate pickerContainerView:self topBarDoneButtonClick:item];
    }
}

@end
