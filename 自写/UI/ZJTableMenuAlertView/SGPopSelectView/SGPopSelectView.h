//
//  SGPopSelectView.h
//  SGPopSelectView
//
//  Created by Sagi on 14-10-28.
//  Copyright (c) 2014年 azurelab. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - by Zhijun
// insert on 150430
static const CGFloat SGPopSelectViewDefaultVerticalPadding = 5.f;
static const CGFloat SGPopSelectViewDefaultRowHeight = 35.f;
#pragma mark end

typedef void (^PopViewSelectedHandle) (NSInteger selectedIndex);

@interface SGPopSelectView : UIView
@property (nonatomic, strong) NSArray *selections;
@property (nonatomic, copy) PopViewSelectedHandle selectedHandle;
@property (nonatomic, readonly) BOOL visible;

- (instancetype)init;
- (void)showFromView:(UIView*)view atPoint:(CGPoint)point animated:(BOOL)animated;
- (void)hide:(BOOL)animated;

#pragma mark - by Zhijun
// insert on 150430
- (CGFloat)_preferedWidth;
- (CGFloat)_preferedHeight;
@property (nonatomic, assign) BOOL needCornerRadiusAndShadow;
@property (nonatomic, assign) CGFloat verticalPadding;
@property (nonatomic, assign) CGFloat rowHeight;
- (instancetype)initWithVerticalPadding:(CGFloat)vertialPadding rowHeight:(CGFloat)rowHeight needCornerRadiusAndShadow:(BOOL)needCornerRadiusAndShadow;
- (instancetype)initWithNeedCornerRadiusAndShadow:(BOOL)needCornerRadiusAndShadow;
#pragma mark end
@end
