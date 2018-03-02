//
//  Person.m
//  DispatchQueue
//
//  Created by luozhijun on 2018/2/9.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)init
{
    self = [super init];
    if (self) {
        _myQueue = dispatch_queue_create("my_queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)dealloc {
    NSLog(@"---person dealloc---");
}

@end
