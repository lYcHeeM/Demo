//
//  UIImageView+ZJLayout.m
//  button
//
//  Created by luozhijun on 14-12-21.
//  Copyright (c) 2014年 luozhijun. All rights reserved.
//

#import "UIView+ImageViewLayout.h"

@implementation UIView (ImageViewLayout)
#pragma mark -
#pragma mark both horizontal and vertical
#pragma mark each view equal size

#pragma mark 1. both width and height should specify
/**
 *  mostly, the easiest way is enough
 */
- (CGRect)addSameSizedImageViewsInDirection:(ZJLayoutDirection)direction fixedSize:(CGSize)fixedSize amount:(NSInteger)amount loopCompletionBlock:(ImageViewLayoutLoopCompletionBlock)loopCompletionBlock
{
    return [self addSameSizedImageViewsInRect:self.bounds inDirection:direction fixedSize:fixedSize borderPadding:ZJLayoutDefaultBorderPadding interitemPadding:nil linePadding:nil amount:amount loopCompletionBlock:loopCompletionBlock];
}

- (CGRect)addSameSizedImageViewsInRect:(CGRect)constrainedRect inDirection:(ZJLayoutDirection)direction fixedSize:(CGSize)fixedSize borderPadding:(UIEdgeInsets)borderPadding interitemPadding:(NSNumber *)interitemPadding linePadding:(NSNumber *)linePadding amount:(NSInteger)amount loopCompletionBlock:(ImageViewLayoutLoopCompletionBlock)loopCompletionBlock
{
    return [self addSameSizedImageViewsInRect:constrainedRect inDirection:direction fixedSize:fixedSize aspectRatio:NO fixedLineCount:nil borderPadding:borderPadding interitemPadding:interitemPadding linePadding:linePadding amount:amount loopCompletionBlock:loopCompletionBlock];
}

#pragma mark 2. can just specify one of width and height
#pragma mark another is zero
#pragma mark and sepecify the amount of one line

- (CGRect)addSameSizedImageViewsInRect:(CGRect)constrainedRect inDirection:(ZJLayoutDirection)direction fixedSize:(CGSize)fixedSize fixedLineCount:(NSNumber *)fixedLineCount amount:(NSInteger)amount loopCompletionBlock:(ImageViewLayoutLoopCompletionBlock)loopCompletionBlock
{
    return [self addSameSizedImageViewsInRect:constrainedRect inDirection:direction fixedSize:fixedSize aspectRatio:YES fixedLineCount:fixedLineCount borderPadding:ZJLayoutDefaultBorderPadding interitemPadding:nil linePadding:nil amount:amount loopCompletionBlock:loopCompletionBlock];
}

#pragma mark 3. this is the most complex one
/**
 *  this is the most complex one
 */
- (CGRect)addSameSizedImageViewsInRect:(CGRect)constrainedRect inDirection:(ZJLayoutDirection)direction fixedSize:(CGSize)fixedSize aspectRatio:(BOOL)aspectRatio fixedLineCount:(NSNumber *)fixedLineCount borderPadding:(UIEdgeInsets)borderPadding interitemPadding:(NSNumber *)interitemPadding linePadding:(NSNumber *)linePadding amount:(NSInteger)amount loopCompletionBlock:(ImageViewLayoutLoopCompletionBlock)loopCompletionBlock
{
    return [self layoutSameSizedViewsWithViewClass:[UIImageView class] inDirection:direction constrainedToRect:constrainedRect fixedSize:fixedSize aspectRatio:aspectRatio fixedLineCount:fixedLineCount borderPadding:borderPadding interitemPadding:interitemPadding linePadding:linePadding count:amount loopCompletionBlock:loopCompletionBlock];
}
@end
