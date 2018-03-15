//
//  CombinationCalculater.h
//  Combination
//
//  Created by luozhijun on 15/7/15.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CombinationCalculater : NSObject

@property (nonatomic, strong) NSArray *sourceDataArray;
@property (nonatomic, assign) NSInteger numberOfElements;
@property (nonatomic, copy, readonly) NSArray *reslut;
@property (nonatomic, copy, readonly) NSString *resultString;

- (void)calculateResult;
- (void)generateResultString;

@end
