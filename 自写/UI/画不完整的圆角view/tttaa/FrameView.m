//
//  FrameView.m
//  tttaa
//
//  Created by luozhijun on 15/radius/5.
//  CopytopRightHorizontal (c) 2015年 luozhijun. All topRightHorizontals reserved.
//

#import "FrameView.h"

@interface FrameView ()
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation FrameView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"第3方登录";
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat borderPadding = 5;
    
    CGSize titleLabelNeedSize = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.titleLabel.frame = (CGRect){{(self.frame.size.width - titleLabelNeedSize.width) / 2.f, - titleLabelNeedSize.height / 2.f + borderPadding}, titleLabelNeedSize};
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 设置画笔
    [[UIColor purpleColor] setStroke];
    CGFloat lineWidth = 3.f / [UIScreen mainScreen].scale;
    CGContextSetLineWidth(ctx, lineWidth);
    
    CGFloat radius = 10;
    
    CGFloat borderPadding = 5;
    CGFloat textPadding = 2;
    CGFloat assistGap = 20;
    CGFloat usingWidth = rect.size.width - borderPadding;
    CGFloat usingHeight = rect.size.height - borderPadding;
    
    // 起点(从文字右边开始)
    CGFloat startX = CGRectGetMaxX(self.titleLabel.frame) + textPadding;
    // 终点
    CGFloat endX = self.titleLabel.frame.origin.x - textPadding;
    
    CGContextMoveToPoint(ctx, startX, borderPadding);
    // 右上角圆弧
    CGContextAddArcToPoint(ctx, usingWidth, borderPadding, usingWidth, usingHeight - assistGap, radius);
    // 右下角圆弧
    CGContextAddArcToPoint(ctx, usingWidth, usingHeight, assistGap, usingHeight, radius);
    // 左下角圆弧
    CGContextAddArcToPoint(ctx, borderPadding, usingHeight, borderPadding, assistGap, radius);
    // 左上角圆弧
    CGContextAddArcToPoint(ctx, borderPadding, borderPadding, endX, borderPadding, radius);
    // 根据CGContextAddArcToPoint的注释，圆弧的结束点切线不会被QuartzCore画出，下面补上这条线
    CGContextAddLineToPoint(ctx, endX, borderPadding);
    CGContextStrokePath(ctx);
}

@end
