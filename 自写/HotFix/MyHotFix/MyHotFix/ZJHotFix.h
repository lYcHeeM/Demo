//
//  ZJHotFix.h
//  MyHotFix
//
//  Created by luozhijun on 2018/3/24.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJHotFix : NSObject

+ (void)replaceMethodWithScript:(NSString *)jsCode;

@end
