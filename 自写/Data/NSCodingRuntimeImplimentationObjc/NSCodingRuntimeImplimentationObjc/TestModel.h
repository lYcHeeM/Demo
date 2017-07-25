//
//  TestModel.h
//  NSCodingRuntimeImplimentationObjc
//
//  Created by luozhijun on 2016/12/26.
//  Copyright © 2016年 RickLuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SubModel;

@interface TestModel : NSObject

@property (nonatomic, copy  ) NSString *nilString;
@property (nonatomic, copy  ) NSString *name;
@property (nonatomic, strong) NSArray<NSNumber *> *intValues;
@property (nonatomic, strong) NSArray<NSNumber *> *doubleValues;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSArray<NSString *> *friendNames;

@property (nonatomic, strong) SubModel *nilSubModel;
@property (nonatomic, strong) NSArray<SubModel *> *nilSubModelArray;
@property (nonatomic, strong) NSDictionary *nilDictionary;
@property (nonatomic, strong) SubModel *subModel;
@property (nonatomic, strong) NSArray<SubModel *> *subModels;
@property (nonatomic, strong) NSDictionary *dictionaryValue;

@end


@interface SubModel : NSObject

@property (nonatomic, strong) NSNumber *nilNumber;
@property (nonatomic, strong) NSArray<NSNumber *> *nilNumbersArray;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSNumber *pie;
@property (nonatomic, copy  ) NSString *identifier;
@property (nonatomic, strong) NSArray<NSString *> *ids;

@end
