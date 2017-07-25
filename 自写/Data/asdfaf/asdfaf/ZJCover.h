//
//  ZJCover.h
//  mobiportal
//
//  Created by JC.Wang on 14/11/23.
//  Copyright (c) 2014年 bgyun. All rights reserved.
//  遮盖

#import <UIKit/UIKit.h>

/** 遮盖 */
@interface ZJCover : UIView
/** 透明时的alpha值， 默认为0.35 */
@property (nonatomic, assign) CGFloat translucentAlpha;
@property (nonatomic, copy) void (^coverTapedBlock)(ZJCover *cover);
@end
