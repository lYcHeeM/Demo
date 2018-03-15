//
//  ZJPickerView.h
//  supercx
//
//  Created by luozhijun on 15-5-6.
//  Copyright (c) 2015年 linuxiao. All rights reserved.
//  封装系统的UIPickerView, 使得用起来更简洁

#import "ZJPickerContainerView.h"
#import "JSONModel.h"

#define RGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

@class ZJPickerView, ZJPickerViewComponent;
@protocol ZJPickerViewRow, ZJPickerViewComponent;

@protocol ZJPickerViewDelegate <ZJPickerContainerViewDelegate>
@optional
- (CGFloat)zj_pickerView:(ZJPickerView *)pickerView widthForComponent:(NSInteger)component;
- (CGFloat)zj_pickerView:(ZJPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
- (void)zj_pickerView:(ZJPickerView *)pickerView didSelctedRow:(NSInteger)row inComponent:(NSInteger)component withRowModels:(NSArray<ZJPickerViewRow> *)rowModels;
@end

/** 封装系统的UIPickerView, 使得用起来更简洁 */
@interface ZJPickerView : ZJPickerContainerView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) UIPickerView *pickerView;
@property (nonatomic, strong) id<ZJPickerViewComponent> dataSource;
@property (nonatomic, weak) id<ZJPickerViewDelegate> delegate;

- (instancetype)initWithDatasource:(id<ZJPickerViewComponent>)dataSource;
/**
 *  方便最常用的单列菜单创建数据源
 *
 *  @param titles 单列菜单的所有标题
 */
+ (id<ZJPickerViewComponent>)pickerViewDataSourceWithRows:(NSArray *)rows;

/**
 *  方便最常用的单列菜单创建数据源
 *
 *  @param titles 单列菜单的所有标题
 */
+ (id<ZJPickerViewComponent>)pickerViewDataSourceWithTitles:(NSArray *)titles;
@end


@protocol ZJPickerViewRow <NSObject>

@property (nonatomic, copy) NSString<Ignore> *titleForRow;
@property (nonatomic, strong) id<ZJPickerViewComponent, Ignore> subComponent;
@optional
@property (nonatomic, copy) NSAttributedString<Ignore> *attributedTitleForRow;
@property (nonatomic, strong) UIView<Ignore> *viewForRow;

@end


@protocol ZJPickerViewComponent <NSObject>

@property (nonatomic, strong) NSArray<ZJPickerViewRow> *rows;

@end

/**
 *  列模型<br/>
 *  为了避免和ZJPickerViewComponent协议命名冲突导致的死递归, 这里重新命名所有属性, 但是它们的意义都是一样的
 */
@interface ZJPickerViewComponent : NSObject <ZJPickerViewComponent>

@property (nonatomic, strong) NSArray *componentRows;

@end

/** 
 *  行模型<br/>
 *  为了避免和ZJPickerViewRow协议命名冲突导致的死递归, 这里重新命名所有属性, 但是它们的意义都是一样的
 */
@interface ZJPickerViewRow : NSObject <ZJPickerViewRow>

@property (nonatomic, copy) NSString *rowTitle;
@property (nonatomic, strong) id<ZJPickerViewComponent> nextComponent;
@property (nonatomic, copy) NSAttributedString *rowAttributedTitle;
@property (nonatomic, strong) UIView *rowView;

@end