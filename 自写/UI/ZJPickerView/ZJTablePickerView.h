//
//  ZJTablePickerView.h
//  DDFinance
//
//  Created by luozhijun on 15/11/11.
//  Copyright © 2015年 DDFinance. All rights reserved.
//

#import "ZJPickerContainerView.h"

@protocol ZJTablePickerViewDatasourceProtocol;
@protocol ZJTablePickerViewSectionProtocol;
@protocol ZJTablePickerViewRowProtocol;
@protocol ZJTablePickerViewDelegate;

/** 内部为tableView的pickContainerView */
@interface ZJTablePickerView : ZJPickerContainerView

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong)           id<ZJTablePickerViewDatasourceProtocol> tableViewDatasource;
@property (nonatomic, weak)             id delegate;
@property (nonatomic, copy) void (^didSelectedRowAtIndexPathBlock)(id<ZJTablePickerViewRowProtocol> rowModel, NSIndexPath *indexPath);

- (instancetype)initWithTableViewStyle:(UITableViewStyle)tableViewStyle cellClass:(Class)cellClass;
@end

#pragma mark - -抽象模型定义

// 为了防止死递归, 须区分protocol和其对应的模型中的属性命名
// 命名规则如下
// 在protocol中为: 拥有者+对象名;
// 在和protocol对应的模型中为: 对象名 + of + 拥有者.

@protocol ZJTablePickerViewDatasourceProtocol <NSObject>
@property (nonatomic, strong) NSArray<ZJTablePickerViewSectionProtocol> *tableViewSections;
@end

@protocol ZJTablePickerViewSectionProtocol <NSObject>
@property (nonatomic, strong) NSArray<ZJTablePickerViewRowProtocol> *sectionRows;
@optional
@property (nonatomic, copy)   NSString *sectionTitle;
/** 段头view文字颜色 */
@property (nonatomic, strong) UIColor *sectionTitleColor;
/** 段头view背景颜色 */
@property (nonatomic, strong) UIColor *sectionTitleBgColor;
@end

@protocol ZJTablePickerViewRowProtocol <NSObject>
@property (nonatomic, copy) NSString *rowTitle;
@optional
@property (nonatomic, copy) NSString *rowLefIconName;
@end

@interface ZJTablePickerViewDatasource : NSObject <ZJTablePickerViewDatasourceProtocol>
@property (nonatomic, strong) NSArray<ZJTablePickerViewSectionProtocol> *sectionsOfTableView;
@end

@interface ZJTablePickerViewSection : NSObject <ZJTablePickerViewSectionProtocol>
@property (nonatomic, strong) NSArray<ZJTablePickerViewRowProtocol> *rowsOfSection;
@property (nonatomic, copy)   NSString *titleOfSection;
/** 段头view文字颜色 */
@property (nonatomic, strong) UIColor *titleColorOfSection;
/** 段头view背景颜色 */
@property (nonatomic, strong) UIColor *titleBgColorOfSection;
@end

@interface ZJTablePickerViewRow : NSObject <ZJTablePickerViewRowProtocol>
@property (nonatomic, copy) NSString *titleOfRow;
@property (nonatomic, copy) NSString *leftIconNameOfRow;
@end

#pragma mark - -ZJTablePickerViewDelegate

@protocol ZJTablePickerViewDelegate <ZJPickerContainerViewDelegate>
@optional
- (void)zj_tablePickerView:(ZJTablePickerView *)tablePickerView didSelectedRow:(id<ZJTablePickerViewRowProtocol>)rowModel atIndexPath:(NSIndexPath *)indexPath;

@end

