//
//  ZJProgressStatusHint.h
//  NSURLSession&AF3_0 Test
//
//  Created by luozhijun on 15/10/28.
//  Copyright © 2015年 luozhijun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJProgressStatusHint : NSObject
@property (nonatomic, strong, nullable) NSString *loadingHint;
@property (nonatomic, strong, nullable) NSString *successHint;
@property (nonatomic, strong, nullable) NSString *failureHint;

+ (instancetype)objectWithloadingHint:(NSString * _Nullable)loadingHint successHint:(NSString * _Nullable)successHint failureHint:(NSString * _Nullable)failureHint;
@end
