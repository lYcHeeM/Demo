//
//  ZJPickerView.h
//  supercx
//
//  Created by luozhijun on 15-5-6.
//  Copyright (c) 2015年 linuxiao. All rights reserved.
//  封装系统的UIPickerView, 使得用起来更简洁

#import "ZJPickerContainerView.h"
#import "ZJDatePickerView.h"
#import "ZJTablePickerView.h"

@class ZJPickerView, ZJPickerViewComponent;
@protocol ZJPickerViewRowProtocol, ZJPickerViewComponentProtocol;

@protocol ZJPickerViewDelegate <ZJPickerContainerViewDelegate>
@optional
- (CGFloat)zj_pickerView:(ZJPickerView *)pickerView widthForComponent:(NSInteger)component;
- (CGFloat)zj_pickerView:(ZJPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
- (void)zj_pickerView:(ZJPickerView *)pickerView didSelctedRow:(NSInteger)row inComponent:(NSInteger)component withRowModels:(NSArray<ZJPickerViewRowProtocol> *)rowModels;
@end

/** 封装系统的UIPickerView, 使得用起来更简洁 */
@interface ZJPickerView : ZJPickerContainerView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak  ) UIPickerView              *pickerView;
@property (nonatomic, strong) id<ZJPickerViewComponentProtocol> dataSource;
@property (nonatomic, weak  ) id<ZJPickerViewDelegate>  delegate;

/** 当前pickView选中的数据 */
@property (nonatomic, strong, readonly) NSArray<__kindof id<ZJPickerViewRowProtocol>> *selectedRowModels;

- (instancetype)initWithDatasource:(id<ZJPickerViewComponentProtocol>)dataSource;

/**
 *  方便最常用的单列菜单创建数据源
 *
 *  @param rows 单列菜单的数据源
 */
+ (id<ZJPickerViewComponentProtocol>)pickerViewDataSourceWithRows:(NSArray<__kindof id<ZJPickerViewRowProtocol>> *)rows;

/**
 *  方便最常用的单列菜单创建数据源
 *
 *  @param titles 单列菜单的所有标题
 */
+ (id<ZJPickerViewComponentProtocol>)pickerViewDataSourceWithTitles:(NSArray<__kindof NSString *> *)titles;
@end


/** 列模型协议, 目的是间接实现多继承*/
@protocol ZJPickerViewRowProtocol <NSObject>
@property (nonatomic, copy) NSString *titleForRow;
@property (nonatomic, strong) id<ZJPickerViewComponentProtocol> subComponent;
@optional
@property (nonatomic, copy) NSAttributedString *attributedTitleForRow;
@property (nonatomic, strong) UIView *viewForRow;
@end

/** 列模型协议, 目的是间接实现多继承 */
@protocol ZJPickerViewComponentProtocol <NSObject>
@property (nonatomic, strong) NSArray<ZJPickerViewRowProtocol> *rows;
@end

/**
 *  列模型<br/>
 *  为了避免和ZJPickerViewComponent协议命名冲突导致的死递归, 这里重新命名所有属性, 但是它们的意义都是一样的
 */
@interface ZJPickerViewComponent : NSObject <ZJPickerViewComponentProtocol>
@property (nonatomic, strong) NSArray *componentRows;
@end

/** 
 *  行模型<br/>
 *  为了避免和ZJPickerViewRow协议命名冲突导致的死递归, 这里重新命名所有属性, 但是它们的意义都是一样的
 */
@interface ZJPickerViewRow : NSObject <ZJPickerViewRowProtocol>
@property (nonatomic, copy) NSString *rowTitle;
@property (nonatomic, strong) id<ZJPickerViewComponentProtocol> nextComponent;
@property (nonatomic, copy) NSAttributedString *rowAttributedTitle;
@property (nonatomic, strong) UIView *rowView;
@end


