//
//  CXAlertView+ZJTableMenu.h
//  AlertTableMenu
//
//  Created by luozhijun on 15-4-30.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "CXAlertView.h"
#import "SGPopSelectView.h"

typedef NS_ENUM(NSInteger, CXAlertViewTableMenuType) {
    CXAlertViewTableMenuTypeDefault = 0,
    CXAlertViewTableMenuTypeSGPopSelectView
};

#define CXAlertViewDefaultTableMenuMaxHeight ([UIScreen mainScreen].bounds.size.height * 0.7)
static const CGFloat CXAlertViewDefaultTableMenuRowHeight = 35.f;

@interface CXAlertView (ZJTableMenu) <UITableViewDelegate, UITableViewDataSource>

+ (instancetype)tableMenuAlertWithTitle:(NSString *)title menuTitles:(NSArray *)menuTitles tableMenuType:(CXAlertViewTableMenuType)tableMenuType cancelButtonTitle:(NSString *)cancelButtonTitle anotherButtonTitle:(NSString *)anotherButtonTitle anotherButtonCallBack:(CXAlertButtonHandler)anotherButtonCallBack tableRowDidSelectedCallBack:(PopViewSelectedHandle)tableRowDidSelectedCallBack;

+ (void)showTalbeMenuAlertWithTitle:(NSString *)title menuTitles:(NSArray *)menuTitles tableMenuType:(CXAlertViewTableMenuType)tableMenuType cancelButtonTitle:(NSString *)cancelButtonTitle anotherButtonTitle:(NSString *)anotherButtonTitle anotherButtonCallBack:(CXAlertButtonHandler)anotherButtonCallBack tableRowDidSelectedCallBack:(PopViewSelectedHandle)tableRowDidSelectedCallBack;

@property (nonatomic, weak) SGPopSelectView *sgTableMenuView;
@property (nonatomic, weak) UITableView *defaultTableMenuView;
@property (nonatomic, strong, readonly) NSArray *menuTitles;

@end
