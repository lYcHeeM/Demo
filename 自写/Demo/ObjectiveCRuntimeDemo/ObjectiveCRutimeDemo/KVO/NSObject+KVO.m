//
//  NSObject+NSObject_KVO.m
//  ObjcRuntimeDemo
//
//  Created by luozhijun on 2017/3/13.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString *const ZJKVOClassPrefix         = @"ZJKVOClassPrefix_";
static void *ZJKVOAssociatedObserversKey = &ZJKVOAssociatedObserversKey;

@interface ZJObserverInfo : NSObject
@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, copy) ZJObserverNotification notification;
@end

@implementation ZJObserverInfo
- (instancetype)initWithObserver:(NSObject *)observer keyPath:(NSString *)key notification:(ZJObserverNotification)notification {
    self = [super init];
    if (self) {
        _observer     = observer;
        _keyPath      = key;
        _notification = notification;
    }
    return self;
}
@end


@implementation NSObject (KVO)

#pragma mark - Helpers
static NSString *setterForKey(NSString *getter) {
    if (getter.length <= 0) {
        return nil;
    }
    
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [getter substringFromIndex:1];
    
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingLetters];
    
    return setter;
}

static NSString *getterForSetter(NSString *setter) {
    if (setter.length <=0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    
    // 去掉"set:"
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    
    // 首字母小写
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetter];
    
    return key;
}

static Class zjKVO_class(id self, SEL _cmd) {
    // 注意到self的isa此时已经指向了临时类, 而临时类继承自原来的self, 所以此处需要getSuperclass
    return class_getSuperclass(object_getClass(self));
}

- (Class)kvoClassForOriginalClass:(NSString *)originalClassName {
    NSString *kvoClassName = [ZJKVOClassPrefix stringByAppendingString:originalClassName];
    Class class = NSClassFromString(kvoClassName);
    
    // 如果之前对相同类的实例添加过观察, 并且尚未移除观察, 则class应该存在, 不需重建
    if (class) {
        return class;
    }
    
    // 运行时生成新类, 并令其继承于self(被监听的类)
    Class originalClass = object_getClass(self);
    Class kvoClass = objc_allocateClassPair(originalClass, kvoClassName.UTF8String, 0);
    
    // 重写[object class]方法, 使得kvo对使用者来说透明化
    Method classMethod = class_getInstanceMethod(originalClass, @selector(class));
    const char *typeEcoding = method_getTypeEncoding(classMethod);
    class_addMethod(kvoClass, @selector(class), (IMP)zjKVO_class, typeEcoding);
    
    objc_registerClassPair(kvoClass);
    
    return kvoClass;
}

/**
 *  判断当前类是否包含某个selector
 */
- (BOOL)hasSelector:(SEL)selector {
    Class class = object_getClass(self);
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(class, &methodCount);
    for (NSInteger index = 0; index < methodCount; index ++) {
        SEL thisSelector = method_getName(methodList[index]);
        if (selector == thisSelector) {
            free(methodList);
            return YES;
        }
    }
    
    free(methodList);
    return NO;
}

static void kvo_setter(id self, SEL _cmd, id newValue) {
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterForSetter(setterName);
    
    if (!getterName) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have setter %@", self, setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
        return;
    }
    
    // setter调用之前的值
    id oldValue = [self valueForKey:getterName];
    
    struct objc_super superClass = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    
    // 为了屏蔽编译器的警告, 此处把函数指针显式转换
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    
    // 以newValue调原始类(即当前临时类的父类)的setter
    objc_msgSendSuperCasted(&superClass, _cmd, newValue);
    
    // 通知所有观察者
    NSMutableArray *observers = objc_getAssociatedObject(self, ZJKVOAssociatedObserversKey);
    for (ZJObserverInfo *observerInfo in observers) {
        if ([observerInfo.keyPath isEqualToString:getterName]) {
            if (observerInfo.notification) {
                observerInfo.notification(self, getterName, oldValue, newValue);
            }
        }
    }
}

#pragma mark -

- (void)zj_addObserver:(NSObject *)observer forKeyPath:(NSString *)key changed:(ZJObserverNotification)notification {
    // 获取setter指针
    SEL setterSelector = NSSelectorFromString(setterForKey(key));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    if (!setterMethod) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have a setter for key %@", self, key];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
        return;
    }
    
    // 判断当前类是否已经被监听
    Class selfClass = object_getClass(self);
    NSString *selfClassName = NSStringFromClass(selfClass);
    
    // 如果没有正在被监听, 则生成临时类, 并把当前类的isa指向这个临时类
    if (![selfClassName hasPrefix:ZJKVOClassPrefix]) {
        selfClass = [self kvoClassForOriginalClass:selfClassName];
        object_setClass(self, selfClass);
    }
    
    // 判断当前类(已把isa指向临时类)是否已有"key"属性的setter, 如果没有, 生成一个
    if (![self hasSelector:setterSelector]) {
        const char *typeEncoding = method_getTypeEncoding(setterMethod);
        class_addMethod(selfClass, setterSelector, (IMP)kvo_setter, typeEncoding);
    }
    
    // 把观察者添加到被观察对象的观察者列表中
    ZJObserverInfo *observerInfo = [[ZJObserverInfo alloc] initWithObserver:observer keyPath:key notification:notification];
    NSMutableArray *observers = objc_getAssociatedObject(self, ZJKVOAssociatedObserversKey);
    if (!observers) {
        observers = @[].mutableCopy;
        objc_setAssociatedObject(self, ZJKVOAssociatedObserversKey, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [observers addObject:observerInfo];
}

- (void)zj_removeObserve:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    NSMutableArray *observers = objc_getAssociatedObject(self, ZJKVOAssociatedObserversKey);
    ZJObserverInfo *removingObserverInfo = nil;
    for (ZJObserverInfo *observerInfo in observers) {
        if (observerInfo.observer == observer && [observerInfo.keyPath isEqualToString:keyPath]) {
            removingObserverInfo = observerInfo;
        }
    }
    [observers removeObject:removingObserverInfo];
}

@end
