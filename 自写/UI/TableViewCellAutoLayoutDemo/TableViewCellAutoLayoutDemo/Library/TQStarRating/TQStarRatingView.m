//
//  TQStarRatingView.m
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import "TQStarRatingView.h"

static CGSize TQStarRatingViewZeroStarHintLabelDefaultSize = {60.f, 20.f};

@interface TQStarRatingView ()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@property (nonatomic, copy) NSString *backgroundImageName;
@property (nonatomic, copy) NSString *foregroundImageName;

@end

@implementation TQStarRatingView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStar:kNUMBER_OF_STAR];
}

- (instancetype)initWithBackgroundImageName:(NSString *)backgroundImageName foregroundImageName:(NSString *)foregroundImageName numberOfStars:(NSInteger)starNumber
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _numberOfStar = starNumber;
        _backgroundImageName = backgroundImageName;
        _foregroundImageName = foregroundImageName;
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _numberOfStar = kNUMBER_OF_STAR;
    [self commonInit];
}

/**
 *  初始化TQStarRatingView
 *
 *  @param frame  Rectangles
 *  @param number 星星个数
 *
 *  @return TQStarRatingViewObject
 */
- (id)initWithFrame:(CGRect)frame numberOfStar:(NSInteger)number
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    if (!_backgroundImageName) {
        _backgroundImageName = kBACKGROUND_STAR;
    }
    
    if (!_foregroundImageName) {
        _foregroundImageName = kFOREGROUND_STAR;
    }
    
    self.starBackgroundView = [self buidlStarViewWithImageName:_backgroundImageName];
    self.starForegroundView = [self buidlStarViewWithImageName:_foregroundImageName];
    [self addSubview:self.starBackgroundView];
    [self addSubview:self.starForegroundView];
}

#pragma mark - by Zhijun
// 使得可以在改变frame的时候内部view的大小可跟着变
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self.starForegroundView removeFromSuperview];
    [self.starBackgroundView removeFromSuperview];
    
    self.starBackgroundView = [self buidlStarViewWithImageName:_backgroundImageName];
    self.starForegroundView = [self buidlStarViewWithImageName:_foregroundImageName];
    [self addSubview:self.starBackgroundView];
    [self addSubview:self.starForegroundView];
}

// 使得可以在改变frame的时候内部view的大小可跟着变
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    
//    [self.starForegroundView removeFromSuperview];
//    [self.starBackgroundView removeFromSuperview];
//
//    self.starBackgroundView = [self buidlStarViewWithImageName:kBACKGROUND_STAR];
//    self.starForegroundView = [self buidlStarViewWithImageName:kFOREGROUND_STAR];
//    [self addSubview:self.starBackgroundView];
//    [self addSubview:self.starForegroundView];
//}

- (UILabel *)zeroStarHintLabel
{
    if (!_zeroStarHintLabel) {
        _zeroStarHintLabel = [[UILabel alloc] init];
        _zeroStarHintLabel.textColor = [UIColor lightGrayColor];
        _zeroStarHintLabel.font = [UIFont systemFontOfSize:15];
        _zeroStarHintLabel.text = @"暂无评分";
    }
    return _zeroStarHintLabel;
}
#pragma mark end

#pragma mark -
#pragma mark - Set Score

/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 1 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate
{
    if (score < 0.05) {
        [self addSubview:self.zeroStarHintLabel];
        self.zeroStarHintLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        self.zeroStarHintLabel.bounds = CGRectMake(0, 0, TQStarRatingViewZeroStarHintLabelDefaultSize.width, self.frame.size.height ? self.frame.size.height : TQStarRatingViewZeroStarHintLabelDefaultSize.height);
    } else {
        [self.zeroStarHintLabel removeFromSuperview];
    }
    [self setScore:score withAnimation:isAnimate completion:^(BOOL finished){}];
}

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion
{
    NSAssert((score >= 0.0)&&(score <= 1.0), @"score must be between 0 and 1");
    
    if (score < 0)
    {
        score = 0;
    }
    
    if (score > 1)
    {
        score = 1;
    }
    
    CGPoint point = CGPointMake(score * self.frame.size.width, 0);
    
    if(isAnimate)
    {
        __weak __typeof(self)weakSelf = self;
        
        [UIView animateWithDuration:0.2 animations:^
         {
             [weakSelf changeStarForegroundViewWithPoint:point];
             
         } completion:^(BOOL finished)
         {
             if (completion)
             {
                 completion(finished);
             }
         }];
    }
    else
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

#pragma mark -
#pragma mark - Touche Event
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point))
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak __typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.2 animations:^
     {
         [weakSelf changeStarForegroundViewWithPoint:point];
     }];
}

#pragma mark -
#pragma mark - Buidl Star View

/**
 *  通过图片构建星星视图
 *
 *  @param imageName 图片名称
 *
 *  @return 星星视图
 */
- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.frame = CGRectMake(i * frame.size.width / self.numberOfStar, 0, frame.size.width / self.numberOfStar, frame.size.height);
        [view addSubview:imageView];
    }
    return view;
}

#pragma mark -
#pragma mark - Change Star Foreground With Point

/**
 *  通过坐标改变前景视图
 *
 *  @param point 坐标
 */
- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGPoint p = point;
    
    if (p.x < 0)
    {
        p.x = 0;
    }
    
    if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }
    
    NSString * str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
    float score = [str floatValue];
    p.x = score * self.frame.size.width;
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    _score = score;
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingContainerView: score:)])
    {
        [self.delegate starRatingContainerView:self score:score];
    }
}

@end
