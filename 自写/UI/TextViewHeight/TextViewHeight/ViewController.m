//
//  ViewController.m
//  TextViewHeight
//
//  Created by luozhijun on 15-1-18.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITextView *textView = [[UITextView alloc] init];
    textView.text = @"ahahahahahahahahadfodkkllj的分数水电费, ahahahahahahahahadfodkkllj的分数水电费, ahahahahahahahahadfodkkllj的分数水电费";
    textView.font = [UIFont systemFontOfSize:18];
    textView.delegate = self;
    textView.backgroundColor = [UIColor yellowColor];
    textView.scrollEnabled = NO;
    
    CGFloat textViewX = 20;
    CGFloat textViewY = 20 + 64;
    CGFloat textViewW = self.view.frame.size.width - 2 * textViewX;
    CGFloat textViewH = [textView sizeThatFits:CGSizeMake(textViewW, MAXFLOAT)].height;
    textView.frame = CGRectMake(textViewX, textViewY, textViewW, textViewH);
    
    [self.view addSubview:textView];
}


- (void)textViewDidChange:(UITextView *)textView
{
//    CGFloat textViewW = textView.frame.size.width;
//    CGFloat textViewH = [textView sizeThatFits:CGSizeMake(textViewW, MAXFLOAT)].height;
//    CGRect frame = textView.frame;
//    frame.size.height = textViewH;
//    textView.frame = frame;
    [textView sizeToFit];
    NSLog(@"%@\n%@", textView.text, @(textView.frame.size.height));
}

@end
