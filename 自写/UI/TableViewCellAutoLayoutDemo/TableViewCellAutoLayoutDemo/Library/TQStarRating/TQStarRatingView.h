//
//  TQStarRatingView.h
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//


#import <UIKit/UIKit.h>
@class TQStarRatingView;

@protocol StarRatingViewDelegate <NSObject>

@optional
-(void)starRatingContainerView:(TQStarRatingView *)view score:(float)score;

@end

@interface TQStarRatingView : UIView

@property (nonatomic, readonly) NSInteger numberOfStar;

@property (nonatomic, assign, readonly) CGFloat score;

@property (nonatomic, strong) UILabel *zeroStarHintLabel;

@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;

/**
 *  初始化TQStarRatingView
 *
 *  @param frame  Rectangles
 *  @param number 星星个数
 *
 *  @return TQStarRatingViewObject
 */
- (id)initWithFrame:(CGRect)frame numberOfStar:(NSInteger)number;

- (instancetype)initWithBackgroundImageName:(NSString *)backgroundImageName foregroundImageName:(NSString *)foregroundImageName numberOfStars:(NSInteger)starNumber;

/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 1 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate;

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion;

@end

#define kBACKGROUND_STAR @""
#define kFOREGROUND_STAR @"ic_level_star"
#define kNUMBER_OF_STAR  5