//
//  AbstractResponse.h
//  NSURLSession&AF3_0 Test
//
//  Created by luozhijun on 15/10/26.
//  Copyright © 2015年 luozhijun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbstractResponse : NSObject

@property (nonatomic, readonly, copy) NSString *errorCode;
@property (nonatomic, readonly, copy) NSString *msg;
@property (nonatomic, readonly, copy) NSString *subCode;
@property (nonatomic, readonly, copy) NSString *subMsg;

@end
