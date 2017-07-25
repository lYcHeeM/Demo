//
//  NSObject+NSObject_KVO.h
//  ObjcRuntimeDemo
//
//  Created by luozhijun on 2017/3/13.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ZJObserverNotification)(NSObject * observedObj, NSString *keyPath, id oldValue, id newValue);

@interface NSObject (KVO)

- (void)zj_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath changed:(ZJObserverNotification)notification;
- (void)zj_removeObserve:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end
