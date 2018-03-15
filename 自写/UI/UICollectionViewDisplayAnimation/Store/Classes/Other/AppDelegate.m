//
//  AppDelegate.m
//  Store
//
//  Created by Mac on 15/8/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *viewCtl = [[ViewController alloc] init];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:viewCtl];
    [self.window makeKeyAndVisible];

    return YES;
}

@end
