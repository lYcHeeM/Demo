 //
//  UIView+ZJLayout.m
//  button
//
//  Created by luozhijun on 14-12-20.
//  Copyright (c) 2014年 luozhijun. All rights reserved.
//

#import "UIView+ZJLayout.h"

@implementation UIView (ZJLayout)

#pragma - -set and get frame
- (void)setOrigin_x:(CGFloat)origin_x
{
    CGRect frame = self.frame;
    frame.origin.x = origin_x;
    self.frame = frame;
}

- (CGFloat)origin_x
{
    return self.frame.origin.x;
}

- (void)setOrigin_y:(CGFloat)origin_y
{
    CGRect frame = self.frame;
    frame.origin.y = origin_y;
    self.frame = frame;
}

- (CGFloat)origin_y
{
    return self.frame.origin.y;
}

- (void)setSize_width:(CGFloat)size_width
{
    CGRect frame = self.frame;
    frame.size.width = size_width;
    self.frame = frame;
}

- (CGFloat)size_width
{
    return self.frame.size.width;
}

- (void)setSize_height:(CGFloat)size_height
{
    CGRect frame = self.frame;
    frame.size.height = size_height;
    self.frame = frame;
}

- (CGFloat)size_height
{
    return self.frame.size.height;
}

- (void)setFrame_size:(CGSize)frame_size
{
    CGRect frame = self.frame;
    frame.size = frame_size;
    self.frame = frame;
}

- (CGSize)frame_size
{
    return self.frame.size;
}

- (void)setFrame_origin:(CGPoint)frame_origin
{
    CGRect frame = self.frame;
    frame.origin = frame_origin;
    self.frame = frame;
}

- (CGPoint)frame_origin
{
    return self.frame.origin;
}

#pragma mark - for label
/**
 *  @see UILabel+ZJLayout
 */

#pragma mark - for button
/**
 *  @see UIButton+ZJLayout
 */

#pragma mark - for imageView
/**
 *  @see UIImageView+ZJLayout
 */

#pragma mark - private
- (CGRect)layoutTextAdaptedViewsWithViewClass:(Class)viewClass inDirection:(ZJLayoutDirection)direction constrainedToRect:(CGRect)constrainedRect fixedWidth:(NSNumber *)fixedWidth fixedHeight:(NSNumber *)fixedHeight borderPadding:(UIEdgeInsets)borderPadding interitemPadding:(NSNumber *)interitemPadding linePadding:(NSNumber *)linePadding titles:(NSArray *)titles fontSize:(CGFloat)fontSize loopCompletionBlock:(LayoutLoopCompletionBlock)loopCompletionBlock
{
    if (!titles.count) return CGRectZero;
    
    CGPoint startPoint = constrainedRect.origin;
    CGSize size = constrainedRect.size;
    if (size.width == 0 || size.height == 0) return CGRectZero;
    
    NSAssert([[titles lastObject] isKindOfClass:[NSString class]], @"数组中元素必须是NSString类型  %s", __PRETTY_FUNCTION__);
    
    // 转成number, 方便数据类型的转化, 比如maxfloat 我就不知道怎么转成integer
    NSNumber *numberHeight = [NSNumber numberWithFloat:size.height];
    
    // 间距
    UIEdgeInsets borderP = borderPadding;
    CGFloat interitemP = interitemPadding ? interitemPadding.floatValue : ZJLayoutDefaultTextInteritemPadding;
    CGFloat lineP = linePadding ? linePadding.floatValue : ZJLayoutDefaultTextLinePadding;
    
    // 控件的高度
    CGFloat viewH = fixedHeight ? fixedHeight.floatValue : [@"哈" boundingRectWithSize:CGSizeMake(size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil].size.height + ZJLayoutAddtionalSizeVertical;
    
    // Y值
    CGFloat viewY = startPoint.y + borderP.top;
    // 控件最大的宽度
    CGFloat viewMaxW = size.width - (borderP.left + borderPadding.right) - ZJLayoutAddtionalSizeHorizontal;
    
    // 是否应该换行
    BOOL nextLine = NO;
    
    // 保存前一次循环的view
    UIView *lastView = nil;
    // 第一个view
    UIView *firstView = nil;
    // 最后一个view
    UIView *endView = nil;
    
    // 限制的行数
    NSUInteger lineCount = numberHeight.integerValue / (NSUInteger)viewH;
    
    NSUInteger titlesCount = titles.count;
    for (NSInteger index = 0; index < titlesCount; ++ index) {
        
        if (index >= titles.count) break; // 预防titles数组中间有变化
        
        // 判断是否能够继续换行
        if ((NSInteger)((viewY - startPoint.y + 0.5) / viewH) >= lineCount) {
            break;
        }
        
        // 创建并添加
        UIView *view = nil;
        view = [[viewClass alloc] init];
        [self addSubview:view];
        
        // 计算x值
        CGFloat viewX = 0;
        if (lastView == nil || nextLine) {
            viewX = startPoint.x + borderP.left;
        } else {
            viewX = CGRectGetMaxX(lastView.frame) + interitemP;
        }
        
        // 宽度
        CGFloat viewW = 0;
        if (fixedWidth) {
            viewW = fixedWidth.floatValue;
        } else {
            viewW = [titles[index] boundingRectWithSize:CGSizeMake(viewMaxW, viewH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size.width + ZJLayoutAddtionalSizeHorizontal;
        }
        
        // frame
        view.frame = CGRectMake(viewX, viewY, viewW, viewH);
        
        // 下一个view是否需要换行
        if ((index + 1) < titles.count) {
            // 下一个控件需要的宽度
            CGFloat nextviewNeedWidth = [titles[index + 1] boundingRectWithSize:CGSizeMake(viewMaxW, viewH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size.width + ZJLayoutAddtionalSizeHorizontal + interitemP;
            // 当前行剩余的宽度
            // 计算: 限制的宽度 - (当前控件最大x值 - 区域起点坐标值) - 右边的间距
            CGFloat remanentWidth = size.width - (CGRectGetMaxX(view.frame) - startPoint.x) - borderP.right;
            if (remanentWidth < nextviewNeedWidth) {
                viewY += viewH + lineP;
                nextLine = YES;
            } else {
                nextLine = NO;
            }
        }
        
        // 赋值
        lastView = view;
        
        // 保存最后一个view
        if (index == 0) {
            firstView = view;
        }
        if (index == (titles.count - 1)) {
            endView = view;
        }
        
        // 给外界的入口
        if (loopCompletionBlock) {
            loopCompletionBlock(index, view);
        }
    }
    
    // 返回实际使用到的区域
    CGFloat usedWidth = CGRectGetMaxX(endView.frame) + borderP.right;
    if (fabs(endView.frame.origin.y - firstView.frame.origin.y) > 0.01) {
        usedWidth = constrainedRect.size.width;
    }
    CGFloat usedHeight = borderP.top + endView.frame.origin.y + endView.frame.size.height - firstView.frame.origin.y + borderP.bottom;
    return (CGRect){startPoint, {usedWidth, usedHeight}};
}

- (CGRect)layoutSameSizedViewsWithViewClass:(Class)viewClass inDirection:(ZJLayoutDirection)direction constrainedToRect:(CGRect)constrainedRect fixedSize:(CGSize)fixedSize aspectRatio:(BOOL)aspectRatio fixedLineCount:(NSNumber *)fixedLineCount borderPadding:(UIEdgeInsets)borderPadding interitemPadding:(NSNumber *)interitemPadding linePadding:(NSNumber *)linePadding count:(NSInteger)count loopCompletionBlock:(LayoutLoopCompletionBlock)loopCompletionBlock
{
    if (!count) return CGRectZero;
    
    CGPoint startPoint = constrainedRect.origin;
    CGSize constrainedSize = constrainedRect.size;
    if (constrainedSize.width == 0 || constrainedSize.height == 0) return CGRectZero;
    // 如果固定的尺寸为0 并且 一行中固定的个数为零
    if ((fixedSize.width == 0 || fixedSize.height == 0) && fixedLineCount == nil) return CGRectZero;
    
    // 间距
    UIEdgeInsets borderP = borderPadding;
    CGFloat interitemP = interitemPadding ? interitemPadding.floatValue : ZJLayoutDefaultInteritemPadding;
    CGFloat lineP = linePadding ? linePadding.floatValue : ZJLayoutDefaultLinePadding;
    
    // 初始的start值
    CGFloat viewStartX = startPoint.x + borderP.left;
    CGFloat viewStartY = startPoint.y + borderP.top;
    
    // 默认的宽高
    CGFloat viewWidth = fixedSize.width;
    CGFloat viewHeight = fixedSize.height;
    
    // 实际区域的宽高(即减去边缘间距之后)
    CGFloat actualConstrainedWith = constrainedSize.width - (borderP.left + borderP.right);
    CGFloat actualConstrainedHeight = constrainedSize.height - (borderP.top + borderP.bottom);
    
    // 在同一行上的view的个数
    NSInteger sameLineViewCount = 0;
    
    if (fixedSize.width && fixedSize.height) {
        // 1.同时提供宽和高
        if (fixedLineCount) {
            // 1.1 同时限制一行的个数
            // 此时忽略指定的两个view之间的间距, 间距重新计算
            sameLineViewCount = fixedLineCount.integerValue;
            if (direction == ZJLayoutDirectionHorizontal) {
                interitemP = (actualConstrainedWith - sameLineViewCount * fixedSize.width) / sameLineViewCount;
            } else {
                interitemP = (actualConstrainedHeight - sameLineViewCount * fixedSize.height) / sameLineViewCount;
            }
        } else {
            // 1.2 不限制一行的个数
            // 此时根据指定的两个view之间的间距计算一行的个数(sameLineViewCount)
            // 计算: (实际区域的宽 + 1个view之间的间距(最右边的间距)) / (view的宽度或高度 + view之间的间距)
            if (direction == ZJLayoutDirectionHorizontal) {
                sameLineViewCount = (actualConstrainedWith + interitemP) / (fixedSize.width + interitemP);
            } else {
                sameLineViewCount = (actualConstrainedHeight + interitemP) / (fixedSize.height + interitemP);
            }
        }
    } else if (!fixedSize.width || !fixedSize.height) {
        // 2.宽高不同时提供
        // 此时必须同时提供一行的个数和两个view之间的间距
        
        // 2.1 只提供一个: 当横向布局时, 提供高; 反之提供宽
        // 在这种情况下, 参数aspectRatio起作用
        // 如果为YES, 忽略提供的宽或高, 使宽和高保持一致
        
        // 2.2 两个都为零 则宽高将相等, 参数aspectRatio将被忽略
        if (fixedLineCount) {
            sameLineViewCount = fixedLineCount.integerValue;
            if (direction == ZJLayoutDirectionHorizontal) {
                viewWidth = (actualConstrainedWith - (sameLineViewCount - 1) * interitemP) / sameLineViewCount;
                if (aspectRatio || !viewHeight) viewHeight = viewWidth;
            } else {
                viewHeight = (actualConstrainedHeight - (sameLineViewCount - 1) * interitemP) / sameLineViewCount;
                if (aspectRatio || !viewWidth) viewWidth = viewHeight;
            }
        }
        else return CGRectZero;
    }
    
    // 修改start值: 增加右边剩余的间距的一半
    // 计算: 增加的距离 = (容器宽度 - 目前开始x值 - 与容器的边缘间距 - 个数 * (宽度 + 间距) + 1个间距(最右边的间距)) / 2
    if (direction == ZJLayoutDirectionHorizontal) {
        viewStartX += (actualConstrainedWith - sameLineViewCount * (viewWidth + interitemP) + interitemP) / 2;
    } else {
        viewStartY += (actualConstrainedHeight - sameLineViewCount * (viewHeight + interitemP) + interitemP) / 2;
    }
    
    // 记录第一个view
    UIView *firstView = nil;
    // 记录最后一个view
    UIView *endView = nil;
    for (NSInteger index = 0; index < count; ++ index) {
        
        // 创建并添加
        UIView *view = nil;
        view = [[viewClass alloc] init];
        [self addSubview:view];
        
        // frame
        CGFloat viewX = viewStartX;
        CGFloat viewY = viewStartY;
        if (direction == ZJLayoutDirectionHorizontal) {
            viewX += index % sameLineViewCount * (viewWidth + interitemP);
            viewY += index / sameLineViewCount * (viewHeight + lineP);
            // 判断是否有足够的空间可以继续下去
            if (viewY + viewHeight > (constrainedSize.height - borderP.bottom)) {
                break;
            }
        } else {
            viewY += index % sameLineViewCount * (viewHeight + interitemP);
            viewX += index / sameLineViewCount * (viewWidth + lineP);
            // 判断是否有足够的空间可以继续下去
            if (viewX + viewWidth > (constrainedSize.width - borderP.right)) {
                break;
            }
        }
        view.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
        
        if (index == 0) {
            firstView = view;
        }
        if (index == (count - 1)) {
            endView = view;
        }
        
        // 给外界的入口
        if (loopCompletionBlock) {
            loopCompletionBlock(index, view);
        }
    }
    
    // 返回实际使用到的区域
    CGFloat usedWidth = CGRectGetMaxX(endView.frame) + borderP.right;
    if (fabs(endView.frame.origin.y - firstView.frame.origin.y) > 0.01) {
        usedWidth = constrainedSize.width;
    }
    CGFloat usedHeight = borderP.top + endView.frame.origin.y + endView.frame.size.height - firstView.frame.origin.y + borderP.bottom;
    return (CGRect){startPoint, {usedWidth, usedHeight}};
}


@end
