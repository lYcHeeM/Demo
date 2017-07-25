//
//  Person.m
//  TestAFBlock
//
//  Created by luozhijun on 2016/10/20.
//  Copyright © 2016年 RickLuo. All rights reserved.
//

#import "Person.h"

@implementation MyString

- (BOOL)isEqual:(id)object
{
    NSLog(@"--isEqual");
    return YES;
}

@end

@implementation Person

- (void)testContains
{
    NSArray *arr = @[@"aaa", @"2016-10-25", [NSObject new], [MyString new]];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"YYYY-MM-dd";
    NSString *str1 = [formater stringFromDate:[[NSDate alloc] init]];
    NSString *str2 = [formater stringFromDate:[[NSDate alloc] init]];
    NSLog(@"%p", str1);
    NSLog(@"%p", str2);
    NSLog(@"%p", arr[1]);
    
    // YES
    BOOL contains1 = [arr containsObject:str1];
    
    NSObject *obj1 = [NSObject new];
    // NO
    BOOL contains2 = [arr containsObject:obj1];
    
    MyString *obj2 = [MyString new];
    // YES
    BOOL contains3 = [arr containsObject:obj2];
    
    NSLog(@"");
}

- (void)dealloc
{
    NSLog(@"--dealloc");
}

@end
