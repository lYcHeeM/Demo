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
        _notification = [notification copy];
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

/// 返回临时类的类名, 为了对调用者透明, 此处返回原始对象的类名
static Class zjKVO_class(id self, SEL _cmd) {
    // 注意到, 此函数在当前category不会被调用, 真正被调用的时候是外界获取当前对象的类名,
    // 故进入到此函数时, self的isa已经指向了临时类,
    // 而临时类继承自原来的self, 所以此处需要getSuperclass
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
    // 已当前类作为父类生成一个中间类
    Class kvoClass = objc_allocateClassPair(originalClass, kvoClassName.UTF8String, 0);
    
    // 重写[objc_object class]方法, 使得kvo对使用者来说透明化;
    // 无须重写objc_class的实例方法(即所谓的类方法)[objc_class class], 因为外界并不能用
    // ZJKVOClassPrefix_xxx来执行形如[ZJKVOClassPrefix_xxx class]的代码, 外界只能
    // 用实例对象来获取类名, 诸如[object class], 即使执行[[object class] class],
    // 也是无妨的, 因为第一对中括号消息返回的已经是原始类名了, 用原始类的class方法一定会返回原始类名,
    // 所以此处重写类的实例方法即可; 而且实践发现, 重写了[object class]方法后, [object superclass]也
    // 能得到原始类的父类, 而不是临时类的父类(注意零时类的父类就是原始类), 估计寻找父类的过程应是
    // [[object class] superclass].
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

/// 原理: Objc Runtime系统的综合应用
/// 1. 假设被观察的对象为a, 须生成一个临时类B, B继承自对象a的类A, 即为B->A;
/// 2. 之后改写对象a的isa指针, 使它指向B, 同时为了不干扰原始的继承链, 须重写
/// 临时类B的class方法, 使它返回原始类的Class(objc_class)对象, 而且, 此时对a调用
/// [a superclass]也能正确得到原始类的父类, 因为Objc Runtime查找父类的过程是这样发消息的
/// [[object class] superclass];
/// 3. 之后重写临时类的setter方法, 由于临时类B是A的子类, 所以重写过程中, 需要调用父类A的
/// setter方法, 并在重写的setter方法的末尾通知当前对象的所有观察者, 把oldValue、newValue
/// 通过回调发给观察者;
/// 4. 通过AssociatedObjects方式, 维护一个集合, 里面引用所有观察者, 所以外界有责任在
/// 适宜的时机移除观察(removeObserver方法).
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
        // 改写isa指针
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

- (void)zj_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
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
