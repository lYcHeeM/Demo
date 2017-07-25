//
//  UnderstandingSelfAndSuper.m
//  01-OC-SelfAndSuper
//
//  Created by luozhijun on 16/9/13.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#import "UnderstandingSelfAndSuper.h"

@implementation Person

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 在init方法中如果调用会被子类重写的函数，这样将会导致子类在这个函数中，调用的是子类已经重写后的方法,
        // 如果我们的意图是在父类的init中调用父类自己的同名方法, 这么写将导致子类在init调用的是自己重写过后的方法, 导致与期望结果不一致
        // 例子如下：子类重写了lastName的set方法，也重写了run方法，那么子类在init的时候真正调用的是自己重写过后的方法
        // 看看子类初始化时候的调用结果如何
        // 此现象的原因是子类调用[super init]时，super其实和self是同一个对象，super与self不同的是，它将指示编译器去父类的方法列表中查找方法。
        self.lastName = @"Jacky";
        [self run];
    }
    return self;
}

- (void)setLastName:(NSString *)lastName
{
    _lastName = [lastName copy];
    DebugLog(@" ");
}

- (void)run
{
    DebugLog(@"Person--run");
}

@end


@implementation ChenPerson

- (void)setLastName:(NSString *)lastName
{
    lastName = [lastName stringByAppendingString:@" Chen"];
    [super setLastName:lastName];
    DebugLog(@"%@", self.lastName);
}

- (void)run
{
    DebugLog(@"%@ >>> run", self.lastName);
}


@end
