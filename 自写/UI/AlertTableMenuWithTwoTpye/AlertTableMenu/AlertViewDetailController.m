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
    if (self.tableMenuAlertViewType == ZJTableMenuAlertViewContentViewTypeDefault) {
        [self showDefaultAlertView];
    } else {
        [self showSGPopAlertView];
    }
}

- (void)showDefaultAlertView
{
    NSArray *menuTitles = @[@"test test ", @"test test test ", @"c", @"test test test test ", @"test test test test test", @"f", @"test test test test test test", @"test test test test test test test test test test test test", @"test test test test test test test test test test test test test test test test test test test test test test test test"];
    [ZJTableMenuAlertView showTalbeMenuAlertWithTitle:@"默认样式, 可适应每行的内容高度, 并且支持内容复制" menuTitles:menuTitles tableMenuType:ZJTableMenuAlertViewContentViewTypeDefault cancelButtonTitle:@"确定" anotherButtonTitle:@"取消" anotherButtonCallBack:^(CXAlertView *alertView, CXAlertButtonItem *button) {
        NSLog(@"点击了取消按钮");
    } tableRowDidSelectedCallBack:^(NSIndexPath *indexPath) {
        NSLog(@"选择了: %@", indexPath);
    }];
}

- (void)showSGPopAlertView
{
    NSArray *menuTitles = @[@"test test ", @"test test ", @"test test ", @"test test ", @"test test ", @"test test ", @"test test ", @"test test ", @"test test "];
    [ZJTableMenuAlertView showTalbeMenuAlertWithTitle:@"样式2, 不适应内容高度, 不支持内容复制" menuTitles:menuTitles tableMenuType:ZJTableMenuAlertViewContentViewTypeSGPopSelectView cancelButtonTitle:@"确定" anotherButtonTitle:@"取消" anotherButtonCallBack:^(CXAlertView *alertView, CXAlertButtonItem *button) {
        NSLog(@"点击了取消按钮");
    } tableRowDidSelectedCallBack:^(NSIndexPath *indexPath) {
        NSLog(@"选择了: %@", indexPath);
    }];
}

@end
