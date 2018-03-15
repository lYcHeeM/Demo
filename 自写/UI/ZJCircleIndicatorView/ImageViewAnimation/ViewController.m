//
//  ViewController.m
//  ImageViewAnimation
//
//  Created by luozhijun on 16/1/25.
//  Copyright © 2016年 DDFinance. All rights reserved.
//

#import "ViewController.h"
#import "ZJActivityIndicatorView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    // ZJActivityIndicatorView
    ZJActivityIndicatorView *indicator = [[ZJActivityIndicatorView alloc] initWithActivityIndicatorStyle:ZJActivityIndicatorViewStyleCircle];
    [self.view addSubview:indicator];
    indicator.center = self.view.center;
    indicator.color = [UIColor orangeColor];
    indicator.bounds = CGRectMake(0, 0, 30, 30);
    [indicator startIndicatorAnimating];
    
    // UIActivityIndicatorView
    UIActivityIndicatorView *systemIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    systemIndicator.color = [UIColor whiteColor];
    [self.view addSubview:systemIndicator];
    systemIndicator.center = CGPointMake(self.view.frame.size.width/2.f + 60, self.view.frame.size.height/2.f);
    [systemIndicator startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [indicator stopIndicatorAnimating];
        [systemIndicator stopAnimating];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [indicator startIndicatorAnimating];
            [systemIndicator startAnimating];
        });
    });
}

@end
