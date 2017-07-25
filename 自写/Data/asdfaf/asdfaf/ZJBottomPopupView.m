//
//  ZJBottomPopupView.m
//  DDFinance
//
//  Created by luozhijun on 15/12/2.
//  Copyright © 2015年 DDFinance. All rights reserved.
//

#import "ZJBottomPopupView.h"
#import "ZJCover.h"

#ifndef ZJMainColor
#define ZJMainColor [UIColor purpleColor]
#endif

#ifndef RGBAColor
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#endif

#ifndef ZJSeparatorColor
#define ZJSeparatorColor RGBAColor(208, 208, 208, 1.0)  /**  228, 228, 228 */
#endif

#define ZJSeparatorWidth (1.0/[UIScreen mainScreen].scale)

@interface ZJBottomPopupView ()
@property (nonatomic, strong) UIButton    *closeButton;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIImageView *topSeparator;
@property (nonatomic, strong) ZJCover     *cover;
@property (nonatomic, assign) CGFloat     topAreaHeight;
@end

@implementation ZJBottomPopupView

@dynamic delegate;

- (instancetype)initWithPopHeight:(CGFloat)popHeight title:(NSString *)title
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        if (popHeight > 0) {
            _popHeight = popHeight;
        } else {
            _popHeight = [UIScreen mainScreen].bounds.size.height * 0.75;
        }
        _title = [title copy];
        _animationDuration = 0.35f;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat padding_10 = 10.f;
        _topAreaHeight = ([UIScreen mainScreen].bounds.size.width - 320.0 <= 0.1) ? 44 : 50;
        
        _minimumPopHeight = padding_10 + _topAreaHeight + padding_10;
        _popHeight = _minimumPopHeight;
        _animationDuration = 0.35f;
        
        // closeButton
        self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.closeButton setImage:[UIImage imageNamed:@"ZJPopupView.bundle/btn_close"] forState:UIControlStateNormal];
        [self.closeButton sizeToFit];
        self.closeButton.tintColor = ZJMainColor;
        [self.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeButton];
        
        // titleLabel
        self.titleLabel = [UILabel new];
        [self addSubview:self.titleLabel];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.text = _title;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        // topSeparator
        self.topSeparator = [UIImageView new];
        [self addSubview:self.topSeparator];
        self.topSeparator.backgroundColor = [UIColor grayColor];
        self.topSeparator.bounds = CGRectMake(0, 0, 0, ZJSeparatorWidth);
        
        // cover
        self.cover = [ZJCover new];
    }
    return self;
}

- (UIActivityIndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_indicator];
    }
    return _indicator;
}

- (UIView *)indicatorCover
{
    if (!_indicatorCover) {
        _indicatorCover = [UIView new];
        _indicatorCover.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        [self addSubview:_indicatorCover];
    }
    return _indicatorCover;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding_10 = 10.f;
//    CGFloat closeButtonY = (topAreaHeight - self.closeButton.bounds.size.height) / 2.f;
    self.closeButton.frame = (CGRect){CGPointMake(2, 0), CGSizeMake(_topAreaHeight, _topAreaHeight)};
    
    CGFloat titleLabelHeight = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    CGFloat titleLabelY = (_topAreaHeight - titleLabelHeight) / 2.f;
    CGFloat titleLabelX = CGRectGetMaxX(self.closeButton.frame) + padding_10;
    CGFloat titleLabelWidth = self.frame.size.width - 2 * titleLabelX;
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelWidth, titleLabelHeight);
    
    self.topSeparator.frame = CGRectMake(0, _topAreaHeight, self.frame.size.width, self.topSeparator.bounds.size.height);
    
    _indicatorCover.frame = CGRectMake(0, CGRectGetMaxY(self.topSeparator.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(self.topSeparator.frame));
    _indicator.center = _indicatorCover.center;
}

- (void)closeButtonClicked
{
    [self hide:YES];
}

- (void)showOnView:(UIView *)superView animated:(BOOL)animated
{
    if (self.isShowing) {
        return;
    }
    
    if (!self.superview) {
        [superView addSubview:self.cover];
        self.cover.frame = superView.bounds;
        
        [superView addSubview:self];
        self.frame = CGRectMake(0, superView.bounds.size.height - self.popHeight, superView.bounds.size.width, self.popHeight);
        
        _showing = YES;
    }
    
    if (!animated) return;
    
    CGFloat transformHeight = self.popHeight;
    self.transform = CGAffineTransformMakeTranslation(0, transformHeight);
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.transform = CGAffineTransformIdentity;
        self.cover.alpha = self.cover.translucentAlpha;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(zj_popupViewDidShow:)]) {
            [self.delegate zj_popupViewDidShow:self];
        }
        if (self.didShowCallback) {
            self.didShowCallback();
        }
    }];
}

- (void)show:(BOOL)animated
{
    [self showOnView:[UIApplication sharedApplication].windows.lastObject animated:animated];
}

- (void)hide:(BOOL)animated
{
    if (!self.superview) {
        return;
    }
    
    void (^didHideOperation)(void) = ^{
        [self.cover removeFromSuperview];
        [self removeFromSuperview];
        _showing = NO;
        if ([self.delegate respondsToSelector:@selector(zj_popupViewDidHide:)]) {
            [self.delegate zj_popupViewDidHide:self];
        }
        if (self.didHideCallback) {
            self.didHideCallback();
        }
    };
    
    if ([self.delegate respondsToSelector:@selector(zj_popupViewShouldHide:)]) {
        if (![self.delegate zj_popupViewShouldHide:self]) return;
    }
    if (self.shouldHideCallback) {
        if (!self.shouldHideCallback()) return;
    }
    
    if (!animated) {
        didHideOperation();
        return;
    } else {
        CGFloat transformHeight = self.popHeight;
        [UIView animateWithDuration:self.animationDuration animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, transformHeight);
            self.cover.alpha = 0.f;
        } completion:^(BOOL finished) {
            self.transform = CGAffineTransformIdentity;
            didHideOperation();
        }];
    }
}

@end
