//
//  ViewController.m
//  02-idAnd__bridge_id
//
//  Created by luozhijun on 16/9/14.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Class personClass = [Person class];
    void *addressOfID = &personClass;
    [(__bridge id)addressOfID speak];
}

@end
