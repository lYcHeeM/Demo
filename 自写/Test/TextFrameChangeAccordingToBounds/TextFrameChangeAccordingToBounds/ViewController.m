//
//  ViewController.m
//  TextFrameChangeAccordingToBounds
//
//  Created by luozhijun on 15-6-16.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor yellowColor];
    view.bounds = CGRectMake(0, 0, 100, 100);
    [self.view addSubview:view];
    NSLog(@"%@", NSStringFromCGRect(view.frame));
    
    NSLog(@"%ld - %ld - %ld - %ld", NSCalendarUnitWeekOfMonth, NSWeekCalendarUnit, NSWeekOfMonthCalendarUnit, NSWeekOfYearCalendarUnit);
}

@end
