//
//  ZJPickerView.m
//  supercx
//
//  Created by luozhijun on 15-5-6.
//  Copyright (c) 2015年 linuxiao. All rights reserved.
//

#import "ZJPickerView.h"

@interface ZJPickerView ()
@property (nonatomic, strong) NSMutableArray *components;
@property (nonatomic, assign) NSInteger componentsCount;
@end

@implementation ZJPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIPickerView *picker = [[UIPickerView alloc] init];
        picker.backgroundColor = [UIColor whiteColor];
        [self.internalPickerContainerView addSubview:picker];
        self.pickerView = picker;
    }
    return self;
}

- (instancetype)initWithDatasource:(id<ZJPickerViewComponent>)dataSource
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.dataSource = dataSource;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.pickerView.frame = self.internalPickerContainerView.bounds;
}

- (void)show:(BOOL)animated
{
    [super show:animated];
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.pickerView reloadAllComponents];
}

- (void)setDataSource:(id<ZJPickerViewComponent>)dataSource
{
    _dataSource = dataSource;
#if DEBUG
    NSAssert([_dataSource conformsToProtocol:@protocol(ZJPickerViewComponent)], @"数据源必须遵循ZJPickerViewComponent协议, %s", __PRETTY_FUNCTION__);
#endif
    [self.pickerView reloadAllComponents];
}

#pragma mark - - UIPicerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    _componentsCount = 0;
    self.components = [NSMutableArray array];
    return [self componentsCountWithComponent:self.dataSource];
}

- (NSInteger)componentsCountWithComponent:(id<ZJPickerViewComponent>)component
{
    if ([self subComponentIsAvailable:component]) {
        [self.components addObject:component];
        _componentsCount ++;
        return [self componentsCountWithComponent:component.rows[0]];
    } else {
        return _componentsCount;
    }
}

- (BOOL)subComponentIsAvailable:(id<ZJPickerViewComponent>)component
{
    if (component.rows.count) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    id<ZJPickerViewComponent> aComponent = self.components[component];
    return [aComponent rows].count;
}

#pragma mark - - UIPicerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    id<ZJPickerViewComponent> aComponent = self.components[component];
    id<ZJPickerViewRow> aRow = aComponent.rows[row];
    return aRow.titleForRow;
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    id<ZJPickerViewComponent> aComponent = self.components[component];
//    id<ZJPickerViewRow> aRow = aComponent.rows[row];
//    if ([aRow respondsToSelector:@selector(attributedTitleForRow)]) {
//        return aRow.attributedTitleForRow;
//    }
//    return nil;
//}
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    id<ZJPickerViewComponent> aComponent = self.components[component];
//    id<ZJPickerViewRow> aRow = aComponent.rows[row];
//    if ([aRow respondsToSelector:@selector(viewForRow)]) {
//        return aRow.viewForRow;
//    }
//    return nil;
//}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if ([self.delegate respondsToSelector:@selector(zj_pickerView:widthForComponent:)]) {
        return [self.delegate zj_pickerView:self widthForComponent:component];
    }
    else {
        return self.internalPickerContainerView.frame.size.width / self.components.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if ([self.delegate respondsToSelector:@selector(zj_pickerView:rowHeightForComponent:)]) {
       return [self.delegate zj_pickerView:self rowHeightForComponent:component];
    }
    else {
        return 35;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    id<ZJPickerViewComponent> aComponent = self.components[component];
    id<ZJPickerViewRow> aRow = aComponent.rows[row];
    
    if ([self.delegate respondsToSelector:@selector(zj_pickerView:didSelctedRow:inComponent:withDataModel:)]) {
        [self.delegate zj_pickerView:self didSelctedRow:row inComponent:component withDataModel:aRow];
    }
    
    ++ component;
    if (component < self.components.count) { // 刷新下一分组
        // 获取下一分组的数据源
        [self.components replaceObjectAtIndex:component withObject:aRow];
        [self.pickerView reloadComponent:component];
    }
}

@end

@implementation ZJPickerViewDataSource
- (NSArray<ZJPickerViewRow> *)rows
{
    return (NSArray<ZJPickerViewRow> *)self.componentRows;
}

- (void)setRows:(NSArray<ZJPickerViewRow> *)rows
{
    self.componentRows = rows;
}
@end

@implementation ZJPickerViewRow
- (void)setSubComponent:(id<ZJPickerViewComponent>)subComponent
{
    self.subComponent = subComponent;
}

- (id<ZJPickerViewComponent>)subComponent
{
    return self.subComponent;
}

- (void)setTitleForRow:(NSString *)titleForRow
{
    self.titleForRow = titleForRow;
}

- (NSString *)titleForRow
{
    return self.titleForRow;
}


@end

