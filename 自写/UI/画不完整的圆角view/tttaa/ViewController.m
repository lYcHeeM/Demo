//
//  ViewController.m
//  tttaa
//
//  Created by luozhijun on 15/8/5.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "ViewController.h"
#import "FrameView.h"
#import "TableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    FrameView *v = [[FrameView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    v.frame = CGRectMake(20, 50, 300, 400);
    [self.view addSubview:v];
    NSLog(@"------");
    NSLog(@"sadfasdfsad");
    
    NSDictionary *dict = @{@"aaa": @"bbb"};
    if (dict[@"aa"]) {
        NSLog(@"=====dsf");
    } else {
        NSLog(@"---sdfadsfdsa");
    }
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:table];
    table.dataSource = self;
    table.delegate = self;
    [table registerClass:[TableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = @"的说法";
    UIImage *image = [UIImage imageNamed:@"logo_qidong"];
//    NSLog(@"\n");
//    NSLog(@"%f", image.size.height);
//    NSLog(@"%f", image.size.height / image.scale);
    cell.imageView.image = image;
    NSLog(@"------");
//    NSLog(@"%f", cell.imageView.image.size.height);
//    NSLog(@"%f\n", cell.imageView.image.size.height / cell.imageView.image.scale);
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_thin"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
