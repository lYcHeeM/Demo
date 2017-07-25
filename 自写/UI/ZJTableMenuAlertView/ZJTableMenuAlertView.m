//
//  ZJTableMenuAlertView.m
//  AlertTableMenu
//
//  Created by luozhijun on 15-4-30.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "ZJTableMenuAlertView.h"
#import "ZJTableMenuAlertViewCell.h"

#define RGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

@interface ZJTableMenuAlertView ()
@property (nonatomic, strong) NSMutableArray *cellHeights;
@end

@implementation ZJTableMenuAlertView

- (instancetype)initWithTitle:(NSString *)title menuTitles:(NSArray *)menuTitles tableMenuType:(ZJTableMenuAlertViewContentViewType)tableMenuType cancelButtonTitle:(NSString *)cancelButtonTitle anotherButtonTitle:(NSString *)anotherButtonTitle anotherButtonCallBack:(CXAlertButtonHandler)anotherButtonCallBack tableRowDidSelectedCallBack:(ZJTableMenuAlertViewDidSelectedRowCallBack)tableRowDidSelectedCallBack
{
    if (self = [super init]) {
        _tableMenuAlertViewContentViewType = tableMenuType;
        if (tableMenuType == ZJTableMenuAlertViewContentViewTypeSGPopSelectView) {
            SGPopSelectView *sgTableMenuView = [[SGPopSelectView alloc] initWithVerticalPadding:0 rowHeight:SGPopSelectViewDefaultRowHeight needCornerRadiusAndShadow:NO];
            sgTableMenuView.selections = menuTitles;
            
            self = [[ZJTableMenuAlertView alloc] initWithTitle:title contentView:sgTableMenuView cancelButtonTitle:cancelButtonTitle];
            sgTableMenuView.frame = CGRectMake(0, 0, self.containerWidth, sgTableMenuView._preferedHeight);
//            sgTableMenuView.backgroundColor = [UIColor clearColor];
            sgTableMenuView.selectedHandle = ^(NSInteger selectedIndex) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
                tableRowDidSelectedCallBack(indexPath);
            };
            self.sgTableMenuView = sgTableMenuView;
        } else {
            UITableView *defaultTableMenuView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//            defaultTableMenuView.separatorColor = [UIColor grayColor]; //RGBColor(228, 228, 228, 1.0);
//            defaultTableMenuView.separatorStyle = UITableViewCellSeparatorStyleNone;
//            defaultTableMenuView.backgroundColor = [UIColor whiteColor];
//            defaultTableMenuView.backgroundView = nil;
            
            self = [[ZJTableMenuAlertView alloc] initWithTitle:title contentView:defaultTableMenuView cancelButtonTitle:cancelButtonTitle];
            self.viewBackgroundColor = [UIColor whiteColor];
            self.defaultTableMenuView = defaultTableMenuView;
            self.didSelectedRowCallBack = tableRowDidSelectedCallBack;
            
            // 计算所有cell的高度
            CGFloat totalHeight = 0;
            self.cellHeights = [NSMutableArray array];
            for (NSString *title in menuTitles) {
                ZJTableMenuAlertViewCell *temp = [[ZJTableMenuAlertViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                temp.titleText = title;
                [self.cellHeights addObject:@(temp.cellHeight)];
                totalHeight += temp.cellHeight;
            }
            
            defaultTableMenuView.frame = CGRectMake(0, 0, self.containerWidth, totalHeight);
        }
        
        [self addButtonWithTitle:anotherButtonTitle type:CXAlertViewButtonTypeCancel handler:anotherButtonCallBack];
        _menuTitles = menuTitles;

    }
    
    return self;
}

+ (instancetype)tableMenuAlertWithTitle:(NSString *)title menuTitles:(NSArray *)menuTitles tableMenuType:(ZJTableMenuAlertViewContentViewType)tableMenuType cancelButtonTitle:(NSString *)cancelButtonTitle anotherButtonTitle:(NSString *)anotherButtonTitle anotherButtonCallBack:(CXAlertButtonHandler)anotherButtonCallBack tableRowDidSelectedCallBack:(ZJTableMenuAlertViewDidSelectedRowCallBack)tableRowDidSelectedCallBack
{
    return [[self alloc] initWithTitle:title menuTitles:menuTitles tableMenuType:tableMenuType cancelButtonTitle:cancelButtonTitle anotherButtonTitle:anotherButtonTitle anotherButtonCallBack:anotherButtonCallBack tableRowDidSelectedCallBack:tableRowDidSelectedCallBack];
}

+ (void)showTalbeMenuAlertWithTitle:(NSString *)title menuTitles:(NSArray *)menuTitles tableMenuType:(ZJTableMenuAlertViewContentViewType)tableMenuType cancelButtonTitle:(NSString *)cancelButtonTitle anotherButtonTitle:(NSString *)anotherButtonTitle anotherButtonCallBack:(CXAlertButtonHandler)anotherButtonCallBack tableRowDidSelectedCallBack:(ZJTableMenuAlertViewDidSelectedRowCallBack)tableRowDidSelectedCallBack
{
    ZJTableMenuAlertView *alertView = [[self alloc] initWithTitle:title menuTitles:menuTitles tableMenuType:tableMenuType cancelButtonTitle:cancelButtonTitle anotherButtonTitle:anotherButtonTitle anotherButtonCallBack:anotherButtonCallBack tableRowDidSelectedCallBack:tableRowDidSelectedCallBack];
    [alertView show];
    
}

- (void)show
{
    [super show];

    if (_tableMenuAlertViewContentViewType == ZJTableMenuAlertViewContentViewTypeDefault) {
        self.defaultTableMenuView.dataSource = self;
        self.defaultTableMenuView.delegate = self;
        [self.defaultTableMenuView reloadData];
    }
}

#pragma mark - - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ZJTableMenuAlertViewCell";
    ZJTableMenuAlertViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ZJTableMenuAlertViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_unSelected"]];
    }
    cell.titleText = self.menuTitles[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellHeights[indexPath.row] doubleValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_selected"]];
    
    if (self.didSelectedRowCallBack) {
        self.didSelectedRowCallBack(indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *deselectCell = [tableView cellForRowAtIndexPath:indexPath];
    deselectCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_unSelected"]];
}

@end
