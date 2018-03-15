//
//  ZJLayoutDefine.h
//  button
//
//  Created by luozhijun on 14-12-21.
//  Copyright (c) 2014年 luozhijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  排列式布局的方向
 *  @note 在适应文字内容的排列式布局中仅支持横向
 */
typedef enum {
    ZJLayoutDirectionVertical,
    ZJLayoutDirectionHorizontal
}ZJLayoutDirection;

/** 
 *  每次排列循环后的回调, 可以拿到当次循环的下标和对应的view
 */
typedef void (^LayoutLoopCompletionBlock)(NSInteger index, id view);

/** 
 *  被布局的view与限制的布局区域之间的默认边缘间距
 */
static const UIEdgeInsets ZJLayoutDefaultBorderPadding = {10.f, 10.f, 10.f, 10.f};
/** 
 *  排列式布局中
 *  同一行(如果为纵向布局则为同一列)相邻两个view之间的默认间距
 */
static const CGFloat ZJLayoutDefaultInteritemPadding = 10.f;
/** 
 *  排列式布局中
 *  每相邻两行(或两列)之间的默认间距
 */
static const CGFloat ZJLayoutDefaultLinePadding = 10.f;
/** 
 *  适应文字内容的排列式布局中<br/>
 *  同一行(或同一列)相邻两个view之间的默认间距
 */
static const CGFloat ZJLayoutDefaultTextInteritemPadding = 6.f;
/**
 *  适应文字内容的排列式布局中
 *  每相邻两行(或两列)之间的默认间距
 */
static const CGFloat ZJLayoutDefaultTextLinePadding = 7.f;
/**
 *  适应文字内容的排列式布局中
 *  控件水平方向增加的尺寸(即宽度)
 */
static const CGFloat ZJLayoutAddtionalSizeVertical = 5.f;
/**
 *  适应文字内容的排列式布局中
 *  控件垂直方向增加的尺寸(即高度)
 */
static const CGFloat ZJLayoutAddtionalSizeHorizontal = 5.f;

