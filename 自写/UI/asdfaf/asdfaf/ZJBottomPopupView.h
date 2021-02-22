//
//  ZJBottomPopupView.h
//  DDFinance
//
//  Created by luozhijun on 15/12/2.
//  Copyright © 2015年 DDFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJCover.h"

@protocol ZJBottomPopupViewDelegate;

/** 从底部弹出的view */
@interface ZJBottomPopupView : UIToolbar
{
    UIView *_indicatorCover;
    UIActivityIndicatorView *_indicator;
}

@property (nonatomic, assign) CGFloat popHeight;
@property (nonatomic, assign) CGFloat minimumPopHeight;
/** Default is 0.35 */
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, weak) id<ZJBottomPopupViewDelegate> delegate;
@property (nonatomic, copy) void (^didShowCallback)(void);
@property (nonatomic, copy) BOOL (^shouldHideCallback)(void);
@property (nonatomic, copy) void (^didHideCallback)(void);

@property (nonatomic, assign, readonly, getter=isShowing) BOOL showing;

@property (nonatomic, strong, readonly) UIButton    *closeButton;
@property (nonatomic, strong, readonly) UILabel     *titleLabel;
@property (nonatomic, strong, readonly) UIImageView *topSeparator;
@property (nonatomic, strong, readonly) UIView      *indicatorCover;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicator;

- (instancetype)initWithPopHeight:(CGFloat)popHeight title:(NSString *)title;

- (void)showOnView:(UIView *)superView animated:(BOOL)animated;
- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
@end

@protocol ZJBottomPopupViewDelegate <UIToolbarDelegate>
@optional
- (void)zj_popupViewDidShow:(ZJBottomPopupView *)view;
- (BOOL)zj_popupViewShouldHide:(ZJBottomPopupView *)view;
- (void)zj_popupViewDidHide:(ZJBottomPopupView *)hide;
@end



