//
//  ViewController.m
//  ScrollViewContentInsetAndContentOffset
//
//  Created by luozhijun on 15/12/5.
//  Copyright © 2015年 DDFinance. All rights reserved.
//

#import "TestScrollViewController.h"

@interface TestScrollViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation TestScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 100);
    self.scrollView = scrollView;
    scrollView.backgroundColor = [UIColor colorWithRed:180/255.0 green:0.f blue:0.f alpha:0.5];
    scrollView.alwaysBounceVertical = YES;
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.delegate = self;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    [scrollView addSubview:bottomView];
    bottomView.backgroundColor = [UIColor yellowColor];
    bottomView.alpha = 0.5;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, -44 , self.view.frame.size.width, 44)];
    topView.backgroundColor = [UIColor blueColor];
    [scrollView addSubview:topView];
    topView.alpha = 0.5;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, self.view.frame.size.height)];
    leftView.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:leftView];
    leftView.alpha = 0.5;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 44, 0, 44, self.view.frame.size.height)];
    rightView.backgroundColor = [UIColor purpleColor];
    [scrollView addSubview:rightView];
    rightView.alpha = 0.5;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@", NSStringFromCGRect(self.scrollView.frame));
    NSLog(@"%@", NSStringFromCGSize(self.scrollView.contentSize));
    NSLog(@"%@", NSStringFromUIEdgeInsets(self.scrollView.contentInset));
    NSLog(@"%@", NSStringFromCGPoint(self.scrollView.contentOffset));
    
//    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.scrollView.contentSize = CGSizeMake(375, 667);
//    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 44);
//    NSLog(@"%@", NSStringFromCGPoint(self.scrollView.contentOffset));
    
    self.scrollView.contentOffset = CGPointMake(0, - 164);
    
    CGPoint contentOffsetByContentInset = CGPointZero;
    
    CGFloat deltaHeight = self.scrollView.frame.size.height - self.scrollView.contentSize.height;
    CGFloat deltaWidth = self.scrollView.frame.size.width - self.scrollView.contentSize.width;
    if (deltaHeight > self.scrollView.contentInset.top) {
        contentOffsetByContentInset.y = - (self.scrollView.contentInset.top);
    } else if (deltaHeight > 0) {
        contentOffsetByContentInset.y = - (self.scrollView.contentInset.top - deltaHeight);
    } else {
        contentOffsetByContentInset.y = 0;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = self.scrollView.contentOffset.y;
    NSLog(@"--> %@", @(offsetY));
}

@end
