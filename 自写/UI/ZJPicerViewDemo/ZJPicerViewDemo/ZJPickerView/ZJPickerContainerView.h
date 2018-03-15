//
//  ZJPickerContainerView.h
//  supercx
//
//  Created by luozhijun on 15-5-6.
//  Copyright (c) 2015年 linuxiao. All rights reserved.
//  选择菜单的基类

#import <UIKit/UIKit.h>

static const CGFloat ZJPickerContainerViewTopBarHeight = 33.f;
static const CGFloat ZJPickerContainerViewInternalPickerHeight = 216.f;
static const CGFloat ZJPickerContainerViewAnimationDuration = 0.3f;

@class ZJPickerContainerView;

@protocol ZJPickerContainerViewDelegate <NSObject>
@optional
/** 点击“完成”按钮时调用 */
- (void)pickerContainerView:(ZJPickerContainerView *)pickerView topBarDoneButtonClick:(UIBarButtonItem *)item;
- (void)pickerContainerViewDidShow:(ZJPickerContainerView *)picker;
@end

/** 选择菜单的基类 */
@interface ZJPickerContainerView : UIView

@property (nonatomic, weak) UIToolbar *topBar;
@property (nonatomic, weak) UIView *internalPickerContainerView;
@property (nonatomic, weak) id<ZJPickerContainerViewDelegate> delegate;

+ (instancetype)instance;
/** 显示，如果没有父视图，默认加在窗口上 */
- (void)show:(BOOL)animated;
/** 隐藏，会从父视图移除，如果想要保留，需strong引用 */
- (void)hide:(BOOL)animated;
@end
