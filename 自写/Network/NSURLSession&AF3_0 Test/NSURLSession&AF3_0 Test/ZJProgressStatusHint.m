//
//  ZJProgressStatusHint.m
//  NSURLSession&AF3_0 Test
//
//  Created by luozhijun on 15/10/28.
//  Copyright © 2015年 luozhijun. All rights reserved.
//

#import "ZJProgressStatusHint.h"

@implementation ZJProgressStatusHint

+ (instancetype)objectWithloadingHint:(NSString *)loadingHint successHint:(NSString *)successHint failureHint:(NSString *)failureHint
{
    ZJProgressStatusHint *obj = [[ZJProgressStatusHint alloc] init];
    obj.loadingHint = loadingHint;
    obj.successHint = successHint;
    obj.failureHint = failureHint;
    return obj;
}

@end
