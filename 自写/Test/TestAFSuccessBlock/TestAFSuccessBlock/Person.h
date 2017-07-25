//
//  Person.h
//  TestAFBlock
//
//  Created by luozhijun on 2016/10/20.
//  Copyright © 2016年 RickLuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface Person : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) AFHTTPSessionManager *manager;

- (void)request;

@end
