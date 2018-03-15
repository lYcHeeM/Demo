//
//  EntranceViewController.m
//  ScrollViewContentInsetAndContentOffset
//
//  Created by luozhijun on 15/12/5.
//  Copyright © 2015年 DDFinance. All rights reserved.
//

#import "EntranceViewController.h"
#import "TestScrollViewController.h"
#import "TestTableViewController.h"

@interface EntranceViewController ()
@property (nonatomic, strong) NSMutableArray *entranceTitles;
@property (nonatomic, strong) NSMutableArray *entranceClasses;
@property (nonatomic, weak) UIScrollView *test;
@end

@implementation EntranceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _entranceTitles = @[@"TestScrollView", @"TestTableView"].mutableCopy;
    _entranceClasses = @[[TestScrollViewController class], [TestTableViewController class]].mutableCopy;
    
    UIScrollView *t = [UIScrollView new];
    t.frame = CGRectMake(0, 300, 100, 100);
    t.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:t];
    NSLog(@"%@", NSStringFromUIEdgeInsets(t.contentInset));
    self.test = t;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@", NSStringFromUIEdgeInsets(self.test.contentInset));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.entranceTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = self.entranceTitles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class destVcClass = _entranceClasses[indexPath.row];
    [self.navigationController pushViewController:[destVcClass new] animated:YES];
}

@end
