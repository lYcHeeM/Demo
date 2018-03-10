//
//  MessageForwarding.m
//  ObjcRuntimeDemo
//
//  Created by luozhijun on 2017/3/7.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

#import "MessageForwarding.h"

@interface OtherTarget : NSObject

@end

@implementation OtherTarget
- (void)action {
    NSLog(@"+++OtherTarget: action+++");
}

@end

@implementation MessageForwarding

- (void)handleUnrecongnizedSelector:(SEL)selector {
    NSLog(@"warning: unrecognized selector --> \"%@\"", NSStringFromSelector(selector));
}

/**
 *  消息转发 Method Forwarding
 *  一般情况下, 给一个实例对象(object)发送消息, 如果它无法响应, 运行时系统将会抛出一个"unrecognized selector sent to ..."的异常. 实际上, 在异常抛出之前, Objc runtime系统为每一个实例对象提供了额外的一次处理未响应消息的机会, 这个过程称为消息转发机制.
 
 *  消息转发的条件:
        1. 实现methodSignatureForSelector方法, 并且必须返回正确的方法签名(由于返回值和两个隐藏参数——self和_cmd, 所以方法签名至少是"v@:");
        2. 对于需要转发的消息, 当前对象不能有对应方法的具体实现, 否则forwardInvocation不会被调用.
 
 *  消息转发作用:
        1. 简单地绕过运行时错误;
        2. 作为一个处理未识别消息(unrecognized messages)的中心, 由开发者决定某个未识别的消息如何去向, 是忽略、还是转发、抑或其他.
        3. 利用第2点, 可以对某些方法作统一的处理.
 */

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"---forwardInvocation begin---");
    id target = [anInvocation target];
    if (![target respondsToSelector:[anInvocation selector]]) {
        // 1.应用1, 转给其他对象响应
//        target = [OtherTarget new];
        // 2.应用2, 如果当前对象无法响应当前消息, 则转为响应一个默认的消息, 比如提示未实现此方法.
        // (需先注释应用1代码)
        [self handleUnrecongnizedSelector:[anInvocation selector]];
    }
    if ([target respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:target];
    }
    NSLog(@"---forwardInvocation end---");
}

/// 实践发现, 此方法不需实现
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    return [OtherTarget new];
//}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"action"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

@end
