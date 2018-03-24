//
//  ViewController.m
//  MyHotFix
//
//  Created by luozhijun on 2018/3/24.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#import "ViewController.h"
#import "ZJHotFix.h"

@interface ViewController ()

@end

@implementation ViewController

+ (void)initialize {
    NSString *fixedScriptPath = [[NSBundle mainBundle] pathForResource:@"fixedScript" ofType:nil];
    if (!fixedScriptPath) return;
    NSString *script = [NSString stringWithContentsOfFile:fixedScriptPath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"---%@", script);
    [ZJHotFix replaceMethodWithScript:script];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self crashMethod:@[]];
    [self crashMethod:@[@"first", @"second"]];
}

- (void)crashMethod:(NSArray *)array {
    NSLog(@"%@", array[1]);
}


@end
