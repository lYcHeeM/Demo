//
//  ZJTablePickerView.m
//  DDFinance
//
//  Created by luozhijun on 15/11/11.
//  Copyright © 2015年 DDFinance. All rights reserved.
//

#import "ZJTablePickerView.h"

@interface ZJTablePickerView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ZJTablePickerView

@dynamic delegate;

- (instancetype)initWithTableViewStyle:(UITableViewStyle)tableViewStyle cellClass:(__unsafe_unretained Class)cellClass
{
    self = [super init];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:self.internalPickerContainerView.bounds style:tableViewStyle];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if (tableViewStyle == UITableViewStylePlain) {
            self.tableView.tableFooterView = [[UIView alloc] init];
        }
        if ([cellClass isSubclassOfClass:[UITableViewCell class]]) {
            
            [self.tableView registerClass:cellClass forCellReuseIdentifier:@"ZJTablePickerViewCell"];
        } else {
//            DebugLog(@"warning - `cellClass` is not a subclass of `UITableViewCell`");
            [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ZJTablePickerViewCell"];
        }
        [self.internalPickerContainerView addSubview:self.tableView];
    }
    return self;
}

- (void)setTableViewDatasource:(id<ZJTablePickerViewDatasourceProtocol>)tableViewDatasource
{
    _tableViewDatasource = tableViewDatasource;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableViewDatasource.tableViewSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <ZJTablePickerViewSectionProtocol> aSectionModel = self.tableViewDatasource.tableViewSections[section];
    return aSectionModel.sectionRows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJTablePickerViewCell"];
    
    id <ZJTablePickerViewSectionProtocol> aSectionModel = self.tableViewDatasource.tableViewSections[indexPath.section];
    id <ZJTablePickerViewRowProtocol> aRowModel = aSectionModel.sectionRows[indexPath.row];
    
    cell.textLabel.text = aRowModel.rowTitle;
    if ([aRowModel respondsToSelector:@selector(rowLefIconName)]) {
        cell.imageView.image = [UIImage imageNamed:aRowModel.rowLefIconName];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id <ZJTablePickerViewSectionProtocol> aSectionModel = self.tableViewDatasource.tableViewSections[section];

    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.font = [UIFont boldSystemFontOfSize:14];
    hintLabel.textColor = aSectionModel.sectionTitleColor ? aSectionModel.sectionTitleColor : [UIColor grayColor];
    hintLabel.backgroundColor = aSectionModel.sectionTitleBgColor ? aSectionModel.sectionTitleBgColor : [UIColor lightGrayColor];
    
    hintLabel.text = aSectionModel.sectionTitle;
    
    return hintLabel;
}

#pragma mark - UITableViewDataDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id <ZJTablePickerViewSectionProtocol> aSectionModel = self.tableViewDatasource.tableViewSections[indexPath.section];
    id <ZJTablePickerViewRowProtocol> aRowModel = aSectionModel.sectionRows[indexPath.row];
    if (self.didSelectedRowAtIndexPathBlock) {
        self.didSelectedRowAtIndexPathBlock(aRowModel, indexPath);
    }
    if ([self.delegate respondsToSelector:@selector(zj_tablePickerView:didSelectedRow:atIndexPath:)]) {
        [self.delegate zj_tablePickerView:self didSelectedRow:aRowModel atIndexPath:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

@end

#pragma mark - -抽象模型实现
@implementation ZJTablePickerViewDatasource

- (void)setTableViewSections:(NSArray<ZJTablePickerViewSectionProtocol> *)tableViewSections
{
    self.sectionsOfTableView = tableViewSections;
}
- (NSArray<ZJTablePickerViewSectionProtocol> *)tableViewSections
{
    return self.sectionsOfTableView;
}

@end

@implementation ZJTablePickerViewSection

- (void)setSectionRows:(NSArray<ZJTablePickerViewRowProtocol> *)sectionRows
{
    self.rowsOfSection = sectionRows;
}
- (NSArray<ZJTablePickerViewRowProtocol> *)sectionRows
{
    return self.rowsOfSection;
}

- (void)setSectionTitle:(NSString *)sectionTitle
{
    self.titleOfSection = sectionTitle;
}
- (NSString *)sectionTitle
{
    return self.titleOfSection;
}

- (void)setSectionTitleColor:(UIColor *)sectionTitleColor
{
    self.titleColorOfSection = sectionTitleColor;
}
- (UIColor *)sectionTitleColor
{
    return self.titleColorOfSection;
}

- (void)setSectionTitleBgColor:(UIColor *)sectionTitleBgColor
{
    self.titleBgColorOfSection = sectionTitleBgColor;
}
- (UIColor *)sectionTitleBgColor
{
    return self.titleBgColorOfSection;
}

@end

@implementation ZJTablePickerViewRow

- (void)setRowTitle:(NSString *)rowTitle
{
    self.titleOfRow = rowTitle;
}
- (NSString *)rowTitle
{
    return self.titleOfRow;
}

- (void)setRowLefIconName:(NSString *)rowLefIconName
{
    self.leftIconNameOfRow = rowLefIconName;
}
- (NSString *)rowLefIconName
{
    return self.leftIconNameOfRow;
}

@end