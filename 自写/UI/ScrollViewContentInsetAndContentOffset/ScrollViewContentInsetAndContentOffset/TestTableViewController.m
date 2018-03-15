//
//  TestTableViewController.m
//  tableViewContentInsetAndContentOffset
//
//  Created by luozhijun on 15/12/5.
//  Copyright © 2015年 DDFinance. All rights reserved.
//

#import "TestTableViewController.h"

@interface TestTableViewController () //<UITableViewDelegate, UITableViewDataSource>
//@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TestTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44, self.view.frame.size.width, 44)];
    [self.tableView addSubview:bottomView];
    bottomView.backgroundColor = [UIColor yellowColor];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, -44 , self.view.frame.size.width, 44)];
    topView.backgroundColor = [UIColor blueColor];
    [self.tableView addSubview:topView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@", NSStringFromCGRect(self.tableView.frame));
    NSLog(@"%@", NSStringFromCGSize(self.tableView.contentSize));
    NSLog(@"%@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
    NSLog(@"%@", NSStringFromCGPoint(self.tableView.contentOffset));
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.tableView.contentSize = CGSizeMake(375, 668);
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    NSLog(@"%@", NSStringFromCGPoint(self.tableView.contentOffset));
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = self.tableView.contentOffset.y;
    NSLog(@"--> %@", @(offsetY));
}
@end
