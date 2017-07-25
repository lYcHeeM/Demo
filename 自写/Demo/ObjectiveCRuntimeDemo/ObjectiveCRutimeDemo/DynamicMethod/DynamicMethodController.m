//
//  DynamicMethodController.m
//  ObjcRuntimeDemo
//
//  Created by luozhijun on 2017/3/16.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

#import "DynamicMethodController.h"
#import <objc/runtime.h>

@interface DynamicMethodController ()

@end

@implementation DynamicMethodController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SEL dynamic_sel = @selector(resolveThisMethodDynamically);
    NSLog(@"%@", @([self respondsToSelector:dynamic_sel]));
    [self performSelector:dynamic_sel];
    
    class_addMethod([self class], @selector(action), (IMP)actionIMP, "v@:@");
    [self performSelector:@selector(action) withObject:@10];
}

/**
 *  一个Objc方法其实就是一个C函数, 只不过这个C函数带有"self"和"_cmd"这两个隐藏参数
 */
void actionIMP(id self, SEL _cmd, NSNumber *num) {
    NSLog(@"-----actionIMP: %@", num);
}

void dynamicMethodIMP(id self, SEL _cmd, int num) {
    NSLog(@"---dynamicMethodIMP");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(resolveThisMethodDynamically)) {
        class_addMethod([self class], sel, (IMP)dynamicMethodIMP, "v@:i");
    }
    return  [super resolveInstanceMethod:sel];
}

@end
