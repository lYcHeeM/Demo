//
//  ViewController.m
//  ScrollViewFloatingView
//
//  Created by luozhijun on 15/12/3.
//  Copyright © 2015年 DDFinance. All rights reserved.
//

#import "ViewController.h"
#import "UIView+ScrollFolating.h"

@interface ViewController ()
@property (nonatomic, weak) UIView *floatingView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = YES;
    
    UIView *floatingView = [UIView new];
    floatingView.frame = CGRectMake(0, 300, self.view.frame.size.width, 44);
    floatingView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:floatingView];
    floatingView.zj_scrollView = self.tableView;
    floatingView.zj_originalSuperView = self.view;
    floatingView.zj_floatingSuperView = self.navigationController.view; // [UIApplication sharedApplication].windows.lastObject;//;
    CGFloat navigationBarHeight = 64.f;
    if (@available(iOS 11.0, *)) {
        navigationBarHeight = 88.f;
    }
    floatingView.zj_floatingFrame = [NSValue valueWithCGRect:CGRectMake(0, navigationBarHeight, floatingView.frame.size.width, floatingView.frame.size.height)];
    
    self.zj_ownerPropertyName = @"floatingView";
    self.floatingView = floatingView;
    self.tableView.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

@end
