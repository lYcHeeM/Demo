//
//  NSObject+NSCoding.h
//  Version 1.0
//
//  Created by Freak on 14-10-13.
//  Copyright (c) 2014年 lychee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ZJCodingImplementation \
- (id)initWithCoder:(NSCoder *)aDecoder \
{ \
    if (self = [super init]) { \
        [self decodingWithDecoder:aDecoder]; \
    } \
    return self; \
} \
- (void)encodeWithCoder:(NSCoder *)aCoder \
{ \
    [self encodingWithEncoder:aCoder]; \
}

/**
 *  功能:
 *      如果某个自定义对象需要支持归档, 使用此分类的两个方法可省去手写encodeWithCoder:方法和initWithCoder:方法中的所有代码。
 *
 *  使用方法:
 *      1. 包含头文件
 *      2. 遵循NSCoding协议
 *      3. 在.m文件中输入宏: ZJEncodingAndDecoding
 * 
 *  注意:
 *      如果需要归档的对象有集合类型的属性, 集合中的对象也需做同样的操作, 比如NSArray, NSArray作为encodeObject:ForKey:方法中的参数时, 实际上是作用于其内部所有对象.
 */
@interface NSObject (ArchiveCoding)

- (void)encodingWithEncoder:(NSCoder *)encoder;
- (void)decodingWithDecoder:(NSCoder *)decoder;

@end
