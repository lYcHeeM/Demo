//
//  UnderstandingSelfAndSuper.h
//  01-OC-SelfAndSuper
//
//  Created by luozhijun on 16/9/13.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 自定义log */
#ifdef DEBUG // 调试
#define DebugLog(fmt, ...) {NSLog((@"%s\n [Line %d] DEBUG:--->" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else // 发布打包
#define DebugLog(...)
#endif

@interface Person : NSObject

@property (nonatomic, copy) NSString *lastName;

- (void)run;

@end


@interface ChenPerson : Person

@end