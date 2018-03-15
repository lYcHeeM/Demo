//
//  ViewController.m
//  ZJSecureCodeInputView
//
//  Created by luozhijun on 15/11/17.
//  Copyright © 2015年 DDFinance. All rights reserved.
//

#import "ViewController.h"
#import "ZJSecureCodeInputView.h"

@interface ViewController () <ZJSecureCodeInputViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZJSecureCodeInputView *secureCodeView = [[ZJSecureCodeInputView alloc] init];
    secureCodeView.frame = CGRectMake(10, 50, self.view.frame.size.width - 2 * 10, 55);
    [self.view addSubview:secureCodeView];
    secureCodeView.inputViewDelegate = self;
    
    [secureCodeView becomeFirstResponder];
    
    // test runtime appearance setting
    /**
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        secureCodeView.circleDotColor = [UIColor redColor];
        secureCodeView.circleDotRadius = 10.f;
    });
     */
}


- (void)secureCodeInputView:(ZJSecureCodeInputView *)inputView completedInputSecureCode:(NSString *)code
{
    NSLog(@"%@", code);
}


@end
