//
//  AlertViewDetailController.m
//  AlertTableMenu
//
//  Created by luozhijun on 15-5-4.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "AlertViewDetailController.h"

@implementation AlertViewDetailController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showDefaultAlertView];
}

- (void)showDefaultAlertView
{
    NSArray *menuTitles = @[@"test test ", @"test test test ", @"c", @"test test test test ", @"test test test test test", @"f", @"test test test test test test", @"test test test test test test test test test test test test", @"test test test test test test test test test test test test test test test test test test test test test test test test"];
    [ZJTableMenuAlertView showTalbeMenuAlertWithTitle:@"可适应每行的内容高度, 并且支持内容复制" menuTitles:menuTitles selectedTitleIndexes:[NSIndexSet indexSetWithIndex:3] cancelButtonTitle:@"确定" anotherButtonTitle:@"取消" anotherButtonCallBack:^(CXAlertView *alertView, CXAlertButtonItem *button) {
        NSLog(@"点击了取消按钮");
    } tableRowDidSelectedCallBack:^(NSIndexPath *indexPath) {
        NSLog(@"选择了: %@", indexPath);
    }];
}

@end
