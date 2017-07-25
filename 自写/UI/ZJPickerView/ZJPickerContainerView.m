//
//  ZJPickerView.m
//  supercx
//
//  Created by luozhijun on 15-5-6.
//  Copyright (c) 2015年 linuxiao. All rights reserved.
//

#import "ZJPickerContainerView.h"
#import "ZJCover.h"

#ifndef RGBAColor
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#endif

#ifndef ZJMainColor
#define ZJMainColor RGBAColor(255, 102, 2, 1.0)
#endif

#ifndef ZJSeparatorColor
/** 列表分割线的颜色 */
#define ZJSeparatorColor RGBAColor(0xe4, 0xe4, 0xe4, 1.0)  // 228, 228, 228
#endif

@interface ZJPickerContainerView ()
@property (nonatomic, strong) ZJCover *cover;
@property (nonatomic, strong) UIView *indicatorCover;
@property (nonatomic, strong) UIActivityIndicatorView *internalIndicator;
@end

@implementation ZJPickerContainerView

+ (instancetype)instance
{
    return [[self alloc] init];
}

- (instancetype)initWithIndicatorHint:(NSString *)indicatorHint
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.indicatorHint.text = indicatorHint;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 顶部的工具条
        UIToolbar *topBar = [[UIToolbar alloc] init];
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"确定  "/** 右侧加空格是为了在右边留一点间距 */ style:UIBarButtonItemStylePlain target:self action:@selector(topBarDoneClick:)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"  取消" style:UIBarButtonItemStylePlain target:self action:@selector(topBarCancelClicked:)];
        topBar.items = @[cancel, space, done];
        [self addSubview:topBar];
        self.topBar = topBar;
        
        // 填充整个窗口
        self.frame = [UIScreen mainScreen].bounds;
        
        // contentView
        UIView *internalPickerContainerView = [[UIView alloc] init];
        [self addSubview:internalPickerContainerView];
        self.internalPickerContainerView = internalPickerContainerView;
        
        // 蒙板
        //        __weak typeof(self) weakSelf = self;
        self.cover = [[ZJCover alloc] init];
        //        self.cover.coverTapedBlock = ^(ZJCover *cover) {
        //            [weakSelf topBarDoneClick:nil];
        //        };
        
        // indicator
        self.indicatorCover = [[UIView alloc] init];
        self.indicatorCover.backgroundColor = [UIColor whiteColor];
        
        self.internalIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.internalIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.indicatorCover addSubview:self.internalIndicator];
        
        self.indicatorHint = [[UILabel alloc] init];
        self.indicatorHint.font = [UIFont systemFontOfSize:15];
        self.indicatorHint.textColor = RGBAColor(166, 166, 166, 1.0);
        [self.indicatorCover addSubview:self.indicatorHint];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGFloat height = ZJPickerContainerViewTopBarHeight + ZJPickerContainerViewInternalPickerHeight;
    CGRect fixedFrame = CGRectMake(0, kScreenHeight - height, kScreenWidth, height);
    [super setFrame:fixedFrame];
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
    
    // indicator
    self.indicatorCover.frame = self.internalPickerContainerView.bounds;
    CGFloat padding_8 = 8.f;
    CGFloat indicatorSize = 25.f;
    CGFloat interitemPadding = 2.f;
    CGFloat indicatorHintMaxWidth = self.indicatorCover.frame.size.width - indicatorSize - interitemPadding - 2 * padding_8;
    CGFloat indicatorHintNeedWidth = [self.indicatorHint.text boundingRectWithSize:CGSizeMake(indicatorHintMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.indicatorHint.font} context:nil].size.width;
    CGFloat indicatorX = (self.indicatorCover.frame.size.width - indicatorHintNeedWidth - interitemPadding - indicatorSize) / 2.f;
    self.internalIndicator.frame = CGRectMake(indicatorX, (self.indicatorCover.frame.size.height - indicatorSize) / 2.f, indicatorSize, indicatorSize);
    self.indicatorHint.frame = CGRectMake(indicatorX + indicatorSize + interitemPadding, self.internalIndicator.frame.origin.y, indicatorHintNeedWidth, indicatorSize);
}

- (void)show:(BOOL)animated
{
    if (![self.delegate zj_pickerContainerViewShouldShow:self]) {
        return;
    }
    
    /** superview是窗口时, 如果窗口因键盘退出而消失, 那么self.isShowing还是YES, 所以要加上对self.superview的判断 */
    if (self.superview && self.isShowing) {
        return;
    }
    
    UIView *superView = nil;
    if (!self.superview) { // 如果没有父视图，加在窗口上
        superView = [UIApplication sharedApplication].keyWindow;
        [superView addSubview:self.cover];
        [superView addSubview:self];
    } else {
        [self.superview insertSubview:self.cover belowSubview:self];
    }
    _isShowing = YES;
    self.cover.frame = self.cover.superview.bounds;
    self.cover.alpha = 0.25;
    
    if (!animated) return;
    
    CGFloat minimumHeight = ZJPickerContainerViewInternalPickerHeight + ZJPickerContainerViewTopBarHeight;
    self.transform = CGAffineTransformMakeTranslation(0, minimumHeight);
    [UIView animateWithDuration:ZJPickerContainerViewAnimationDuration animations:^{
        self.transform = CGAffineTransformIdentity;
        self.cover.alpha = self.cover.translucentAlpha;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(zj_pickerContainerViewDidShow:)]) {
            [self.delegate zj_pickerContainerViewDidShow:self];
        }
    }];
}

- (void)hide:(BOOL)animated
{
    if (!self.superview) {
        return;
    }
    
    if (!animated) {
        [self.cover removeFromSuperview];
        [self removeFromSuperview];
        _isShowing = NO;
    }
    else {
        CGFloat minimumHeight = ZJPickerContainerViewInternalPickerHeight + ZJPickerContainerViewTopBarHeight;
        [UIView animateWithDuration:ZJPickerContainerViewAnimationDuration animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, minimumHeight);
            self.cover.alpha = 0.f;
        } completion:^(BOOL finished) {
            [self.cover removeFromSuperview];
            [self removeFromSuperview];
            _isShowing = NO;
        }];
    }
    
//    [self stopIndicatorAnimation];
}

- (void)startIndicatorAnimation
{
    [self.internalPickerContainerView addSubview:self.indicatorCover];
    [self.internalIndicator startAnimating];
}

- (void)stopIndicatorAnimation
{
    [self.internalIndicator stopAnimating];
    [self.indicatorCover removeFromSuperview];
}

- (void)show:(BOOL)animated indicatorHint:(NSString *)hint
{
    [self show:animated];
    if (hint.length) {
        self.indicatorHint.text = hint;
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    if (self.indicatorHint.text.length) {
        [self startIndicatorAnimation];
    }
}

#pragma mark - -监听按钮点击
- (void)topBarDoneClick:(UIBarButtonItem *)item
{
    [self hide:YES];
    if ([self.delegate respondsToSelector:@selector(zj_pickerContainerView:topBarDoneButtonClick:)]) {
        [self.delegate zj_pickerContainerView:self topBarDoneButtonClick:item];
    }
}

- (void)topBarCancelClicked:(UIBarButtonItem *)item
{
    [self hide:YES];
    if ([self.delegate respondsToSelector:@selector(zj_pickerContainerView:topBarCancelButtonClick:)]) {
        [self.delegate zj_pickerContainerView:self topBarCancelButtonClick:item];
    }
}

@end
