//
//  BGYStaticTextView.m
//  mobiportal
//
//  Created by luozhijun on 15-2-4.
//  Copyright (c) 2015年 bgyun. All rights reserved.
//

#import "BGYStaticTextView.h"

static const CGFloat kBGYStaticTextViewHorizontalPaddingRatio = 0.165;

@interface BGYStaticTextView ()
@property (nonatomic, weak) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation BGYStaticTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseSetting];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseSetting];
    }
    return self;
}

- (void)baseSetting
{
    self.editable = NO;
    self.scrollEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    UIFont *defaultFont = [UIFont systemFontOfSize:17];
    self.textContainerInset = UIEdgeInsetsMake(0, -defaultFont.lineHeight * kBGYStaticTextViewHorizontalPaddingRatio, 0, -defaultFont.lineHeight * kBGYStaticTextViewHorizontalPaddingRatio);
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.textContainerInset = UIEdgeInsetsMake(0, -font.lineHeight * kBGYStaticTextViewHorizontalPaddingRatio, 0, -font.lineHeight * kBGYStaticTextViewHorizontalPaddingRatio);
}

@end
