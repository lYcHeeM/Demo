//
//  MessageForwardingController.m
//  ObjcRuntimeDemo
//
//  Created by luozhijun on 2017/3/16.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

#import "MessageForwardingController.h"
#import "MessageForwarding.h"

@interface MessageForwardingController ()

@end

@implementation MessageForwardingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MessageForwarding *mf = [MessageForwarding new];
    [mf action];
}

@end
