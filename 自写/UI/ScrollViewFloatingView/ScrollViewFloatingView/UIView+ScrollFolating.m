//
//  UIView+ScrollFolating.m
//  ScrollViewFloatingView
//
//  Created by luozhijun on 15/12/3.
//  Copyright © 2015年 DDFinance. All rights reserved.
//

#import "UIView+ScrollFolating.h"
#import <objc/runtime.h>

static void *ZJScrollFloatingViewScrollViewKey        = &ZJScrollFloatingViewScrollViewKey;
static void *ZJScrollFloatingViewOriginalSuperViewKey = &ZJScrollFloatingViewOriginalSuperViewKey;
static void *ZJScrollFloatingViewFloatingSuperViewKey = &ZJScrollFloatingViewFloatingSuperViewKey;
static void *ZJScrollFloatingViewOriginalFrameKey     = &ZJScrollFloatingViewOriginalFrameKey;
static void *ZJScrollFloatingViewFloatingFrameKey     = &ZJScrollFloatingViewFloatingFrameKey;

@interface UIView ()
@property (nonatomic, strong) NSValue *zj_originalFrame;
@end

@implementation UIView (ScrollFolating)

- (void)setZj_scrollView:(UIScrollView *)zj_scrollView
{
    objc_setAssociatedObject(self, ZJScrollFloatingViewScrollViewKey, zj_scrollView, OBJC_ASSOCIATION_ASSIGN);
}
- (UIScrollView *)zj_scrollView
{
    return objc_getAssociatedObject(self, ZJScrollFloatingViewScrollViewKey);
}

- (void)setZj_originalSuperView:(UIView *)zj_originalSuperView
{
    objc_setAssociatedObject(self, ZJScrollFloatingViewOriginalSuperViewKey, zj_originalSuperView, OBJC_ASSOCIATION_ASSIGN);
}
- (UIView *)zj_originalSuperView
{
    return objc_getAssociatedObject(self, ZJScrollFloatingViewOriginalSuperViewKey);
}

- (void)setZj_floatingSuperView:(UIView *)zj_floatingSuperView
{
    objc_setAssociatedObject(self, ZJScrollFloatingViewFloatingSuperViewKey, zj_floatingSuperView, OBJC_ASSOCIATION_ASSIGN);
}
- (UIView *)zj_floatingSuperView
{
    return objc_getAssociatedObject(self, ZJScrollFloatingViewFloatingSuperViewKey);
}

- (void)setZj_originalFrame:(NSValue *)zj_originalFrame
{
    objc_setAssociatedObject(self, ZJScrollFloatingViewOriginalFrameKey, zj_originalFrame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSValue *)zj_originalFrame
{
    return objc_getAssociatedObject(self, ZJScrollFloatingViewOriginalFrameKey);
}

- (void)setZj_floatingFrame:(NSValue *)zj_floatingFrame
{
    objc_setAssociatedObject(self, ZJScrollFloatingViewFloatingFrameKey, zj_floatingFrame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSValue *)zj_floatingFrame
{
    return objc_getAssociatedObject(self, ZJScrollFloatingViewFloatingFrameKey);
}

void asd ()
{
    
}

+ (void)load
{
    SEL originalSel = @selector(scrollViewDidScroll:);
    SEL swizzledSel = @selector(zj_scrollViewDidScroll:);
    
    class_addMethod([UITableViewController class], originalSel, (IMP)asd, "v@:@");
    Method originalMethod = class_getInstanceMethod([UITableViewController class], originalSel);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSel);
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)zj_scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIView *floatingView = nil;
    if ([self isKindOfClass:[UIViewController class]]) {
        floatingView = [self valueForKey:self.zj_ownerPropertyName];
    } else if ([self isKindOfClass:[UIView class]]) {
        floatingView = self;
    }
    CGFloat navigationBarHeight = 64.f;
    if (@available(iOS 11.0, *)) {
        navigationBarHeight = scrollView.safeAreaInsets.top;
    }
    if (floatingView.frame.origin.y + (- scrollView.contentOffset.y) < navigationBarHeight && floatingView.superview == floatingView.zj_originalSuperView) {
        floatingView.zj_originalFrame = [NSValue valueWithCGRect:floatingView.frame];
        [floatingView.zj_floatingSuperView addSubview:floatingView];
        floatingView.frame = [floatingView.zj_floatingFrame CGRectValue];
    } else if (floatingView.zj_originalFrame.CGRectValue.origin.y + (- scrollView.contentOffset.y) > navigationBarHeight && floatingView.superview == floatingView.zj_floatingSuperView) {
        [floatingView.zj_originalSuperView addSubview:floatingView];
        CGRect frame = [floatingView.zj_originalFrame CGRectValue];
        floatingView.frame = frame;
    }
    
    [floatingView zj_scrollViewDidScroll:scrollView]; // Primary Call
}

@end


@implementation NSObject (FloatingViewOwnerPropertyName)

static void *ZJFloatingViewOwnerPropertyKey     = &ZJFloatingViewOwnerPropertyKey;

- (void)setZj_ownerPropertyName:(NSString *)zj_ownerPropertyName
{
    objc_setAssociatedObject(self, ZJFloatingViewOwnerPropertyKey, zj_ownerPropertyName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)zj_ownerPropertyName
{
    return objc_getAssociatedObject(self, ZJFloatingViewOwnerPropertyKey);
}

@end 





