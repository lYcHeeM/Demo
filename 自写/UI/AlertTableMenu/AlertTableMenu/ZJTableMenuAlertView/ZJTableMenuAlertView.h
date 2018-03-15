//
//  ZJTableMenuAlertView.h
//  AlertTableMenu
//
//  Created by luozhijun on 15-4-30.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "CXAlertView.h"

typedef void (^ZJTableMenuAlertViewDidSelectedRowCallBack) (NSIndexPath *indexPath);

@interface ZJTableMenuAlertView : CXAlertView <UITableViewDelegate, UITableViewDataSource>

+ (instancetype)tableMenuAlertWithTitle:(NSString *)title menuTitles:(NSArray *)menuTitles selectedTitleIndexes:(NSIndexSet *)selectedTitleIndexes cancelButtonTitle:(NSString *)cancelButtonTitle anotherButtonTitle:(NSString *)anotherButtonTitle anotherButtonCallBack:(CXAlertButtonHandler)anotherButtonCallBack tableRowDidSelectedCallBack:(ZJTableMenuAlertViewDidSelectedRowCallBack)tableRowDidSelectedCallBack;

+ (instancetype)showTalbeMenuAlertWithTitle:(NSString *)title menuTitles:(NSArray *)menuTitles selectedTitleIndexes:(NSIndexSet *)selectedTitleIndexes cancelButtonTitle:(NSString *)cancelButtonTitle anotherButtonTitle:(NSString *)anotherButtonTitle anotherButtonCallBack:(CXAlertButtonHandler)anotherButtonCallBack tableRowDidSelectedCallBack:(ZJTableMenuAlertViewDidSelectedRowCallBack)tableRowDidSelectedCallBack;

@property (nonatomic, strong) UITableView *defaultTableMenuView;
@property (nonatomic, strong, readonly) NSArray *menuTitles;
@property (nonatomic, strong, readonly) NSIndexSet *selectedTitleIndexes;
@property (nonatomic, copy) ZJTableMenuAlertViewDidSelectedRowCallBack didSelectedRowCallBack;

@end
