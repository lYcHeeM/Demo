//
//  ZJSecureCodeInputView.h
//  DDFinance
//
//  Created by luozhijun on 15/11/17.
//  Copyright © 2015年 DDFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJSecureCodeFrameView, ZJSecureCodeCircleDotView;
@protocol ZJSecureCodeInputViewDelegate;

/** For inputing secure code, like the payment code inputing view in WeChat APP. 用于输入密文的view */
@interface ZJSecureCodeInputView : UITextView

/** Count of secure code. Default is 6. Be sure not to set it when self is showing on a super view. 密文数量, 请不要在self已经显示在某个父视图上的时候改变它的值. */
@property (nonatomic, assign) IBInspectable NSInteger codeCount;

// When self is showing on a super view, setting these 4 properties cannot become effective instantly. But you can change them immediately by setting the same properties of `frameView`.
// 当self已经显示在父视图上时, 修改下面4个属性不会立即生效, 如果有这样的需要, 可通过设置`frameView`的相同属性来实现.
/** Default is 5.f / [UIScreen mainScreen].scale */
@property (nonatomic, assign) IBInspectable CGFloat outerLineWidth;
/** Default is 3.f / [UIScreen mainScreen].scale */
@property (nonatomic, assign) IBInspectable CGFloat interLineWidth;
/** Default is [UIColor blueColor] */
@property (nonatomic, strong) IBInspectable UIColor *outerLineColor;
/** Default is [UIColor grayColor] */
@property (nonatomic, strong) IBInspectable UIColor *interLineColor;

/** Radius of circle dot. Default is 8.0. */
@property (nonatomic, assign) IBInspectable CGFloat circleDotRadius;
/** Default is [UIColor blackColor] */
@property (nonatomic, strong) IBInspectable UIColor *circleDotColor;

@property (nonatomic, strong, readonly) ZJSecureCodeFrameView *frameView;
@property (nonatomic, strong, readonly) NSMutableArray<__kindof ZJSecureCodeCircleDotView *> *circleDotViews;

/** Differentiate `delegate` of UITextView */
@property (nonatomic, weak) id<ZJSecureCodeInputViewDelegate> inputViewDelegate;

@end

@protocol ZJSecureCodeInputViewDelegate <NSObject>
- (void)secureCodeInputView:(ZJSecureCodeInputView *)inputView completedInputSecureCode:(NSString *)code;
@end

/** Draw the frame lines of input view. 画出条框 */
@interface ZJSecureCodeFrameView : UIView

/** Count of secure code. Default is 6. 密文数量 */
@property (nonatomic, assign) NSInteger codeCount;

/** Default is 5.f / [UIScreen mainScreen].scale */
@property (nonatomic, assign) CGFloat outerLineWidth;
/** Default is 3.f / [UIScreen mainScreen].scale */
@property (nonatomic, assign) CGFloat interLineWidth;
/** Default is [UIColor blueColor] */
@property (nonatomic, strong) UIColor *outerLineColor;
/** Default is [UIColor grayColor] */
@property (nonatomic, strong) UIColor *interLineColor;

- (instancetype)initWithCodeCount:(NSInteger)codeCount outerLineColor:(UIColor *)outerLineColor outerLineWidth:(CGFloat)outerLineWidth interLineColor:(UIColor *)interLineColor interLineWidth:(CGFloat)interLineWidth;

@end

/** Draw CircleDot to cover secure text. 画出黑色的圆点 */
@interface ZJSecureCodeCircleDotView : UIView

/** Radius of circle dot. Default is 8.0. */
@property (nonatomic, assign) CGFloat circleDotRadius;
/** Default is [UIColor blackColor] */
@property (nonatomic, strong) UIColor *circleDotColor;

- (instancetype)initWithCircleDotRadius:(CGFloat)circleDotRadius circleDotColor:(UIColor *)circleDotColor;

@end