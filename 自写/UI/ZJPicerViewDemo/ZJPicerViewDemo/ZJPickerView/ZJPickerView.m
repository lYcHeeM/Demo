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
    
    if (!self.pickerView.dataSource && !self.pickerView.delegate) {
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        [self.pickerView reloadAllComponents];
        // warning 下面尝试令picker的内容一开始就在中间显示
        // 这样有可能会造成隐患
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (NSInteger index = 0; index < self.components.count; ++ index) {
                id<ZJPickerViewComponent> aComponent = self.components[index];
                [self.pickerView selectRow:aComponent.rows.count / 2 inComponent:index animated:NO];
                if (index == self.components.count - 1) {
                    id<ZJPickerViewComponent> firstComponent = self.components[0];
                    [self pickerView:self.pickerView didSelectRow:firstComponent.rows.count / 2 inComponent:0];
                }
            }
        });
    }
}

- (void)setDataSource:(id<ZJPickerViewComponent>)dataSource
{
    _dataSource = dataSource;
#if DEBUG
    NSAssert([_dataSource conformsToProtocol:@protocol(ZJPickerViewComponent)], @"数据源必须遵循ZJPickerViewComponent协议, %s", __PRETTY_FUNCTION__);
#endif
    [self.pickerView reloadAllComponents];
}

#pragma mark - -public
+ (id<ZJPickerViewComponent>)pickerViewDataSourceWithRows:(NSArray *)rows
{
    ZJPickerViewComponent *pickerViewDataSource = [[ZJPickerViewComponent alloc] init];
    pickerViewDataSource.rows = (NSArray<ZJPickerViewRow> *)rows;
    return pickerViewDataSource;
}

+ (id<ZJPickerViewComponent>)pickerViewDataSourceWithTitles:(NSArray *)titles
{
    ZJPickerViewComponent *pickerViewDataSource = [[ZJPickerViewComponent alloc] init];
    NSMutableArray *rows = [NSMutableArray array];
    for (NSString *aTitle in titles) {
        ZJPickerViewRow *aRow = [[ZJPickerViewRow alloc] init];
        aRow.titleForRow = aTitle;
        [rows addObject:aRow];
    }
    pickerViewDataSource.rows = (NSArray<ZJPickerViewRow> *)rows;
    return pickerViewDataSource;
}

#pragma mark - - UIPicerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    _componentsCount = 0;
    self.components = [NSMutableArray array];
    return [self componentsCountWithComponent:self.dataSource];
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

// TODO: 如何做到兼容下面两个方法, 也就是说不注释这两个方法也能实现只显示标题
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
    
    ++ component;
    if (component < self.components.count) { // 获取下一分组的数据源
        if (aRow) {
            [self.components replaceObjectAtIndex:component withObject:aRow];
        }
    }
    
    if (component == self.components.count) { // 因为下面刷新接下来所有分组的方法(第167行)是调用自身, 所以为了避免多次通知代理, 加了这个判断, 注意前面++了component, 所以这里不用-1
        if ([self.delegate respondsToSelector:@selector(zj_pickerView:didSelctedRow:inComponent:withRowModels:)]) {
            [self.delegate zj_pickerView:self didSelctedRow:row inComponent:component withRowModels:(NSArray<ZJPickerViewRow> *)[self currentSelectedRowModels]];
        }
    }
    
    if (component < self.components.count) { // 刷新接下来的所有分组
        [self.pickerView reloadComponent:component];
        // 手动调用代理方法, 可简便得实现刷新接下来的所有分组
        // pickerView的0代表中间正在显示的那一行
        [self pickerView:pickerView didSelectRow:0 inComponent:component];
    }
}

#pragma mark - private
/**
 *  递归实现计算数据源中的分组个数
 */
- (NSInteger)componentsCountWithComponent:(id<ZJPickerViewComponent>)component
{
    if ([self subComponentIsAvailable:component]) {
        [self.components addObject:component];
        _componentsCount ++;
        // FIXME: 这里都取的是第0个元素
        // 这样是不严谨的, 比如地址数据, 如果第一行就是北京市, 那么它的下面分组的行数是会比其他(比如江西省)元素提前为0的
        return [self componentsCountWithComponent:component.rows[0]];
    } else {
        return _componentsCount;
    }
}

/**
 *  判断某个分组是否有效, 即它的行数是否为0
 */
- (BOOL)subComponentIsAvailable:(id<ZJPickerViewComponent>)component
{
    if ([component respondsToSelector:@selector(rows)]) {
        if (component.rows.count) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)currentSelectedRowModels
{
    NSMutableArray *rowModels = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.components.count; ++i) {
        id<ZJPickerViewComponent> component = self.components[i];
        NSInteger selectedRowIndexInThisComponent = [self.pickerView selectedRowInComponent:i];
        if (selectedRowIndexInThisComponent < component.rows.count) {
            [rowModels addObject:[component rows][selectedRowIndexInThisComponent]];
        } else {
            // warning 发现某个分组没有行, 直接中断, 避免返回没有关联的数据
            break;
        }
    }
    return rowModels;
}

@end



@implementation ZJPickerViewComponent
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

- (void)setTitleForRow:(NSString *)titleForRow
{
    self.rowTitle = titleForRow;
}

- (NSString *)titleForRow
{
    return self.rowTitle;
}

- (void)setSubComponent:(id<ZJPickerViewComponent>)subComponent
{
    self.nextComponent = subComponent;
}

- (id<ZJPickerViewComponent>)subComponent
{
    return self.nextComponent;
}

- (void)setAttributedTitleForRow:(NSAttributedString *)attributedTitleForRow
{
    self.rowAttributedTitle = attributedTitleForRow;
}

- (NSAttributedString *)attributedTitleForRow
{
    return self.rowAttributedTitle;
}

- (void)setViewForRow:(UIView *)viewForRow
{
    self.rowView = viewForRow;
}

- (UIView *)viewForRow
{
    return self.rowView;
}

@end

