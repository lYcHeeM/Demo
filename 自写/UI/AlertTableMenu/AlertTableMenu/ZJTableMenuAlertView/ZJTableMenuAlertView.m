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

NSString *const ZJTableMenuAlertViewSelectedImageName = @"icon_selected";
NSString *const ZJTableMenuAlertViewUnSelectedImageName = @"icon_unSelected";

@interface ZJTableMenuAlertView ()
@property (nonatomic, strong) NSMutableArray *cellHeights;
@end

@implementation ZJTableMenuAlertView

- (instancetype)initWithTitle:(NSString *)title menuTitles:(NSArray *)menuTitles selectedTitleIndexes:(NSIndexSet *)selectedTitleIndexes cancelButtonTitle:(NSString *)cancelButtonTitle anotherButtonTitle:(NSString *)anotherButtonTitle anotherButtonCallBack:(CXAlertButtonHandler)anotherButtonCallBack tableRowDidSelectedCallBack:(ZJTableMenuAlertViewDidSelectedRowCallBack)tableRowDidSelectedCallBack
{
    if (self = [super init]) {
        
        UITableView *defaultTableMenuView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        //            defaultTableMenuView.separatorColor = [UIColor grayColor]; //RGBColor(228, 228, 228, 1.0);
        defaultTableMenuView.separatorStyle = UITableViewCellSeparatorStyleNone;
        defaultTableMenuView.backgroundColor = [UIColor clearColor];
        defaultTableMenuView.backgroundView = nil;
        
        self = [[ZJTableMenuAlertView alloc] initWithTitle:title contentView:defaultTableMenuView cancelButtonTitle:cancelButtonTitle];
        self.defaultTableMenuView = defaultTableMenuView;
        self.didSelectedRowCallBack = tableRowDidSelectedCallBack;
        _selectedTitleIndexes = [selectedTitleIndexes copy];
        
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
        
        [self addButtonWithTitle:anotherButtonTitle type:CXAlertViewButtonTypeCancel handler:anotherButtonCallBack];
        _menuTitles = menuTitles;
    }
    
    return self;
}

+ (instancetype)tableMenuAlertWithTitle:(NSString *)title menuTitles:(NSArray *)menuTitles selectedTitleIndexes:(NSIndexSet *)selectedTitleIndexes cancelButtonTitle:(NSString *)cancelButtonTitle anotherButtonTitle:(NSString *)anotherButtonTitle anotherButtonCallBack:(CXAlertButtonHandler)anotherButtonCallBack tableRowDidSelectedCallBack:(ZJTableMenuAlertViewDidSelectedRowCallBack)tableRowDidSelectedCallBack
{
    return [[self alloc] initWithTitle:title menuTitles:menuTitles selectedTitleIndexes:selectedTitleIndexes cancelButtonTitle:cancelButtonTitle anotherButtonTitle:anotherButtonTitle anotherButtonCallBack:anotherButtonCallBack tableRowDidSelectedCallBack:tableRowDidSelectedCallBack];
}

+ (instancetype)showTalbeMenuAlertWithTitle:(NSString *)title menuTitles:(NSArray *)menuTitles selectedTitleIndexes:(NSIndexSet *)selectedTitleIndexes cancelButtonTitle:(NSString *)cancelButtonTitle anotherButtonTitle:(NSString *)anotherButtonTitle anotherButtonCallBack:(CXAlertButtonHandler)anotherButtonCallBack tableRowDidSelectedCallBack:(ZJTableMenuAlertViewDidSelectedRowCallBack)tableRowDidSelectedCallBack
{
    ZJTableMenuAlertView *alertView = [[self alloc] initWithTitle:title menuTitles:menuTitles selectedTitleIndexes:selectedTitleIndexes cancelButtonTitle:cancelButtonTitle anotherButtonTitle:anotherButtonTitle anotherButtonCallBack:anotherButtonCallBack tableRowDidSelectedCallBack:tableRowDidSelectedCallBack];
    [alertView show];
    return alertView;
}

- (void)show
{
    [super show];

    self.defaultTableMenuView.dataSource = self;
    self.defaultTableMenuView.delegate = self;
    [self.defaultTableMenuView reloadData];
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
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ZJTableMenuAlertViewUnSelectedImageName]];
    }
    
    if ([self.selectedTitleIndexes containsIndex:indexPath.row]) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ZJTableMenuAlertViewSelectedImageName]];;
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
    selectedCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ZJTableMenuAlertViewSelectedImageName]];
    UITableViewCell *lasetSelectedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedTitleIndexes.firstIndex inSection:0]];
    lasetSelectedCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ZJTableMenuAlertViewUnSelectedImageName]];
    _selectedTitleIndexes = [NSIndexSet indexSetWithIndex:indexPath.row];
    if (self.didSelectedRowCallBack) {
        self.didSelectedRowCallBack(indexPath);
    }
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *deselectCell = [tableView cellForRowAtIndexPath:indexPath];
//    deselectCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ZJTableMenuAlertViewUnSelectedImageName]];
//}

@end
