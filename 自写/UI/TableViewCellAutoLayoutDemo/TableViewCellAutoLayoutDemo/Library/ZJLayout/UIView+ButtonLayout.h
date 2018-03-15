//
//  UIButton+ZJLayout.h
//  button
//
//  Created by luozhijun on 14-12-21.
//  Copyright (c) 2014年 luozhijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+ZJLayout.h"


typedef void (^ButtonLayoutLoopCompletionBlock)(NSInteger index, UIButton *button);
@interface UIView (ButtonLayout)

#pragma mark -
#pragma mark only in horzontal
#pragma mark may not equal size
#pragma mark tipically using to deal with text fitting buttons

- (CGRect)addButtonsWithTitles:(NSArray *)titles fontSize:(CGFloat)fontSize loopCompletionBlock:(ButtonLayoutLoopCompletionBlock)loopCompletionBlock;

- (CGRect)addButtonsInRect:(CGRect)constrainedRect interitemPadding:(NSNumber *)padding titles:(NSArray *)titles fontSize:(CGFloat)fontSize loopCompletionBlock:(ButtonLayoutLoopCompletionBlock)loopCompletionBlock;

- (CGRect)addButtonsInRect:(CGRect)constrainedRect fixedWidth:(NSNumber *)fixedWidth fixedHeight:(NSNumber *)fixedHeight borderPadding:(UIEdgeInsets)borderPadding interitemPadding:(NSNumber *)interitemPadding linePadding:(NSNumber *)linePadding titles:(NSArray *)titles fontSize:(CGFloat)fontSize loopCompletionBlock:(ButtonLayoutLoopCompletionBlock)loopCompletionBlock;

#pragma mark -
#pragma mark both horizontal and vertical
#pragma mark each view equal size

#pragma mark 1. both width and height should specify
/**
 *  mostly, the easiest way is enough
 */
- (CGRect)addSameSizedButtonsInDirection:(ZJLayoutDirection)direction fixedSize:(CGSize)fixedSize amount:(NSInteger)amount loopCompletionBlock:(ButtonLayoutLoopCompletionBlock)loopCompletionBlock;

- (CGRect)addSameSizedButtonsInRect:(CGRect)constrainedRect inDirection:(ZJLayoutDirection)direction fixedSize:(CGSize)fixedSize borderPadding:(UIEdgeInsets)borderPadding interitemPadding:(NSNumber *)interitemPadding linePadding:(NSNumber *)linePadding amount:(NSInteger)amount loopCompletionBlock:(ButtonLayoutLoopCompletionBlock)loopCompletionBlock;

#pragma mark 2. can just specify one of width and height
#pragma mark another is zero
#pragma mark and sepecify the amount of one line

- (CGRect)addSameSizedButtonsInRect:(CGRect)constrainedRect inDirection:(ZJLayoutDirection)direction fixedSize:(CGSize)fixedSize fixedLineCount:(NSNumber *)fixedLineCount amount:(NSInteger)amount loopCompletionBlock:(ButtonLayoutLoopCompletionBlock)loopCompletionBlock;

#pragma mark 3. this is the most complex one
- (CGRect)addSameSizedButtonsInRect:(CGRect)constrainedRect inDirection:(ZJLayoutDirection)direction fixedSize:(CGSize)fixedSize aspectRatio:(BOOL)aspectRatio fixedLineCount:(NSNumber *)fixedLineCount borderPadding:(UIEdgeInsets)borderPadding interitemPadding:(NSNumber *)interitemPadding linePadding:(NSNumber *)linePadding amount:(NSInteger)amount loopCompletionBlock:(ButtonLayoutLoopCompletionBlock)loopCompletionBlock;

@end
