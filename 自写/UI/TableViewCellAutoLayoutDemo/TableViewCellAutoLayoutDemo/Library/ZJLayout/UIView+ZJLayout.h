//
//  UIView+ZJLayout.h
//  button
//
//  Created by luozhijun on 14-12-20.
//  Copyright (c) 2014年 luozhijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJLayoutDefine.h"
#import "UIView+LabelLayout.h"
#import "UIView+ButtonLayout.h"
#import "UIView+ImageViewLayout.h"

@interface UIView (ZJLayout)

@property (assign, nonatomic) CGFloat origin_x;
@property (assign, nonatomic) CGFloat origin_y;
@property (assign, nonatomic) CGFloat size_width;
@property (assign, nonatomic) CGFloat size_height;
@property (assign, nonatomic) CGSize frame_size;
@property (assign, nonatomic) CGPoint frame_origin;

/**
 *  对需要适应文字宽度控件的排列式布局
 *
 *  @param viewClass           控件的类名
 *  @param direction           方向, 目前仅支持横向布局
 *  @param constrainedRect     限制在父视图上的区域, 比如 containerView.bounds 就为容器的全局区域
 *  @param fixedWidth          是否需固定每个控件的宽度. nil为不需要, 将根据内容来计算最小需要的宽度
 *  @param fixedHeight         是否固定每个控件的高度. nil为不需要, 将根据内容来计算最小需要的高度.
 *  @param borderPadding       在限制的rect中的边缘间距
 *  @param interitemPadding    同一行中相邻两个view之间的间距
 *  @param linePadding         相邻两行之间的间距
 *  @param titles              所有的标题, 可以理解为数据源
 *  @param fontSize            文字内容的大小
 *  @param loopCompletionBlock 每次循环后的回调, 外界可通过此接口获得每次循环的index和对应的view
 *
 *  @return 实际使用到的区域, 边缘间距也会算入
 */
- (CGRect)layoutTextAdaptedViewsWithViewClass:(Class)viewClass inDirection:(ZJLayoutDirection)direction constrainedToRect:(CGRect)constrainedRect fixedWidth:(NSNumber *)fixedWidth fixedHeight:(NSNumber *)fixedHeight borderPadding:(UIEdgeInsets)borderPadding interitemPadding:(NSNumber *)interitemPadding linePadding:(NSNumber *)linePadding titles:(NSArray *)titles fontSize:(CGFloat)fontSize loopCompletionBlock:(LayoutLoopCompletionBlock)loopCompletionBlock;

/**
 *  对相同尺寸的控件进行排列式布局
 *
 *  @param viewClass           控件的类名
 *  @param direction           排列方向, 水平或垂直
 *  @param constrainedRect     限制在父视图上的区域, 比如 containerView.bounds 就为容器的全局区域
 *  @param fixedSize           每个控件固定的尺寸  <br/><b>fixedSize</b> 有两种传递方式:<br/>
 *      1.宽高都为非零<br/>
 *          1.1 指定fixedLineCount(每一排的个数), 此时view之间的间距被忽略, 将根据fixedLineCount重新计算<br/>
 *          1.2 不指定fixedLineCount, 将使用view之间的间距参数<br/>
 *      2.宽高至少一个为0 此时必须指定fixedLineCount(每一排的个数)<br/>
 *          2.1 当横向布局时, 提供高; 反之提供宽, 此时aspectRatio可指定是否宽高相等<br/>
 *          2.2 都不提供, 即宽高都为零, 宽高将相等
 *  @param aspectRatio         宽高是否相等, 只在一种情况下有效, 即指定fixedSize时, 在横向布局提供高; 反之提供宽<br/>
 *                             此时, 如果为YES, 忽略提供的宽或高, 使宽和高保持一致
 *  @param fixedLineCount      固定一行的数量, 在fixedSize宽高不同时非零的时候必须指定
 *  @param borderPadding       在限制的rect中的边缘间距
 *  @param interitemPadding    同一行中相邻两个view之间的间距
 *  @param linePadding         相邻两行之间的间距
 *  @param count               需要创建的数量
 *  @param loopCompletionBlock 每次循环后的回调, 外界可通过此接口获得每次循环的index和对应的view
 *
 *  @return 实际使用到的区域, 边缘间距也会算入
 */
- (CGRect)layoutSameSizedViewsWithViewClass:(Class)viewClass inDirection:(ZJLayoutDirection)direction constrainedToRect:(CGRect)constrainedRect fixedSize:(CGSize)fixedSize aspectRatio:(BOOL)aspectRatio fixedLineCount:(NSNumber *)fixedLineCount borderPadding:(UIEdgeInsets)borderPadding interitemPadding:(NSNumber *)interitemPadding linePadding:(NSNumber *)linePadding count:(NSInteger)count loopCompletionBlock:(LayoutLoopCompletionBlock)loopCompletionBlock;

@end
