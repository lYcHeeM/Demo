//
//  ZJSecureCodeInputView.m
//  DDFinance
//
//  Created by luozhijun on 15/11/17.
//  Copyright © 2015年 DDFinance. All rights reserved.
//

#import "ZJSecureCodeInputView.h"

@interface ZJSecureCodeInputView () <UITextViewDelegate>
@property (nonatomic, strong) ZJSecureCodeFrameView *frameView;
@property (nonatomic, strong) NSMutableArray *circleDotViews;
@end

@implementation ZJSecureCodeInputView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initDefaultProperties];
        [self _setupSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _initDefaultProperties];
        [self _setupSubViews];
    }
    return self;
}

- (void)_initDefaultProperties
{
    if (!_codeCount) {
        _codeCount = 6;
    }
    if (!_outerLineColor) {
        _outerLineColor = [UIColor blueColor];
    }
    if (!_interLineColor) {
        _interLineColor = [UIColor grayColor];
    }
    if (!_outerLineWidth) {
        _outerLineWidth = 5.f / [UIScreen mainScreen].scale;
    }
    if (!_interLineWidth) {
        _interLineWidth = 3.f / [UIScreen mainScreen].scale;
    }
    if (!_circleDotColor) {
        _circleDotColor = [UIColor blackColor];
    }
    if (!_circleDotRadius) {
        _circleDotRadius = 8.f;
    }
    
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.delegate = self;
}

- (void)_setupSubViews
{
    self.frameView = [[ZJSecureCodeFrameView alloc] initWithCodeCount:self.codeCount outerLineColor:self.outerLineColor outerLineWidth:self.outerLineWidth interLineColor:self.interLineColor interLineWidth:self.interLineWidth];
    self.frameView.userInteractionEnabled = NO;
    [self addSubview:self.frameView];
    
    for (NSInteger i = 0; i < self.codeCount; ++ i) {
        ZJSecureCodeCircleDotView *circleDotView = [[ZJSecureCodeCircleDotView alloc] initWithCircleDotRadius:self.circleDotRadius circleDotColor:self.circleDotColor];
        circleDotView.tag = i + 1;
        circleDotView.hidden = YES;
        circleDotView.userInteractionEnabled = NO;
        [self addSubview:circleDotView];
        [self.circleDotViews addObject:circleDotView];
    }
}

- (NSMutableArray *)circleDotViews
{
    if (!_circleDotViews) {
        _circleDotViews = @[].mutableCopy;
    }
    return  _circleDotViews;
}

#pragma mark - Setters
- (void)setCodeCount:(NSInteger)codeCount
{
    if (_codeCount != codeCount) {
        _codeCount = codeCount;
        self.frameView.codeCount = codeCount;
        [self.circleDotViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.circleDotViews removeAllObjects];
        for (NSInteger i = 0; i < self.codeCount; ++ i) {
            ZJSecureCodeCircleDotView *circleDotView = [[ZJSecureCodeCircleDotView alloc] initWithCircleDotRadius:self.circleDotRadius circleDotColor:self.circleDotColor];
            circleDotView.tag = i + 1;
            circleDotView.hidden = YES;
            circleDotView.userInteractionEnabled = NO;
            [self addSubview:circleDotView];
            [self.circleDotViews addObject:circleDotView];
        }
    }
}

- (void)setCircleDotColor:(UIColor *)circleDotColor
{
    if (_circleDotColor != circleDotColor) {
        _circleDotColor = circleDotColor;
        for (ZJSecureCodeCircleDotView *aDotView in self.circleDotViews) {
            aDotView.circleDotColor = circleDotColor;
        }
    }
}

- (void)setCircleDotRadius:(CGFloat)circleDotRadius
{
    if (_circleDotRadius != circleDotRadius) {
        _circleDotRadius = circleDotRadius;
        for (ZJSecureCodeCircleDotView *aDotView in self.circleDotViews) {
            aDotView.circleDotRadius = circleDotRadius;
        }
    }
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frameView.frame = self.bounds;
    
    CGFloat dotViewWidth = self.frame.size.width / self.codeCount;
    _circleDotRadius = dotViewWidth / 8.f;
    for (NSInteger i = 0; i < self.circleDotViews.count; ++ i) {
        ZJSecureCodeCircleDotView *dotView = self.circleDotViews[i];
        dotView.circleDotRadius = _circleDotRadius;
        dotView.frame = CGRectMake(dotViewWidth * i, self.bounds.origin.y, dotViewWidth, self.frame.size.height);
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length < self.codeCount
        ||
        (textView.text.length == self.codeCount && [text isEqualToString:@""])) { // @"" means backspace, 退格符
        if ([text isEqualToString:@""]) {
            UIView *secureTextDot = self.circleDotViews[textView.text.length - 1];
            secureTextDot.hidden = YES;
        } else {
            UIView *secureTextDot = self.circleDotViews[textView.text.length];
            secureTextDot.hidden = !secureTextDot.isHidden;
        }
        return YES;
    } else {
        return NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == self.codeCount) { // code inputing completed 密码输入完成
        NSLog(@"----input completed!----");
        if ([self.inputViewDelegate respondsToSelector:@selector(secureCodeInputView:completedInputSecureCode:)]) {
            [self.inputViewDelegate secureCodeInputView:self completedInputSecureCode:textView.text];
        }
    }
}

@end


#pragma mark - Frame view
@implementation ZJSecureCodeFrameView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _outerLineColor = [UIColor blueColor];
        _interLineColor = [UIColor grayColor];
        _outerLineWidth = 5.f / [UIScreen mainScreen].scale;
        _interLineWidth = 3.f / [UIScreen mainScreen].scale;
        _codeCount = 6;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithCodeCount:(NSInteger)codeCount outerLineColor:(UIColor *)outerLineColor outerLineWidth:(CGFloat)outerLineWidth interLineColor:(UIColor *)interLineColor interLineWidth:(CGFloat)interLineWidth
{
    self = [self init];
    if (self) {
        if (codeCount >= 4 && codeCount < 16) {
            _codeCount = codeCount;
        }
        if (_outerLineColor) {
            _outerLineColor = outerLineColor;
        }
        if (_outerLineWidth) {
            _outerLineWidth = outerLineWidth;
        }
        if (_interLineColor) {
            _interLineColor = interLineColor;
        }
        if (_interLineWidth) {
            _interLineWidth = interLineWidth;
        }
    }
    return self;
}

- (void)setCodeCount:(NSInteger)codeCount
{
    if (_codeCount != codeCount) {
        _codeCount = codeCount;
        [self setNeedsDisplay];
    }
}

- (void)setOuterLineWidth:(CGFloat)outerLineWidth
{
    if (_outerLineWidth != outerLineWidth) {
        _outerLineWidth = outerLineWidth;
        [self setNeedsDisplay];
    }
}

- (void)setOuterLineColor:(UIColor *)outerLineColor
{
    if (_outerLineColor != outerLineColor) {
        _outerLineColor = outerLineColor;
        [self setNeedsDisplay];
    }
}

- (void)setInterLineWidth:(CGFloat)interLineWidth
{
    if (_interLineWidth != interLineWidth) {
        _interLineWidth = interLineWidth;
        [self setNeedsDisplay];
    }
}

- (void)setInterLineColor:(UIColor *)interLineColor
{
    if (_interLineColor != interLineColor) {
        _interLineColor = interLineColor;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // draw outerlines 画出外围的线框
    CGContextSetStrokeColorWithColor(context, _outerLineColor.CGColor);
    CGContextSetLineWidth(context, _outerLineWidth);
    
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
    
    CGPoint outerLinePoints[] =
    {
        CGPointMake(rect.origin.x, rect.origin.y),
        CGPointMake(rect.origin.x, rect.size.height),
        CGPointMake(rect.size.width, rect.size.height),
        CGPointMake(rect.size.width, rect.origin.y),
        CGPointMake(rect.origin.x, rect.origin.y)
    };
    CGContextAddLines(context, outerLinePoints, sizeof(outerLinePoints) / sizeof(outerLinePoints[0]));
    CGContextStrokePath(context);
    
    // draw interlines 画出内围的线条
    CGContextSetStrokeColorWithColor(context, _interLineColor.CGColor);
    CGContextSetLineWidth(context, _interLineWidth);
    for (NSInteger i = 1; i < _codeCount; ++ i) {
        CGPoint start = CGPointMake(rect.size.width / _codeCount * i, rect.origin.y);
        CGPoint end = CGPointMake(rect.size.width / _codeCount * i, rect.size.height);
        CGContextMoveToPoint(context, start.x, start.y);
        CGContextAddLineToPoint(context, end.x, end.y);
        CGContextStrokePath(context);
    }
}

@end

#pragma mark - Circle Dot

@implementation ZJSecureCodeCircleDotView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _circleDotColor = [UIColor blackColor];
        _circleDotRadius = 8.f;
    }
    return self;
}

- (instancetype)initWithCircleDotRadius:(CGFloat)circleDotRadius circleDotColor:(UIColor *)circleDotColor
{
    self = [self init];
    if (self) {
        if (circleDotRadius > 0) {
            _circleDotRadius = circleDotRadius;
        }
        if (circleDotColor) {
            _circleDotColor = circleDotColor;
        }
    }
    return self;
}

- (void)setCircleDotRadius:(CGFloat)circleDotRadius
{
    if (_circleDotRadius != circleDotRadius) {
        _circleDotRadius = circleDotRadius;
        [self setNeedsDisplay];
    }
}

- (void)setCircleDotColor:(UIColor *)circleDotColor
{
    if (_circleDotColor != circleDotColor) {
        _circleDotColor = circleDotColor;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(contex, _circleDotColor.CGColor);
    
    CGPoint center = CGPointMake(rect.size.width / 2.f, rect.size.height / 2.f);
    CGRect ellipseRect = CGRectMake(center.x - _circleDotRadius, center.y - _circleDotRadius, 2 * _circleDotRadius, 2 * _circleDotRadius);
    CGContextAddEllipseInRect(contex, ellipseRect);
    CGContextFillPath(contex);
}

@end
