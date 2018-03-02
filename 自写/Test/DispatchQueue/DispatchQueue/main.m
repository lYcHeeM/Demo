//
//  main.m
//  DispatchQueue
//
//  Created by luozhijun on 2018/2/9.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

void test(void);
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        test();
        sleep(3);
    }
    return 0;
}
/**
 Creates a new dispatch queue to which blocks can be submitted.
 Blocks submitted to a serial queue are executed one at a time in FIFO order. Note, however, that blocks submitted to independent queues may be executed concurrently with respect to each other. Blocks submitted to a concurrent queue are dequeued in FIFO order but may run concurrently if resources are available to do so.
 If your app isn’t using ARC, you should call dispatch_release on a dispatch queue when it’s no longer needed. Any pending blocks submitted to a queue hold a reference to that queue, so the queue is not deallocated until all pending blocks have completed.
 */
/**
 实测对象p被释放了, 但myQueue属性还未被释放, 原因见注释, block ^{sleep(1);NSLog(@"+++");}若还未执行完, 就会对queue产生引用; 但queue未被释放, 不会造成对象p不释放;
 */
void test() {
    Person *p = [[Person alloc] init];
    dispatch_async(p.myQueue, ^{
        sleep(1);
        NSLog(@"+++");
    });
}
