//
//  ViewController.m
//  StringSimilarityDagree
//
//  Created by luozhijun on 15-7-4.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *stringAField;
@property (weak, nonatomic) IBOutlet UITextField *stringBField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)compareSimilarity:(id)sender {
    
    NSString *stringA = self.stringAField.text;
    NSString *stringB = self.stringBField.text;
    
    NSMutableArray *stringAComponents = [NSMutableArray array];
    for (NSInteger i = 1; i <= stringA.length; ++i) {
        NSString *aComponent = [stringA substringWithRange:NSMakeRange(i - 1, 1)];
        [stringAComponents addObject:aComponent];
    }
    [stringAComponents sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableIndexSet *removingIndexes = [NSMutableIndexSet indexSet];
    for (NSInteger i = 0; i < stringAComponents.count - 1; ++ i) {
        NSString *aComponent = stringAComponents[i];
        for (NSInteger j = i + 1; j < stringAComponents.count; ++ j) {
            NSString *anotherComponent = stringAComponents[j];
            if ([aComponent isEqualToString:anotherComponent]) {
                [removingIndexes addIndex:j];
            }
        }
    }
    [stringAComponents removeObjectsAtIndexes:removingIndexes];
    
    NSMutableArray *stringBComponents = [NSMutableArray array];
    for (NSInteger i = 1; i <= stringB.length; ++i) {
        NSString *aComponent = [stringB substringWithRange:NSMakeRange(i - 1, 1)];
        [stringBComponents addObject:aComponent];
    }
    [stringBComponents sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    [removingIndexes removeAllIndexes];
    for (NSInteger i = 0; i < stringBComponents.count - 1; ++ i) {
        NSString *aComponent = stringBComponents[i];
        for (NSInteger j = i + 1; j < stringBComponents.count; ++ j) {
            NSString *anotherComponent = stringBComponents[j];
            if ([aComponent isEqualToString:anotherComponent]) {
                [removingIndexes addIndex:j];
            }
        }
    }
    [stringBComponents removeObjectsAtIndexes:removingIndexes];
    
    NSInteger equalComponents = 0;
    for (NSInteger i = 0; i < stringAComponents.count; ++ i) {
        NSString *aStringAComponent = stringAComponents[i];
        for (NSInteger j = 0; j < stringBComponents.count; ++ j) {
            NSString *aStringBComponent = stringBComponents[j];
            if ([aStringAComponent isEqualToString:aStringBComponent]) {
                ++ equalComponents;
            }
        }
    }
    
    self.resultLabel.text = [NSString stringWithFormat:@"相似度为: %.2f", (CGFloat)equalComponents / MAX(stringAComponents.count, stringBComponents.count)];
}

@end
