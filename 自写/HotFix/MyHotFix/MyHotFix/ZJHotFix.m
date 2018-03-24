//
//  ZJHotFix.m
//  MyHotFix
//
//  Created by luozhijun on 2018/3/24.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#import "ZJHotFix.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#import "Aspects.h"

@implementation ZJHotFix

+ (JSContext *)JSContex {
    static JSContext *ctx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ctx = [[JSContext alloc] init];
    });
    return ctx;
}

+ (void)evaluateScript:(NSString *)javascriptString {
    [[self JSContex] evaluateScript:javascriptString];
}

+ (void)__replaceMethod:(BOOL)isClassMethod calssName:(NSString *)className selectorName:(NSString *)selectorName fixedImp:(JSValue *)fixedImp {
    Class clazz = NSClassFromString(className);
    if (isClassMethod) {
        clazz = objc_getClass([className UTF8String]);
    }
    SEL sel = NSSelectorFromString(selectorName);
    if (!clazz || !sel) return;
    
    NSError *error = nil;
    [clazz aspect_hookSelector:sel withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info) {
        JSValue *jsObj = [fixedImp callWithArguments:@[info.instance, info.originalInvocation, info.arguments]];
        BOOL shouldCallOriginal = [jsObj toBool];
        if (shouldCallOriginal) {
            [info.originalInvocation invoke];
        }
    } error:&error];
    if (error) NSLog(@"++%@", error);
}

+ (void)replaceMethodWithScript:(NSString *)jsCode {
    [self JSContex][@"replaceInstanceMethod"] = ^(NSString *className, NSString *selectorName, JSValue *fixedImp) {
        [self __replaceMethod:NO calssName:className selectorName:selectorName fixedImp:fixedImp];
    };
    [self JSContex][@"replaceClassMethod"] = ^(NSString *className, NSString *selectorName, JSValue *fixedImp) {
        [self __replaceMethod:YES calssName:className selectorName:selectorName fixedImp:fixedImp];
    };
    
    [[self JSContex] evaluateScript:@"var console = {}"];
    [self JSContex][@"console"][@"log"] = ^(id message) {
        NSLog(@"Javascript log: %@",message);
    };
    
    [[self JSContex] evaluateScript:jsCode];
}

@end
