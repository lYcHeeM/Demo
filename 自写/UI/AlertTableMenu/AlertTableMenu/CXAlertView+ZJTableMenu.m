//
//  CXAlertView+ZJTableMenu.m
//  AlertTableMenu
//
//  Created by luozhijun on 15-4-30.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "CXAlertView+ZJTableMenu.h"
#import <objc/runtime.h>

#define RGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
static void * CXAlertViewSgTableMenuViewKey = &CXAlertViewSgTableMenuViewKey;

@implementation CXAlertView (ZJTableMenu)

- (instancetype)initWithTitle:(NSString *)title menuTitles:(NSArray *)menuTitles tableMenuType:(CXAlertViewTableMenuType)tableMenuType cancelButtonTitle:(NSString *)cancelButtonTitle anotherButtonTitle:(NSString *)anotherButtonTitle anotherButtonCallBack:(CXAlertButtonHandler)anotherButtonCallBack tableRowDidSelectedCallBack:(PopViewSelectedHandle)tableRowDidSelectedCallBack
{
    CXAlertView *alertView = nil;

    if (tableMenuType == CXAlertViewTableMenuTypeSGPopSelectView) {
        SGPopSelectView *sgTableMenuView = [[SGPopSelectView alloc] initWithVerticalPadding:0 rowHeight:SGPopSelectViewDefaultRowHeight needCornerRadiusAndShadow:NO];
        sgTableMenuView.selections = menuTitles;
        
        alertView = [[CXAlertView alloc] initWithTitle:title contentView:sgTableMenuView cancelButtonTitle:cancelButtonTitle];
        sgTableMenuView.frame = CGRectMake(0, 0, alertView.containerWidth, sgTableMenuView._preferedHeight);
        sgTableMenuView.backgroundColor = [UIColor clearColor];
        sgTableMenuView.selectedHandle = tableRowDidSelectedCallBack;
        self.sgTableMenuView = sgTableMenuView;
    } else {
        UITableView *defaultTableMenuView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        defaultTableMenuView.delegate = self;
        defaultTableMenuView.dataSource  = self;
        defaultTableMenuView.separatorColor = RGBColor(228, 228, 228, 1.0);
        defaultTableMenuView.rowHeight = CXAlertViewDefaultTableMenuRowHeight;
        
        alertView = [[CXAlertView alloc] initWithTitle:title contentView:defaultTableMenuView cancelButtonTitle:cancelButtonTitle];
        CGFloat height = menuTitles.count * CXAlertViewDefaultTableMenuRowHeight;
        if (height > CXAlertViewDefaultTableMenuMaxHeight) {
            height = CXAlertViewDefaultTableMenuMaxHeight;
        }
        defaultTableMenuView.frame = CGRectMake(0, 0, alertView.containerWidth, height);
    }

    [alertView addButtonWithTitle:anotherButtonTitle type:CXAlertViewButtonTypeCancel handler:anotherButtonCallBack];

    return alertView;
}

+ (instancetype)tableMenuAlertWithTitle:(NSString *)title tableMenuType:(CXAlertViewTableMenuType)tableMenuType menuTitles:(NSArray *)menuTitles cancelButtonTitle:(NSString *)cancelButtonTitle anotherButtonTitle:(NSString *)anotherButtonTitle anotherButtonCallBack:(CXAlertButtonHandler)anotherButtonCallBack tableRowDidSelectedCallBack:(PopViewSelectedHandle)tableRowDidSelectedCallBack
{
    return [[self alloc] initWithTitle:title menuTitles:menuTitles tableMenuType:tableMenuType cancelButtonTitle:cancelButtonTitle anotherButtonTitle:anotherButtonTitle anotherButtonCallBack:anotherButtonCallBack tableRowDidSelectedCallBack:tableRowDidSelectedCallBack];
}

+ (void)showTalbeMenuAlertWithTitle:(NSString *)title menuTitles:(NSArray *)menuTitles tableMenuType:(CXAlertViewTableMenuType)tableMenuType cancelButtonTitle:(NSString *)cancelButtonTitle anotherButtonTitle:(NSString *)anotherButtonTitle anotherButtonCallBack:(CXAlertButtonHandler)anotherButtonCallBack tableRowDidSelectedCallBack:(PopViewSelectedHandle)tableRowDidSelectedCallBack
{
    CXAlertView *alertView = [[self alloc] initWithTitle:title menuTitles:menuTitles tableMenuType:tableMenuType cancelButtonTitle:cancelButtonTitle anotherButtonTitle:anotherButtonTitle anotherButtonCallBack:anotherButtonCallBack tableRowDidSelectedCallBack:tableRowDidSelectedCallBack];
    [alertView show];
}

- (void)setSgTableMenuView:(SGPopSelectView *)sgTableMenuView
{
    objc_setAssociatedObject(self, CXAlertViewSgTableMenuViewKey, sgTableMenuView, OBJC_ASSOCIATION_ASSIGN);
}

- (SGPopSelectView *)sgTableMenuView
{
    return objc_getAssociatedObject(self, CXAlertViewSgTableMenuViewKey);
}



#pragma mark - - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}
@end
