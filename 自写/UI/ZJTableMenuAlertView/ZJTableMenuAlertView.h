//
//  ZJTableMenuAlertView.h
//  AlertTableMenu
//
//  Created by luozhijun on 15-4-30.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "CXAlertView.h"
#import "SGPopSelectView.h"

typedef NS_ENUM(NSInteger, ZJTableMenuAlertViewContentViewType) {
    ZJTableMenuAlertViewContentViewTypeDefault = 0,
    ZJTableMenuAlertViewContentViewTypeSGPopSelectView
};

typedef void (^ZJTableMenuAlertViewDidSelectedRowCallBack) (NSIndexPath *indexPath);

@interface ZJTableMenuAlertView : CXAlertView <UITableViewDelegate, UITableViewDataSource>

+ (instancetype)tableMenuAlertWithTitle:(NSString *)title menuTitles:(NSArray *)menuTitles tableMenuType:(ZJTableMenuAlertViewContentViewType)tableMenuType cancelButtonTitle:(NSString *)cancelButtonTitle anotherButtonTitle:(NSString *)anotherButtonTitle anotherButtonCallBack:(CXAlertButtonHandler)anotherButtonCallBack tableRowDidSelectedCallBack:(ZJTableMenuAlertViewDidSelectedRowCallBack)tableRowDidSelectedCallBack;

+ (void)showTalbeMenuAlertWithTitle:(NSString *)title menuTitles:(NSArray *)menuTitles tableMenuType:(ZJTableMenuAlertViewContentViewType)tableMenuType cancelButtonTitle:(NSString *)cancelButtonTitle anotherButtonTitle:(NSString *)anotherButtonTitle anotherButtonCallBack:(CXAlertButtonHandler)anotherButtonCallBack tableRowDidSelectedCallBack:(ZJTableMenuAlertViewDidSelectedRowCallBack)tableRowDidSelectedCallBack;

@property (nonatomic, strong) SGPopSelectView *sgTableMenuView;
@property (nonatomic, strong) UITableView *defaultTableMenuView;
@property (nonatomic, assign) ZJTableMenuAlertViewContentViewType tableMenuAlertViewContentViewType;
@property (nonatomic, strong, readonly) NSArray *menuTitles;
@property (nonatomic, copy) ZJTableMenuAlertViewDidSelectedRowCallBack didSelectedRowCallBack;

@end
