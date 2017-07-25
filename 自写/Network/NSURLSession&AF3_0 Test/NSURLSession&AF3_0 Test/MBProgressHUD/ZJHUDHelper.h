//
//  ZJHUDHelper.h
//  NSURLSession&AF3_0 Test
//
//  Created by luozhijun on 15/10/27.
//  Copyright © 2015年 luozhijun. All rights reserved.
//

#import "MBProgressHUD.h"

static const CGFloat kHUDDefaultHideDelay = 1.2f;
static const CGFloat kHUDDefaultMargin = 10.f;
#define kHUDDefaultLabelFont [UIFont boldSystemFontOfSize:14]

@interface ZJHUDHelper : NSObject

#pragma mark - show hud
+ (id)showSuccess:(NSString *)success toView:(UIView *)view;
+ (id)showError:(NSString *)error toView:(UIView *)view;

+ (id)showMessage:(NSString *)message toView:(UIView *)view;
+ (id)showText:(NSString *)text toView:(UIView *)view;

+ (id)showSuccess:(NSString *)success;
+ (id)showError:(NSString *)error;

+ (id)showMessage:(NSString *)message;
+ (id)showText:(NSString *)text;

#pragma mark - hide hud
+ (void)hideHUD:(id)hud animated:(BOOL)animated;
+ (void)hideHUDForView:(UIView *)view;
+ (void)hideAllHUDForView:(UIView *)view;
+ (void)hideAllHUDOnWindow;

#pragma mark - hide hud with delay
+ (void)hideHUD:(id)hud delay:(NSTimeInterval)delay;
+ (void)hideHUDAfterDefaultDelay:(id)hud;
+ (void)hideHUDAfterDefaultDelayOnView:(UIView *)view;
+ (void)hideHUDAfterDefaultDelayOnWindow;
+ (void)hideAllHUDAfterDefaultDelayOnView:(UIView *)view;
+ (void)hideAllHUDAfterDefaultDelayOnWindow;

/** 返回错误提示图片 */
+ (UIImage *)errorImage;
/** 返回成功提示图片 */
+ (UIImage *)successImage;

/**
 * 添加一个HUD, 在默认的延时后播放动画, 若要停止动画, 可直接隐藏HUD
 * @note 如果view为空, 则显示在窗口上
 */
+ (void)startProgressAnimationOnViewAfterDefaultDelay:(UIView *)view coverBackgroundColor:(UIColor *)coverColor accessBlock:(void(^)(id hud, UIImageView *animationView, UIView *cover))block;
/**
 * 添加一个HUD, 在指定的延时后播放动画, 若要停止动画, 可直接隐藏HUD
 * @note 如果view为空, 则显示在窗口上
 */
+ (void)showProgressAnimationOnView:(UIView *)view startAfterDelay:(CGFloat)delay coverBackgroundColor:(UIColor *)coverColor accessBlock:(void(^)(id hud, UIImageView *animationView, UIView *cover))block;

@end
