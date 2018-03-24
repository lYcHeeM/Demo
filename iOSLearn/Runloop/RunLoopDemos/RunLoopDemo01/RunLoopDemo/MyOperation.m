//
//  MyOperation.m
//  RunLoopDemo
//
//  Created by luozhijun on 2018/3/9.
//  Copyright © 2018年 Haley. All rights reserved.
//

#import "MyOperation.h"
#import <objc/runtime.h>

@interface MyOperation() <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSURLConnection *con;
@end

@implementation MyOperation

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"www.qq.com"] cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval: 20];
        _con = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"+++dealloc");
    struct objc_object a;
}

- (void)start {
    if (!self.isCancelled) {
        [_con start];
    }
    CFRunLoopRun();
    NSLog(@"---leave runloop---");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"---%lld", response.expectedContentLength);
    NSLog(@"---%ld", ((NSHTTPURLResponse *)response).statusCode);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"===%ld", data.length);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"+++connectionDidFinishLoading");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"+++didFailWithError");
}


@end
