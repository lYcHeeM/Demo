//
//  SGPopSelectView.m
//  SGPopSelectView
//
//  Created by Sagi on 14-10-28.
//  Copyright (c) 2014年 azurelab. All rights reserved.
//

#import "SGPopSelectView.h"

#define SGPOP_DEFAULT_FONT_SIZE     15
#define SGPOP_DEFAULT_ROW_HEIHGT    35

#pragma mark - by Zhijun
// original is 200
#define SGPOP_DEFAULT_MAX_HEIGHT    ([UIScreen mainScreen].bounds.size.height * 0.7)
#pragma mark end

#pragma mark - by Zhijun
// insert
static const CGFloat SGPopSelectViewDefaultWidthRatioOfScreen = 0.7;
NSString *const SGPopSelectViewDefaultHideAnimationKey = @"SGPopSelectViewDefaultHideAnimationKey";
#pragma mark end

@interface SGPopSelectView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
// data
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation SGPopSelectView

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _selectedIndex = NSNotFound;
        
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
    
#pragma mark - by Zhijun
        // comment by zhijun on 150430
        //        self.layer.cornerRadius = 8;
        //        self.layer.masksToBounds = NO;
        
        // insert
        _verticalPadding = SGPopSelectViewDefaultVerticalPadding;
        _rowHeight = SGPopSelectViewDefaultRowHeight;
#pragma mark end
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
    }
    return self;
}

#pragma mark - by Zhijun
// insert on 150430
- (instancetype)initWithNeedCornerRadiusAndShadow:(BOOL)needCornerRadiusAndShadow
{
    self = [self init];
    if (self) {
        _needCornerRadiusAndShadow = needCornerRadiusAndShadow;
    }
    return self;
}

- (instancetype)initWithVerticalPadding:(CGFloat)vertialPadding rowHeight:(CGFloat)rowHeight needCornerRadiusAndShadow:(BOOL)needCornerRadiusAndShadow
{
    if (self = [self initWithNeedCornerRadiusAndShadow:needCornerRadiusAndShadow]) {
        if (vertialPadding >= 0) {
            _verticalPadding = vertialPadding;
        }
        
        if (rowHeight >= 0) {
            _rowHeight = rowHeight;
        }
    }
    return self;
}
#pragma mark end

- (void)layoutSubviews
{
    [super layoutSubviews];
#pragma mark - by Zhijun
    // original is
    // self.tableView.frame = self.bounds;
    self.tableView.frame = CGRectMake(0, _verticalPadding, self.frame.size.width, self.frame.size.height - 2 * _verticalPadding);
    // original is comment codes at bottom
    if (self.needCornerRadiusAndShadow) {
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 4;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    }
#pragma mark end
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOffset = CGSizeMake(0, 0);
//    self.layer.shadowRadius = 4;
//    self.layer.shadowOpacity = 0.2;
//    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (void)setSelectedHandle:(PopViewSelectedHandle)handle
{
    _selectedHandle = handle;
}

- (void)showFromView:(UIView *)view atPoint:(CGPoint)point animated:(BOOL)animated
{
    if (self.visible) {
        [self removeFromSuperview];
    }
    [view addSubview:self];
    [self _setupFrameWithSuperView:view atPoint:point];
    [self _showFromView:view animated:animated];
}

- (void)hide:(BOOL)animated
{
    [self _hideWithAnimated:animated];
}

- (BOOL)visible
{
    if (self.superview) {
        return YES;
    }
    return NO;
}

- (void)setSelections:(NSArray *)selections
{
    _selections = selections;
    _selectedIndex = NSNotFound;
    [_tableView reloadData];
}

#pragma mark - Private Methods

static CAAnimation* _showAnimation()
{
    CAKeyframeAnimation *transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    transform.values = values;
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacity setFromValue:@0.0];
    [opacity setToValue:@1.0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.2;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setAnimations:@[transform, opacity]];
    return group;
}

static CAAnimation* _hideAnimation()
{
    CAKeyframeAnimation *transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    transform.values = values;
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacity setFromValue:@1.0];
    [opacity setToValue:@0.0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.2;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setAnimations:@[transform, opacity]];
    return group;
}

#pragma mark - by Zhijun
// insert
#pragma mark Default Animation

#define transformScale(scale) [NSValue valueWithCATransform3D:[self transform3DScale:scale]]

- (CATransform3D)transform3DScale:(CGFloat)scale
{
    // Add scale on current transform.
    CATransform3D currentTransfrom = CATransform3DScale(self.layer.transform, scale, scale, 1.0f);
    
    return currentTransfrom;
}

- (CAKeyframeAnimation *)animationWithValues:(NSArray*)values times:(NSArray*)times duration:(CGFloat)duration {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    [animation setValues:values];
    [animation setKeyTimes:times];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setRemovedOnCompletion:NO];
    [animation setDuration:duration];
    
    return animation;
}

- (CAAnimation *)defaultDismissAnimation
{
    NSArray *frameValues = @[transformScale(1.0f), transformScale(0.95f), transformScale(0.5f)];
    NSArray *frameTimes = @[@(0.0f), @(0.5f), @(1.0f)];
    
    CAKeyframeAnimation *animation = [self animationWithValues:frameValues times:frameTimes duration:0.2f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    return animation;
}
#pragma mark end

- (void)_showFromView:(UIView *)view animated:(BOOL)animated
{
    if (animated) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self.tableView flashScrollIndicators];
        }];
        [self.layer addAnimation:_showAnimation() forKey:nil];
        [CATransaction commit];
    }
}

- (void)_hideWithAnimated:(BOOL)animated
{
    if (animated) {
//        [CATransaction begin];
//        [CATransaction setCompletionBlock:^{
//            [self.layer removeAnimationForKey:@"transform"];
//            [self.layer removeAnimationForKey:@"opacity"];
//            [self removeFromSuperview];
//        }];
//        [self.layer addAnimation:_hideAnimation() forKey:nil];
//        [CATransaction commit];
#pragma mark - by Zhijun
        // original is comments upside
        [self.layer addAnimation:[self defaultDismissAnimation] forKey:SGPopSelectViewDefaultHideAnimationKey];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([self defaultDismissAnimation].duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
            [self.layer removeAnimationForKey:SGPopSelectViewDefaultHideAnimationKey];
        });
#pragma mark end
    }else {
        [self removeFromSuperview];
    }
}

- (void)_setupFrameWithSuperView:(UIView *)view atPoint:(CGPoint)point
{
    CGFloat totalHeight = _selections.count * SGPOP_DEFAULT_ROW_HEIHGT;
#pragma mark - by Zhijun
    // on150504
    // original is CGFloat height = totalHeight > SGPOP_DEFAULT_MAX_HEIGHT ? SGPOP_DEFAULT_MAX_HEIGHT : totalHeight;
    CGFloat height = totalHeight;
#pragma mark end
    CGFloat width = [self _preferedWidth];
    width = width > view.bounds.size.width * 0.9 ? view.bounds.size.width * 0.9 : width;
    
    CGFloat offsetX = ((point.x / view.bounds.size.width) - floor(point.x / view.bounds.size.width)) * view.bounds.size.width;
    CGFloat offsetY = ((point.y / view.bounds.size.height) - floor(point.y / view.bounds.size.height)) * view.bounds.size.height;
    
    CGFloat left = (offsetX + width) > view.bounds.size.width ? (point.x - offsetX + view.bounds.size.width - width - 10) : point.x;
    CGFloat y = point.y - height / 2;
    if (point.y - height / 2 < 20) {
        y = 20;
    }else if (offsetY + height / 2 > view.bounds.size.height - 10) {
        y = point.y - offsetY + view.bounds.size.height - height - 10;
    }
    
#pragma mark - by Zhijun
    // original is
    // self.frame = CGRectMake(left, y, width, height);
    CGFloat zjWidth = SGPopSelectViewDefaultWidthRatioOfScreen * [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(point.x - zjWidth / 2, y, zjWidth, height);
#pragma mark end
}

- (CGFloat)_preferedWidth
{
    NSPredicate *maxLength = [NSPredicate predicateWithFormat:@"SELF.length == %@.@max.length", _selections];
    NSString *maxString = [_selections filteredArrayUsingPredicate:maxLength][0];
    CGFloat strWidth;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        strWidth = [maxString sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:SGPOP_DEFAULT_FONT_SIZE]}].width;
    }else {
        strWidth = [maxString sizeWithFont:[UIFont systemFontOfSize:SGPOP_DEFAULT_FONT_SIZE]].width;
    }
#pragma mark - by Zhijun
    // original is
    // return strWidth + 15 * 2 + 30;
    return strWidth + 15 * 2 + SGPopSelectViewDefaultRowHeight + 20;
}

// insert on 154030
- (CGFloat)_preferedHeight
{
    return SGPopSelectViewDefaultRowHeight * _selections.count + 2 * _verticalPadding;
}
#pragma mark end

#pragma mark - UITableview DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SelectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:SGPOP_DEFAULT_FONT_SIZE];
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.textLabel.numberOfLines = 0;
    }
    if (_selectedIndex == indexPath.row) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"oval_selected"]];
        imageView.bounds = CGRectMake(0, 0, 20, 20);
        imageView.contentMode = UIViewContentModeScaleToFill;
        cell.accessoryView = imageView;
    }else {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"oval_unselected"]];
        imageView.bounds = CGRectMake(0, 0, 20, 20);
        imageView.contentMode = UIViewContentModeScaleToFill;
        cell.accessoryView = imageView;
    }
    cell.textLabel.text = _selections[indexPath.row];
    return cell;
}

#pragma mark - UITableview Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
    [tableView reloadData];
    
    if (_selectedHandle) {
        _selectedHandle(indexPath.row);
    }
}


@end
