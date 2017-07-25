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
@property (nonatomic, strong) NSArray<__kindof id<ZJPickerViewRowProtocol>> *selectedRowModels;
@end

@implementation ZJPickerView

@dynamic delegate;

#pragma mark - init
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

- (instancetype)initWithDatasource:(id<ZJPickerViewComponentProtocol>)dataSource
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

- (NSArray<__kindof id<ZJPickerViewRowProtocol>> *)selectedRowModels
{
    return [self currentSelectedRowModels];
}

#pragma mark - show
- (void)show:(BOOL)animated
{
    // 不知为何, 在设置数据源和代理, 以及调用reloadAllComponents之前一定要添加到superView上, 否则显示的时候没数据
    [super show:animated];
    // 判断是否设置数据源和代理, 如果没有设置, 则self.components为空, 无法计算出中间行
    BOOL shoudSetupDataSource = [self shouldSetupDataSourceAndDelegate];
    if (shoudSetupDataSource) { // 如果是第一次设置数据源, 则尝试在显示出来的时候选中中间行
        // 选中第一组的中间行
        NSInteger midRow = [[[self.components firstObject] rows] count] / 2;
        [self show:animated selectRowOfFirstComponent:midRow ignoreDataSourceDetection:shoudSetupDataSource];
    } else {
        // 显示出来的时候选中之前停留的行, 令代理可得到通知
        if (self.dataSource.rows.count > 0) {
            [self pickerView:self.pickerView didSelectRow:[self.pickerView selectedRowInComponent:0] inComponent:0];
        }
    }
}

- (void)show:(BOOL)animated selectRowOfFirstComponent:(NSInteger)rowNumber ignoreDataSourceDetection:(BOOL)ignoreDataSourceDetection
{
    [super show:animated];
    
    if ((!self.pickerView.dataSource && !self.pickerView.delegate)
        || ignoreDataSourceDetection)
    {
        [self shouldSetupDataSourceAndDelegate];
        // warning 下面尝试令picker的内容一开始就在某一行显示
        // 这样有可能会造成隐患
        [self selectRowOfFirstComponent:rowNumber];
    }
}

/**
 *  判断是否已经设置了数据源和代理
 *  @note 如果数据源和代理同时为空, 则把self设置成数据源和代理, 返回yes; 否则不做任何操作, 返回NO
 */
- (BOOL)shouldSetupDataSourceAndDelegate
{
    if (!self.pickerView.dataSource && !self.pickerView.delegate) {
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self.pickerView reloadAllComponents];
        return YES;
    } else {
        return NO;
    }
}

- (void)selectRowOfFirstComponent:(NSInteger)rowNumber
{
    // warning 下面尝试令picker的内容一开始就在某一行显示
    // 这样有可能会造成隐患
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSInteger index = 0; index < self.components.count; ++ index) {
            id<ZJPickerViewComponentProtocol> aComponent = self.components[index];
            if (index == 0) {
                [self.pickerView selectRow:rowNumber inComponent:index animated:NO];
            } else {
                [self.pickerView selectRow:aComponent.rows.count / 2 inComponent:index animated:NO];
            }
            
            // 模拟选中第一组某一行的操作, 使得其后的所有分组跟着滑动, 以显示和第一组当前选中的行相关联的内容
            if (index == self.components.count - 1) {
                [self pickerView:self.pickerView didSelectRow:rowNumber inComponent:0];
            }
        }
    });
}

- (void)show:(BOOL)animated selectRowTitleOfFirstComponent:(NSString *)rowTitle
{
    [super show:animated];
    BOOL shouldSetupDataSouce = [self shouldSetupDataSourceAndDelegate];
    
    NSInteger selectRowNumber = 0;
    for (id<ZJPickerViewRowProtocol> aRow in [[self.components firstObject] rows]) {
        if ([[aRow titleForRow] isEqualToString:rowTitle]) {
            break;
        }
        selectRowNumber ++;
    }
    
    if (selectRowNumber == [[self.components firstObject] rows].count) { // 匹配标题失败 以默认的方式显示
        [self show:animated];
    } else {
        [self show:animated selectRowOfFirstComponent:selectRowNumber ignoreDataSourceDetection:shouldSetupDataSouce];
    }
}

#pragma mark - setDataSource
- (void)setDataSource:(id<ZJPickerViewComponentProtocol>)dataSource
{
    _dataSource = dataSource;
#ifdef DEBUG
    NSAssert([_dataSource conformsToProtocol:@protocol(ZJPickerViewComponentProtocol)], @"数据源必须遵循ZJPickerViewComponentProtocol协议, %s", __PRETTY_FUNCTION__);
#endif
    [self.pickerView reloadAllComponents];
}

#pragma mark - -public
+ (id<ZJPickerViewComponentProtocol>)pickerViewDataSourceWithRows:(NSArray<__kindof id<ZJPickerViewRowProtocol>> *)rows
{
    ZJPickerViewComponent *pickerViewDataSource = [[ZJPickerViewComponent alloc] init];
    pickerViewDataSource.rows = (NSArray<ZJPickerViewRowProtocol> *)rows;
    return pickerViewDataSource;
}

+ (id<ZJPickerViewComponentProtocol>)pickerViewDataSourceWithTitles:(NSArray<__kindof NSString *> *)titles
{
    ZJPickerViewComponent *pickerViewDataSource = [[ZJPickerViewComponent alloc] init];
    NSMutableArray *rows = [NSMutableArray array];
    for (NSString *aTitle in titles) {
        ZJPickerViewRow *aRow = [[ZJPickerViewRow alloc] init];
        aRow.titleForRow = aTitle;
        [rows addObject:aRow];
    }
    pickerViewDataSource.rows = (NSArray<ZJPickerViewRowProtocol> *)rows;
    return pickerViewDataSource;
}

//+ (NSArray<__kindof ZJPickerViewComponent *> *)pickerViewDataSourceWithTitleArrays:(NSArray *)titleArrays columnCount:(NSInteger)columnCount
//{
//    NSMutableArray *components = [NSMutableArray array];
//    for (NSArray *aTitleArray in titleArrays) {
//        NSMutableArray *rows = @[].mutableCopy;
//        for (NSString *aTitle in aTitleArray) {
//            ZJPickerViewRow *aRow = [[ZJPickerViewRow alloc] init];
//            aRow.titleForRow = aTitle;
//            [rows addObject:aRow];
//        }
//        ZJPickerViewComponent *aComponent = [[ZJPickerViewComponent alloc] init];
//        aComponent.rows = (NSArray<ZJPickerViewRowProtocol> *)rows;
//    }
//    pickerViewDataSource.rows = (NSArray<ZJPickerViewRowProtocol> *)rows;
//    return pickerViewDataSource;
//}

#pragma mark - - UIPicerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    _componentsCount = 0;
    self.components = [NSMutableArray array];
    return [self componentsCountOf:self.dataSource];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    id<ZJPickerViewComponentProtocol> aComponent = self.components[component];
    return [aComponent rows].count;
}

#pragma mark - - UIPicerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    id<ZJPickerViewComponentProtocol> aComponent = self.components[component];
    id<ZJPickerViewRowProtocol> aRow = aComponent.rows[row];
    return aRow.titleForRow;
}

// TODO: 如何做到兼容下面两个方法, 也就是说不注释这两个方法也能实现只显示标题
//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    id<ZJPickerViewComponentProtocol> aComponent = self.components[component];
//    id<ZJPickerViewRowProtocol> aRow = aComponent.rows[row];
//    if ([aRow respondsToSelector:@selector(attributedTitleForRow)]) {
//        return aRow.attributedTitleForRow;
//    }
//    return nil;
//}
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    id<ZJPickerViewComponentProtocol> aComponent = self.components[component];
//    id<ZJPickerViewRowProtocol> aRow = aComponent.rows[row];
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
    id<ZJPickerViewComponentProtocol> aComponent = self.components[component];
    id<ZJPickerViewRowProtocol> aRow = nil;
    if (aComponent.rows.count > row) {
        aRow = aComponent.rows[row];
    }
    
    ++ component;
    if (component < self.components.count) { // 获取下一分组的数据源
        if (aRow && aRow.subComponent) {
            [self.components replaceObjectAtIndex:component withObject:[aRow subComponent]];
        }
    }
    
    if (component == self.components.count) { // 因为下面刷新接下来所有分组的方法(第167行)是调用自身, 所以为了避免多次通知代理, 加了这个判断, 注意前面++了component, 所以这里不用-1
        // 保存当前选中的所有模型
        self.selectedRowModels = [self currentSelectedRowModels];
        if ([self.delegate respondsToSelector:@selector(zj_pickerView:didSelctedRow:inComponent:withRowModels:)]) {
            [self.delegate zj_pickerView:self didSelctedRow:row inComponent:component withRowModels:(NSArray<ZJPickerViewRowProtocol> *)self.selectedRowModels];
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
- (NSInteger)componentsCountOf:(id<ZJPickerViewComponentProtocol>)component
{
    if (component && [self subComponentAvailable:component]) {
        [self.components addObject:component];
        _componentsCount ++;
        // FIXME: 这里都取的是第0个元素
        // 这样是不严谨的, 比如地址数据, 如果第一行就是北京市, 那么它的下面分组的行数是会比其他(比如江西省)元素提前为0的
        id<ZJPickerViewComponentProtocol> subComponent = [[component.rows firstObject] subComponent];
        return [self componentsCountOf:subComponent];
    } else {
        return _componentsCount;
    }
}

/**
 *  判断某个分组是否有效, 即它的行数是否为0
 */
- (BOOL)subComponentAvailable:(id<ZJPickerViewComponentProtocol>)component
{
    if ([component respondsToSelector:@selector(rows)]) {
        if (component.rows.count) {
            return YES;
        }
    }
    return NO;
}

- (NSArray<__kindof id<ZJPickerViewRowProtocol>> *)currentSelectedRowModels
{
    NSMutableArray *rowModels = @[].mutableCopy;
    
    for (NSInteger i = 0; i < self.components.count; ++i) {
        id<ZJPickerViewComponentProtocol> component = self.components[i];
        NSInteger selectedRowIndexInThisComponent = [self.pickerView selectedRowInComponent:i];
        if (selectedRowIndexInThisComponent < component.rows.count) {
            [rowModels addObject:[component rows][selectedRowIndexInThisComponent]];
        } else {
            // warning 发现某个分组没有行, 直接中断, 避免返回没有关联的数据
            break;
        }
    }
    self.selectedRowModels = rowModels;
    return rowModels;
}

@end



@implementation ZJPickerViewComponent
- (NSArray<ZJPickerViewRowProtocol> *)rows
{
    return (NSArray<ZJPickerViewRowProtocol> *)self.componentRows;
}

- (void)setRows:(NSArray<ZJPickerViewRowProtocol> *)rows
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

- (void)setSubComponent:(id<ZJPickerViewComponentProtocol>)subComponent
{
    self.nextComponent = subComponent;
}

- (id<ZJPickerViewComponentProtocol>)subComponent
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

