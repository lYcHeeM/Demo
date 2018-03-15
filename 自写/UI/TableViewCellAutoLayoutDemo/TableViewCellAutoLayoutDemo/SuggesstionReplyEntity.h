//
//  SuggesstionReplyEntity.h
//  TableViewCellAutoLayoutDemo
//
//  Created by luozhijun on 15-6-12.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 建议的回复实体 */
@interface SuggesstionReplyEntity : NSObject

@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *content;

@end
