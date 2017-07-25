//
//  NSObject+NSCoding.m
//
//
//  Created by Freak on 14-10-13.
//  Copyright (c) 2014年 lychee. All rights reserved.
//

#import "NSObject+NSCoding.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSObject (ArchiveCoding)

- (void)encodingWithEncoder:(NSCoder *)encoder
{
    [self encodingOrDecodingWithEncoder:encoder decoder:nil];
}

- (void)decodingWithDecoder:(NSCoder *)decoder
{
    [self encodingOrDecodingWithEncoder:nil decoder:decoder];
}

- (void)encodingOrDecodingWithEncoder:(NSCoder *)encoder decoder:(NSCoder *)decoder
{
    Class c = [self class];
    
    while (c) {
        // 1.获得所有成员变量
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(c, &outCount);
        
        for (int i = 0; i < outCount; ++i) {
            Ivar ivar = ivars[i];
            
            // 2.获得属性名
            NSMutableString *propertyName = [NSMutableString stringWithUTF8String:ivar_getName(ivar)];
            
            // 删除头部的下划线
            [propertyName replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
            
            // 3.获得getter方法的SEL
            SEL getterSelector = NSSelectorFromString(propertyName);
            
            // 4.获得setter方法的SEL
            // 首字母大写
            NSString *cap = [[propertyName substringToIndex:1] uppercaseString];
            NSString *capitalPropertyName = [NSString stringWithFormat:@"%@%@", cap, [propertyName substringFromIndex:1]];
            // 拼接setter方法名
            NSString *setterString = [NSString stringWithFormat:@"%@%@:", @"set", capitalPropertyName];
            SEL setterSelector = NSSelectorFromString(setterString);
            
            
            // 5.获得属性类型
            NSString *propertyType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            if ([propertyType hasPrefix:@"@"]) { // 对象类型
                if (encoder) {
                    // 获得属性对象, 通过getter获得
                    id propertyObj = objc_msgSend(self, getterSelector);
                    // 以属性名为key, 属性对象为值调用encoder的方法
                    [encoder encodeObject:propertyObj forKey:propertyName];
                } else {
                    id propertyObj = [decoder decodeObjectForKey:propertyName];
                    objc_msgSend(self, setterSelector, propertyObj);
                }
            } else { // 非对象类型 目前只支持int, long long, long double三种类型; double还未找到对应的objc_msgSend方法
                if ([propertyType isEqualToString:@"i"]) { // int
                    if (encoder) {
                        int intProperty = (int)objc_msgSend(self, getterSelector);
                        [encoder encodeInt:intProperty forKey:propertyName];
                    } else {
                        int intProperty = [decoder decodeIntForKey:propertyName];
                        objc_msgSend(self, setterSelector, intProperty);
                    }
                } else if ([propertyType isEqualToString:@"D"]) { // long double
                    if (encoder) {
                        long double longDoubleProperty = objc_msgSend_fpret(self, getterSelector);
                        // 强转成double
                        double temp = (double)longDoubleProperty;
                        [encoder encodeDouble:temp forKey:propertyName];
                    } else {
                        long double longDoubleProperty = [decoder decodeDoubleForKey:propertyName];
                        objc_msgSend(self, setterSelector, longDoubleProperty);
                    }
                } else if ([propertyType isEqualToString:@"q"]) { // long long
                    if (encoder) {
                        long long longLongProperty = (long long)objc_msgSend(self, getterSelector);
                        [encoder encodeInt64:longLongProperty forKey:propertyName];
                    } else {
                        long long longLongProperty = [decoder decodeInt64ForKey:propertyName];
                        objc_msgSend(self, setterSelector, longLongProperty);
                    }
                }
            }
        }
        
        // 释放内存
        free(ivars);
        
        // 接着遍历父类
        c = class_getSuperclass(c);
    }
}
@end
