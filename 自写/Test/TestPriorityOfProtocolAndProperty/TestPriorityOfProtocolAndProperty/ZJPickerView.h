//
//  ZJPickerView.h
//  supercx
//
//  Created by luozhijun on 15-5-6.
//  Copyright (c) 2015年 linuxiao. All rights reserved.
//  封装系统的UIPickerView, 使得用起来更简洁

#import "ZJPickerContainerView.h"

@class ZJPickerView, ZJPickerViewDataModel;
@protocol ZJPickerViewComponent;

@protocol ZJPickerViewRow <NSObject>
@property (nonatomic, copy) NSString *titleForRow;
@property (nonatomic, strong) id<ZJPickerViewComponent> subComponent;
@optional
@property (nonatomic, copy) NSAttributedString *attributedTitleForRow;
@property (nonatomic, strong) UIView *viewForRow;
@end

@protocol ZJPickerViewComponent <NSObject>
@property (nonatomic, strong) NSArray<ZJPickerViewRow> *rows;
@end


@protocol ZJPickerViewDelegate <ZJPickerContainerViewDelegate>
@optional
- (CGFloat)zj_pickerView:(ZJPickerView *)pickerView widthForComponent:(NSInteger)component;
- (CGFloat)zj_pickerView:(ZJPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
- (void)zj_pickerView:(ZJPickerView *)pickerView didSelctedRow:(NSInteger)row inComponent:(NSInteger)component withDataModel:(id<ZJPickerViewRow>)dataModel;
@end

/** 封装系统的UIPickerView, 使得用起来更简洁 */
@interface ZJPickerView : ZJPickerContainerView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) UIPickerView *pickerView;
@property (nonatomic, strong) id<ZJPickerViewComponent> dataSource;
@property (nonatomic, weak) id<ZJPickerViewDelegate> delegate;

- (instancetype)initWithDatasource:(id<ZJPickerViewComponent>)dataSource;
@end


@interface ZJPickerViewDataSource : NSObject <ZJPickerViewComponent>
@property (nonatomic, strong) NSArray *componentRows;
@end

@interface ZJPickerViewRow : NSObject <ZJPickerViewRow>
@property (nonatomic, copy) NSString *titleForRow;
@property (nonatomic, strong) id<ZJPickerViewComponent> subComponent;
@property (nonatomic, copy) NSAttributedString *attributedTitleForRow;
@property (nonatomic, strong) UIView *viewForRow;
@end