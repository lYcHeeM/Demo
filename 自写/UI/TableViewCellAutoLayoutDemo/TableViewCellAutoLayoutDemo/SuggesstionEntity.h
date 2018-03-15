//
//  SuggestionEntity.h
//  TableViewCellAutoLayoutDemo
//
//  Created by luozhijun on 15-6-12.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MJExtension.h"
#import "SuggesstionReplyEntity.h"
#import "SuggesstionImage.h"

/** 建议 实体 */
@interface SuggesstionEntity : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
/** 图片列表 */
@property (nonatomic, strong) NSArray *images;
/** 回复列表 */
@property (nonatomic, strong) NSArray *reverts;

@property (nonatomic, assign) CGFloat revertCellsNeedHeight;

@end
