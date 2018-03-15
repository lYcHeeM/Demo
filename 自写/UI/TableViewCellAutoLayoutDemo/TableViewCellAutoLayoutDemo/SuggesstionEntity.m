//
//  SuggestionEntity.m
//  TableViewCellAutoLayoutDemo
//
//  Created by luozhijun on 15-6-12.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "SuggesstionEntity.h"

@implementation SuggesstionEntity
- (NSDictionary *)objectClassInArray
{
    return @{@"images": [SuggesstionImage class],
             @"reverts": [SuggesstionReplyEntity class]};
}

@end
