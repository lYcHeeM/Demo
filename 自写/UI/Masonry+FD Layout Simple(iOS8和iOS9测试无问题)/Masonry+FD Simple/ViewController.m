//
//  ViewController.m
//  Masonry+FD Simple
//
//  Created by luozhijun on 16/1/2.
//  Copyright © 2016年 DDFinance. All rights reserved.
//

#import "ViewController.h"
#import "MessageModel.h"
#import "FeedBackCell.h"
#import "MJExtension.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *messageModels;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Masonry+FD Simple";
    
    NSString *fakeDataFilePath = [[NSBundle mainBundle] pathForResource:@"FakeData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:fakeDataFilePath];
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"%@", error);
    } else {
        self.messageModels = [MessageModel objectArrayWithKeyValuesArray:jsonDict[@"fedback"]];
    }
    
    [self.tableView registerClass:[FeedBackCell class] forCellReuseIdentifier:FeedBackCellReuseIdentifier];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedBackCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedBackCellReuseIdentifier];
    
    cell.messageModel = self.messageModels[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = [tableView fd_heightForCellWithIdentifier:FeedBackCellReuseIdentifier cacheByIndexPath:indexPath configuration:^(FeedBackCell *cell) {
        cell.messageModel = self.messageModels[indexPath.row];
    }];
    NSLog(@"---%@----%@---", @(indexPath.row), @(cellHeight));
    return cellHeight;
}

@end
