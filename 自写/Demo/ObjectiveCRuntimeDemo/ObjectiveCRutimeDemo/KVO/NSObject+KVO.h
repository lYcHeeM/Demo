//
//  NSObject+NSObject_KVO.h
//  ObjcRuntimeDemo
//
//  Created by luozhijun on 2017/3/13.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ZJObserverNotification)(NSObject * observedObj, NSString *keyPath, id oldValue, id newValue);

@interface NSObject (KVO)

- (void)zj_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath changed:(ZJObserverNotification)notification;
- (void)zj_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end
NS_ASSUME_NONNULL_END
