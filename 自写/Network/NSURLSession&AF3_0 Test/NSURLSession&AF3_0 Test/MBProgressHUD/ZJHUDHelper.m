//
//  ZJHUDHelper.m
//  NSURLSession&AF3_0 Test
//
//  Created by luozhijun on 15/10/27.
//  Copyright © 2015年 luozhijun. All rights reserved.
//

#import "ZJHUDHelper.h"

@implementation ZJHUDHelper
+ (void)baseSettingForHUD:(MBProgressHUD *)hud
{
    hud.margin = kHUDDefaultMargin;
    hud.minSize = CGSizeMake(80, 60);
    hud.cornerRadius = 5.f;
    hud.labelFont = kHUDDefaultLabelFont;
    hud.dimBackground = NO;
    hud.userInteractionEnabled = NO;
    
    // 白色背景
    //    hud.labelColor = RGBColor(64, 64, 64, 1.0);
    //    hud.activityIndicatorColor = hud.labelColor;
    //    hud.color = RGBColor(195, 195, 195, 0.9);
}

#pragma mark - - show hud
#pragma mark 显示信息
+ (id)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [self baseSettingForHUD:hud];
    // 设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    hud.labelText = text;
    [[NSNotificationCenter defaultCenter] postNotificationName:MBProgressHUDDidAddToSuperViewNotification object:nil];
    // 1秒之后再消失
    [hud hide:YES afterDelay:kHUDDefaultHideDelay];
    return hud;
}

#pragma mark 显示错误信息
+ (id)showError:(NSString *)error toView:(UIView *)view{
    return [self show:error icon:@"error.png" view:view];
}

+ (id)showSuccess:(NSString *)success toView:(UIView *)view
{
    return [self show:success icon:@"success" view:view];
}

#pragma mark 显示一些信息
+ (id)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [self baseSettingForHUD:hud];
    hud.labelText = message;
    return hud;
}

+ (id)showText:(NSString *)text toView:(UIView *)view
{
    MBProgressHUD *hud = [self showMessage:text toView:view];
    hud.mode = MBProgressHUDModeText;
    return hud;
}

+ (id)showSuccess:(NSString *)success
{
    return [self showSuccess:success toView:nil];
}

+ (id)showError:(NSString *)error
{
    return [self showError:error toView:nil];
}

+ (id)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (id)showText:(NSString *)text
{
    return [self showText:text toView:nil];
}

#pragma mark - hide hud

+ (void)hideHUD:(id)hud animated:(BOOL)animated
{
    [hud hide:animated];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)hideAllHUDForView:(UIView *)view
{
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
}

+ (void)hideAllHUDOnWindow
{
    [self hideAllHUDForView:nil];
}

#pragma mark - hide hud with delay
+ (void)hideHUD:(id)hud delay:(NSTimeInterval)delay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hide:YES];
    });
}

+ (void)hideHUDAfterDefaultDelay:(id)hud
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kHUDDefaultHideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hide:YES];
    });
}

+ (void)hideHUDAfterDefaultDelayOnView:(UIView *)view
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kHUDDefaultHideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHUDForView:view];
    });
}

+ (void)hideHUDAfterDefaultDelayOnWindow
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kHUDDefaultHideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHUDForView:nil];
    });
}

+ (void)hideAllHUDAfterDefaultDelayOnView:(UIView *)view
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kHUDDefaultHideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideAllHUDForView:view];
    });
}

+ (void)hideAllHUDAfterDefaultDelayOnWindow
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kHUDDefaultHideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideAllHUDAfterDefaultDelayOnView:nil];
    });
}

#pragma mark -
+ (UIImage *)errorImage
{
    return [UIImage imageNamed:@"MBProgressHUD.bundle/error"];
}

+ (UIImage *)successImage
{
    return [UIImage imageNamed:@"MBProgressHUD.bundle/success"];
}

+ (void)showProgressAnimationOnView:(UIView *)containerView startAfterDelay:(CGFloat)delay coverBackgroundColor:(UIColor *)coverColor accessBlock:(void(^)(id hud, UIImageView *animationView, UIView *cover))block
{
    // 0.判断view是否为空
    if (containerView == nil) {
        containerView = [[UIApplication sharedApplication].windows lastObject];
    }
    
    UIView *cover = [[UIView alloc] init];
    cover.frame = containerView.bounds;
    //    ZJLog(@"%@", NSStringFromCGSize(((UIScrollView *)containerView).contentSize));
    if ([containerView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)containerView;
        if (scrollView.contentSize.height > scrollView.frame.size.height) {
            CGRect coverFrame = cover.frame;
            coverFrame.size.height = scrollView.contentSize.height + 64.f;
            cover.frame = coverFrame;
        } else /* if (scrollView.frame.size.height == 0)*/ { // 考虑到scrollView可能使用了autolayout, 在未显示的时候frame拿不到, 这种情况下cover的大小默认为窗口的两倍大小.
            cover.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2);
        }
    }
    
    if (coverColor) {
        cover.backgroundColor = coverColor;
    } else {
        cover.backgroundColor = [UIColor whiteColor];
    }
    
    // 1.创建动画imageView
    UIImageView *animationView = [[UIImageView alloc] init];
    CGFloat centerX = containerView.frame.size.width / 2;
    CGFloat centerY = containerView.frame.size.height / 2;
    CGFloat animationViewWH = 120;
    animationView.bounds = CGRectMake(0, 0, animationViewWH, animationViewWH);
    animationView.center = CGPointMake(centerX, centerY);
    
    // 2.动画所需的图片
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < 28; ++i) {
        NSString *name = [NSString stringWithFormat:@"loading3_%02d.png", i + 1];
        UIImage *image = [UIImage imageNamed:name];
        [images addObject:image];
    }
    animationView.animationImages = images;
    animationView.animationDuration = 2.0;
    animationView.animationRepeatCount = 0;
    
    // 3.加在HUD上
    __block MBProgressHUD *hud = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 如果有动画会延时添加到containView
        // 这样可能会导致画面一闪
        hud = [MBProgressHUD showHUDAddedTo:containerView animated:NO];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = animationView;
        hud.color = [UIColor clearColor];
        if (cover.frame.size.height < hud.frame.size.height) { // 也许有的时候cover的高度小于hud, 这是会出现部分区域未遮盖的情况, 因为MBProgressHUD是充满它的容器view的, 所以把hud的背景色暂时置为白色也许能解决问题.
            hud.backgroundColor = coverColor;
        }
        // 把遮盖插入到hud的最下面
        [hud insertSubview:cover atIndex:0];
        [animationView startAnimating];
        
        if ([containerView isKindOfClass:[UIScrollView class]]) {
            // 添加一个滑动手势, 屏蔽scrollView的滚动
            [hud addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(disableScrollOfContainerView)]];
        }
        
        if (containerView.frame.size.height < [UIScreen mainScreen].bounds.size.height) {
            //            CGFloat hudCenterYOffset = kScreenHeight - containerView.frame.size.height;
            //            hud.yOffset -= containerView.frame.origin.y + hudCenterYOffset;
            //            CGFloat hudExtraHeight = kScreenHeight - containerView.frame.size.height;
            //            CGRect hudFrame = hud.frame;
            //            hudFrame.size.height += hudExtraHeight;
            //            hud.frame = hudFrame;
        } else if (containerView == [[UIApplication sharedApplication].windows lastObject]) {
            hud.yOffset -= 64.f / 2;
        }
        
        // 传给外界
        block(hud, animationView, cover);
    });
}

+ (void)startProgressAnimationOnViewAfterDefaultDelay:(UIView *)view coverBackgroundColor:(UIColor *)coverColor accessBlock:(void(^)(id hud, UIImageView *animationView, UIView *cover))block
{
    return [self showProgressAnimationOnView:view startAfterDelay:0.25 coverBackgroundColor:coverColor accessBlock:block];
}

+ (void)disableScrollOfContainerView
{
    
}

@end
