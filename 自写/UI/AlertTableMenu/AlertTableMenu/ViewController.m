//
//  ViewController.m
//  AlertTableMenu
//
//  Created by luozhijun on 15-4-30.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "ViewController.h"
#import "ZJTableMenuAlertView.h"
#import "AlertViewDetailController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlertViewDetailController *alertViewDetailVc = [[AlertViewDetailController alloc] init];
    [self.navigationController pushViewController:alertViewDetailVc animated:YES];
}

@end
