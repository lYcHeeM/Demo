//
//  ZJPickerContainerView.h
//  supercx
//
//  Created by luozhijun on 15-5-6.
//  Copyright (c) 2015年 linuxiao. All rights reserved.
//  选择菜单的基类

#import <UIKit/UIKit.h>

static const CGFloat k_iPhone5_ScreenHeight     = 568.0f;
static const CGFloat ZJPickerContainerViewTopBarHeight = 36.f;
static const CGFloat ZJPickerContainerViewAnimationDuration = 0.3f;

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define ZJPickerContainerViewInternalPickerHeight (216.f / k_iPhone5_ScreenHeight * kScreenHeight)

@class ZJPickerContainerView;

@protocol ZJPickerContainerViewDelegate <NSObject>
@optional
/** 点击“完成”按钮时调用 */
- (void)zj_pickerContainerView:(ZJPickerContainerView *)pickerContainer topBarDoneButtonClick:(UIBarButtonItem *)item;
- (void)zj_pickerContainerView:(ZJPickerContainerView *)pickerContainer topBarCancelButtonClick:(UIBarButtonItem *)item;
- (BOOL)zj_pickerContainerViewShouldShow:(ZJPickerContainerView *)pickerContainer;
- (void)zj_pickerContainerViewDidShow:(ZJPickerContainerView *)pickerContainer;
@end

/** 选择菜单的基类 */
@interface ZJPickerContainerView : UIView

@property (nonatomic, weak) UIToolbar *topBar;
@property (nonatomic, weak) UIView *internalPickerContainerView;
@property (nonatomic, strong) UILabel *indicatorHint;

@property (nonatomic, weak) id<ZJPickerContainerViewDelegate> delegate;
@property (readonly, nonatomic, assign) BOOL isShowing;

+ (instancetype)instance;
- (instancetype)initWithIndicatorHint:(NSString *)indicatorHint;

/** 显示，如果没有父视图，默认加在窗口上 */
- (void)show:(BOOL)animated;
/** 隐藏，会从父视图移除，如果想要保留，需strong引用 */
- (void)hide:(BOOL)animated;

/** 显示显示，如果没有父视图，默认加在窗口上, 如果self.indicatorHint.text有值, 则加载indicator遮盖并开始动画 */
- (void)show:(BOOL)animated indicatorHint:(NSString *)hint;

- (void)startIndicatorAnimation;
- (void)stopIndicatorAnimation;
@end
