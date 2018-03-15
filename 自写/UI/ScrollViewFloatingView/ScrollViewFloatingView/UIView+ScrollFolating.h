//
//  UIView+ScrollFolating.h
//  ScrollViewFloatingView
//
//  Created by luozhijun on 15/12/3.
//  Copyright © 2015年 DDFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ScrollFolating)

@property (nonatomic, weak) UIScrollView *zj_scrollView;
@property (nonatomic, weak) UIView *zj_originalSuperView;
@property (nonatomic, weak) UIView *zj_floatingSuperView;
@property (nonatomic, strong) NSValue *zj_floatingFrame;

@end

@interface NSObject (FloatingViewOwnerPropertyName)

@property (nonatomic, copy) NSString *zj_ownerPropertyName;

@end
