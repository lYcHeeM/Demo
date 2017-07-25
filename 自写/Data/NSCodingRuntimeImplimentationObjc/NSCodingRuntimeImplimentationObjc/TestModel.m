//
//  TestModel.m
//  NSCodingRuntimeImplimentationObjc
//
//  Created by luozhijun on 2016/12/26.
//  Copyright © 2016年 RickLuo. All rights reserved.
//

#import "TestModel.h"
#import "NSObject+NSCoding.h"

@implementation TestModel
ZJCodingImplementation
- (instancetype)init
{
    self = [super init];
    if (self) {
        _name            = @"Rick";
        _intValues       = @[@10, @100, @1000];
        _doubleValues    = @[@1.1, @1.1112, @3.144422];
        _height          = @1.82;
        _friendNames     = @[@"Harry", @"Bill"];

        _subModel        = [[SubModel alloc] init];

        SubModel *temp1  = [[SubModel alloc] init];
        temp1.identifier = @"SubModel_1";
        SubModel *temp2  = [[SubModel alloc] init];
        temp2.identifier = @"SubModel_2";
        _subModels       = @[temp1, temp2];
        
        SubModel *temp3  = [[SubModel alloc] init];
        temp3.identifier = @"SubModel_3";
        _dictionaryValue = @{@"1": @"lYcHeeM", @"2": @"剑气箫心", @"3": temp3};
    }
    return self;
}

@end


@implementation SubModel
ZJCodingImplementation
- (instancetype)init
{
    self = [super init];
    if (self) {
        _count      = @10;
        _pie        = @3.1415926;
        _identifier = @"SubModel";
        _ids        = @[@"01231", @"01232", @"12310"];
    }
    return self;
}

@end






