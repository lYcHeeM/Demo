//
//  CombinationCalculater.m
//  Combination
//
//  Created by luozhijun on 15/7/15.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "CombinationCalculater.h"

@interface CombinationCalculater ()
@property (nonatomic, strong) NSNumber *maxOfSourceData;
@end

@implementation CombinationCalculater

- (void)calculateResult
{
    _sourceDataArray = [self standardizedDataWithSourceData:self.sourceDataArray];
    _maxOfSourceData = [_sourceDataArray lastObject];
    _reslut = [self combinationsOfData:self.sourceDataArray numberOfElements:self.numberOfElements];
}

- (void)generateResultString
{
    NSMutableString *resultString = @"".mutableCopy;
    [resultString appendFormat:@"\"\nresults of C %ld/%ld:\n  ", self.numberOfElements, self.sourceDataArray.count];
    
    NSInteger i = 0;
    for (NSArray *aCombination in self.reslut) {
        NSMutableString *subString = @"".mutableCopy;
//        [subString appendString:@"{"];
        
        NSInteger j = 0;
        for (NSNumber *anElement in aCombination) {
            [subString appendString:anElement.stringValue];
            if (j < aCombination.count - 1) {
//                [subString appendString:@", "];
                [subString appendString:@" "];
            }
            if ([anElement isEqualToNumber:self.maxOfSourceData]) {
                [subString appendString:@", \n  "];
            }
            ++ j;
        }
        if (i < self.reslut.count &&
            ![subString rangeOfString:@"\n"].length) {
            [subString appendString:@", "];
        }
//        [subString appendString:@"}"];
        [resultString appendString:subString];
    }
    
    [resultString appendString:@"\n\""];
    _resultString = resultString;
}

- (NSMutableArray *)combinationsOfData:(NSArray *)data numberOfElements:(NSInteger)numberOfElements
{
    NSInteger usingElementsCount = data.count - numberOfElements + 1;
    
    // 取出前n-r+1个元素
    NSMutableArray *usingElements = [NSMutableArray arrayWithCapacity:usingElementsCount];
    for (NSInteger index = 0; index < usingElementsCount; ++ index) {
        [usingElements addObject:data[index]];
    }
    
    if (numberOfElements > 1) {// r > 1 迭代
        
        NSMutableArray *nextData = [NSMutableArray arrayWithArray:data];
        [nextData removeObjectAtIndex:0];
        
        NSInteger nextElements = numberOfElements - 1;
        
        NSMutableArray *nextResult = [self combinationsOfData:nextData numberOfElements:nextElements];
        
        NSMutableArray *result = @[].mutableCopy;
        
        for (NSInteger i = 0; i < usingElements.count; ++ i) {
            
            NSMutableIndexSet *nextResultRemovingIndexes = [NSMutableIndexSet indexSet];
            
            NSInteger j = 0;
            for (NSArray *aCombination in nextResult) {
                NSMutableArray *temp = @[].mutableCopy;
                [temp addObject:usingElements[i]];
                for (NSNumber *aDataElement in aCombination) {
//                    if ([aDataElement isKindOfClass:[NSNumber class]]) {
                        [temp addObject:aDataElement];
                        if (i < usingElements.count - 1) {
                            // 为了避免重复判断 [aDataElement isEqualToNumber:usingElements[i + 1]]
                            // 此处加了一个判断, 判断将要移除的所有下标中j是否存在
                            if (![nextResultRemovingIndexes containsIndex:j] &&
                                [aDataElement isEqualToNumber:usingElements[i + 1]]) {
                                [nextResultRemovingIndexes addIndex:j];
                            }
                        }
//                    }
                }
                [result addObject:temp];
                ++ j;
            }
            [nextResult removeObjectsAtIndexes:nextResultRemovingIndexes];
        }
        return result;
    }
    else { // r = 1 直接返回
        NSMutableArray *result = @[].mutableCopy;
        for (NSNumber *aDataElement in data) {
            [result addObject:@[aDataElement]];
        }
        // 增加一个用与打印换行的标识
//        [result addObject:@"\n"];
        return result;
    }
}

- (NSArray *)standardizedDataWithSourceData:(NSArray *)sourceData
{
    NSArray *temp = nil;
    
    // 按升序排序
    temp = [sourceData sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        if (obj2.doubleValue < obj1.doubleValue) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    // remove reduplicated datas
    NSMutableArray *result = [NSMutableArray arrayWithArray:temp];
    NSMutableIndexSet *removingIndexes = [NSMutableIndexSet indexSet];
    for (NSInteger i = 0; i < result.count - 1; ++ i) {
        NSNumber *aData = result[i];
        for (NSInteger j = i + 1; j < result.count; ++ j) {
            NSNumber *anotherData = result[j];
            if ([aData isEqualToNumber:anotherData]) {
                [removingIndexes addIndex:j];
            }
        }
    }
    [result removeObjectsAtIndexes:removingIndexes];
    
    return result;
}

@end
