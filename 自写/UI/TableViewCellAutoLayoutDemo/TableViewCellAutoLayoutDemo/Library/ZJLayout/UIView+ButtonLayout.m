//
//  UIButton+ZJLayout.m
//  button
//
//  Created by luozhijun on 14-12-21.
//  Copyright (c) 2014年 luozhijun. All rights reserved.
//

#import "UIView+ButtonLayout.h"

@implementation UIView (ButtonLayout)

#pragma mark -
#pragma mark only in horzontal
#pragma mark may not equal size
#pragma mark tipically using to deal with text fitting buttons

- (CGRect)addButtonsWithTitles:(NSArray *)titles fontSize:(CGFloat)fontSize loopCompletionBlock:(ButtonLayoutLoopCompletionBlock)loopCompletionBlock
{
    return [self addButtonsInRect:self.bounds fixedWidth:nil fixedHeight:nil borderPadding:ZJLayoutDefaultBorderPadding interitemPadding:nil linePadding:nil titles:titles fontSize:fontSize loopCompletionBlock:loopCompletionBlock];
}

- (CGRect)addButtonsInRect:(CGRect)constrainedRect interitemPadding:(NSNumber *)padding titles:(NSArray *)titles fontSize:(CGFloat)fontSize loopCompletionBlock:(ButtonLayoutLoopCompletionBlock)loopCompletionBlock
{
    return [self addButtonsInRect:constrainedRect fixedWidth:nil fixedHeight:nil borderPadding:ZJLayoutDefaultBorderPadding interitemPadding:nil linePadding:nil titles:titles fontSize:fontSize loopCompletionBlock:loopCompletionBlock];
}

- (CGRect)addButtonsInRect:(CGRect)constrainedRect fixedWidth:(NSNumber *)fixedWidth fixedHeight:(NSNumber *)fixedHeight borderPadding:(UIEdgeInsets)borderPadding interitemPadding:(NSNumber *)interitemPadding linePadding:(NSNumber *)linePadding titles:(NSArray *)titles fontSize:(CGFloat)fontSize loopCompletionBlock:(ButtonLayoutLoopCompletionBlock)loopCompletionBlock
{
    return [self layoutTextAdaptedViewsWithViewClass:[UIButton class] inDirection:ZJLayoutDirectionHorizontal constrainedToRect:constrainedRect fixedWidth:fixedWidth fixedHeight:fixedHeight borderPadding:borderPadding interitemPadding:interitemPadding linePadding:linePadding titles:titles fontSize:fontSize loopCompletionBlock:^(NSInteger index, UIButton *button) {
        [button setTitle:titles[index] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (loopCompletionBlock) {
            loopCompletionBlock(index, button);
        }
    }];
}

#pragma mark -
#pragma mark both horizontal and vertical
#pragma mark each view equal size

#pragma mark 1. both width and height should specify
/**
 *  mostly, the easiest way is enough, both width and height should specify
 */
- (CGRect)addSameSizedButtonsInDirection:(ZJLayoutDirection)direction fixedSize:(CGSize)fixedSize amount:(NSInteger)amount loopCompletionBlock:(ButtonLayoutLoopCompletionBlock)loopCompletionBlock
{
    return [self addSameSizedButtonsInRect:self.bounds inDirection:direction fixedSize:fixedSize borderPadding:ZJLayoutDefaultBorderPadding interitemPadding:nil linePadding:nil amount:amount loopCompletionBlock:loopCompletionBlock];
}

/**
 *  both width and height should specify
 */
- (CGRect)addSameSizedButtonsInRect:(CGRect)constrainedRect inDirection:(ZJLayoutDirection)direction fixedSize:(CGSize)fixedSize borderPadding:(UIEdgeInsets)borderPadding interitemPadding:(NSNumber *)interitemPadding linePadding:(NSNumber *)linePadding amount:(NSInteger)amount loopCompletionBlock:(ButtonLayoutLoopCompletionBlock)loopCompletionBlock
{
    return [self addSameSizedButtonsInRect:constrainedRect inDirection:direction fixedSize:fixedSize aspectRatio:NO fixedLineCount:nil borderPadding:borderPadding interitemPadding:interitemPadding linePadding:linePadding amount:amount loopCompletionBlock:loopCompletionBlock];
}

#pragma mark 2. can just specify one of width and height
#pragma mark another is zero
#pragma mark and sepecify the amount of one line
/**
 *  can just specify one of width and height, another is zero, and sepecify the amount of one line
 *
 */
- (CGRect)addSameSizedButtonsInRect:(CGRect)constrainedRect inDirection:(ZJLayoutDirection)direction fixedSize:(CGSize)fixedSize fixedLineCount:(NSNumber *)fixedLineCount amount:(NSInteger)amount loopCompletionBlock:(ButtonLayoutLoopCompletionBlock)loopCompletionBlock
{
    return [self addSameSizedButtonsInRect:constrainedRect inDirection:direction fixedSize:fixedSize aspectRatio:YES fixedLineCount:fixedLineCount borderPadding:ZJLayoutDefaultBorderPadding interitemPadding:nil linePadding:nil amount:amount loopCompletionBlock:loopCompletionBlock];
}

#pragma mark 3. this is the most complex one
/**
 *  this is the most complex one
 */
- (CGRect)addSameSizedButtonsInRect:(CGRect)constrainedRect inDirection:(ZJLayoutDirection)direction fixedSize:(CGSize)fixedSize aspectRatio:(BOOL)aspectRatio fixedLineCount:(NSNumber *)fixedLineCount borderPadding:(UIEdgeInsets)borderPadding interitemPadding:(NSNumber *)interitemPadding linePadding:(NSNumber *)linePadding amount:(NSInteger)amount loopCompletionBlock:(ButtonLayoutLoopCompletionBlock)loopCompletionBlock
{
    return [self layoutSameSizedViewsWithViewClass:[UIButton class] inDirection:direction constrainedToRect:constrainedRect fixedSize:fixedSize aspectRatio:aspectRatio fixedLineCount:fixedLineCount borderPadding:borderPadding interitemPadding:interitemPadding linePadding:linePadding count:amount loopCompletionBlock:loopCompletionBlock];
}
@end
