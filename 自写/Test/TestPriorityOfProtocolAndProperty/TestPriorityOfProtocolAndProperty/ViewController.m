//
//  ViewController.m
//  TestPriorityOfProtocolAndProperty
//
//  Created by luozhijun on 15-5-7.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "ViewController.h"
#import "ZJPickerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZJPickerViewRow *row = [[ZJPickerViewRow alloc] init];
    ZJPickerViewDataSource *dataSource = [[ZJPickerViewDataSource alloc] init];
    row.subComponent = dataSource;
    row.titleForRow = @"aaaa";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
