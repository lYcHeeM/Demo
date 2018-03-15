//
//  main.m
//  Combination
//
//  Created by luozhijun on 15/7/15.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CombinationCalculater.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSArray *testData = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10/*, @11, @12, @13, @14, @15, @16, @17, @18, @19, @20, @21, @22*/];
        
        CombinationCalculater *calculator = [[CombinationCalculater alloc] init];
        calculator.sourceDataArray = testData;
        calculator.numberOfElements = 3;
        [calculator calculateResult];
        [calculator generateResultString];

        
        NSLog(@"%@", calculator.resultString);
    }
    return 0;
}
