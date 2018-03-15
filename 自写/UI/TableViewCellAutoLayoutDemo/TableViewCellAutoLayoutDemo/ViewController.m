//
//  ViewController.m
//  TableViewCellAutoLayoutDemo
//
//  Created by luozhijun on 15-6-12.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "ViewController.h"
#import "SuggesstionEntityCell.h"
#import "MJExtension.h"

NSString *const SuggesstionEntityCellReuseIdentifier = @"SuggesstionEntityCell";

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *suggesstionModels;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBColor(239, 239, 239, 1.0);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SuggesstionEntityCell class] forCellReuseIdentifier:SuggesstionEntityCellReuseIdentifier];
    
    [self setupData];
}

- (void)setupData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.suggesstionModels = @[].mutableCopy;
        [self.suggesstionModels addObjectsFromArray:[SuggesstionEntity objectArrayWithFilename:@"Suggestions.plist"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    });
}


#pragma mark - -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.suggesstionModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SuggesstionEntityCell *cell = [tableView dequeueReusableCellWithIdentifier:SuggesstionEntityCellReuseIdentifier forIndexPath:indexPath];
    
    cell.suggesstionModel = self.suggesstionModels[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [tableView fd_heightForCellWithIdentifier:SuggesstionEntityCellReuseIdentifier cacheByIndexPath:indexPath configuration:^(SuggesstionEntityCell *cell) {
        cell.suggesstionModel = self.suggesstionModels[indexPath.row];
    }];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
