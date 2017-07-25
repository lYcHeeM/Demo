//
//  KVOController.m
//  ObjcRuntimeDemo
//
//  Created by luozhijun on 2017/3/16.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

#import "KVOController.h"
#import "NSObject+KVO.h"

@interface KVOController ()
@property (strong, nonatomic) IBOutlet UITextField *textField;
@end

@implementation KVOController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (IBAction)addObserver:(id)sender {
    [self.textField zj_addObserver:self forKeyPath:@"text" changed:^(NSObject *observedObj, NSString *keyPath, id oldValue, id newValue) {
        NSLog(@"---oldValue: %@, newValue: %@", oldValue, newValue);
    }];
}

- (IBAction)removeObserver:(id)sender {
    [self.textField zj_removeObserve:self forKeyPath:@"text"];
}

- (void)textFieldTextDidChange {
    self.textField.text = self.textField.text;
}

- (void)dealloc {
    [self removeObserver:nil];
}

@end
