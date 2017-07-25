//
//  Person.m
//  TestAFBlock
//
//  Created by luozhijun on 2016/10/20.
//  Copyright © 2016年 RickLuo. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)request
{
    self.manager = [AFHTTPSessionManager manager];
    [self.manager GET:@"https://httpbin.org/get" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.name = @"success";
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.name = @"failure";
        NSLog(@"%@", error);
    }];
}

- (void)dealloc
{
    NSLog(@"--dealloc");
}

@end
