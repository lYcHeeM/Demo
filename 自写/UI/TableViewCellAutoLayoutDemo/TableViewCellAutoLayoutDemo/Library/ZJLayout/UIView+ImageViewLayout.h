//
//  UIImageView+ZJLayout.h
//  button
//
//  Created by luozhijun on 14-12-21.
//  Copyright (c) 2014年 luozhijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+ZJLayout.h"

typedef void (^ImageViewLayoutLoopCompletionBlock)(NSInteger index, UIImageView *imageView);
@interface UIView (ImageViewLayout)

 //  summary:
 //  both horizontal and vertical
 //  each view equal size

#pragma mark 1.
/** both width and height should specify */

- (CGRect)addSameSizedImageViewsInDirection:(ZJLayoutDirection)direction fixedSize:(CGSize)fixedSize amount:(NSInteger)amount loopCompletionBlock:(ImageViewLayoutLoopCompletionBlock)loopCompletionBlock;

- (CGRect)addSameSizedImageViewsInRect:(CGRect)constrainedRect inDirection:(ZJLayoutDirection)direction fixedSize:(CGSize)fixedSize borderPadding:(UIEdgeInsets)borderPadding interitemPadding:(NSNumber *)interitemPadding linePadding:(NSNumber *)linePadding amount:(NSInteger)amount loopCompletionBlock:(ImageViewLayoutLoopCompletionBlock)loopCompletionBlock;

#pragma mark 2.
/**
 *  can just specify one of width and height
 *  another is zero
 *  sepecify the amount of one line
 */

- (CGRect)addSameSizedImageViewsInRect:(CGRect)constrainedRect inDirection:(ZJLayoutDirection)direction fixedSize:(CGSize)fixedSize fixedLineCount:(NSNumber *)fixedLineCount amount:(NSInteger)amount loopCompletionBlock:(ImageViewLayoutLoopCompletionBlock)loopCompletionBlock;

#pragma mark 3.
/**
 *  this is the most complex one
 */
- (CGRect)addSameSizedImageViewsInRect:(CGRect)constrainedRect inDirection:(ZJLayoutDirection)direction fixedSize:(CGSize)fixedSize aspectRatio:(BOOL)aspectRatio fixedLineCount:(NSNumber *)fixedLineCount borderPadding:(UIEdgeInsets)borderPadding interitemPadding:(NSNumber *)interitemPadding linePadding:(NSNumber *)linePadding amount:(NSInteger)amount loopCompletionBlock:(ImageViewLayoutLoopCompletionBlock)loopCompletionBlock;

@end
