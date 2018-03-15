//
//  ViewController.m
//  AlertTableMenu
//
//  Created by luozhijun on 15-4-30.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "ViewController.h"
#import "CXAlertView.h"
#import "SGPopSelectView.h"
#import "ZJTableMenuAlertView.h"
#import "AlertViewDetailController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)test
{
    SGPopSelectView *selectView = [[SGPopSelectView alloc] initWithVerticalPadding:0 rowHeight:SGPopSelectViewDefaultRowHeight needCornerRadiusAndShadow:NO];
    selectView.selections = @[@"a", @"b", @"c", @"d", @"e", @"f"];
    
    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:nil contentView:selectView cancelButtonTitle:@"确定"];
    [alertView addButtonWithTitle:@"取消" type:CXAlertViewButtonTypeCancel handler:nil];
    
    
    selectView.frame = CGRectMake(0, 0, alertView.containerWidth, selectView._preferedHeight);
    selectView.backgroundColor = [UIColor clearColor];
    
    [alertView show];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Defult Style (样式1)";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"SGPopSelectView Style (样式2)";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlertViewDetailController *alertViewDetailVc = [[AlertViewDetailController alloc] init];
    if (indexPath.row == 0) {
        alertViewDetailVc.tableMenuAlertViewType = ZJTableMenuAlertViewContentViewTypeDefault;
    } else {
        alertViewDetailVc.tableMenuAlertViewType = ZJTableMenuAlertViewContentViewTypeSGPopSelectView;
    }
    [self.navigationController pushViewController:alertViewDetailVc animated:YES];
}

@end
