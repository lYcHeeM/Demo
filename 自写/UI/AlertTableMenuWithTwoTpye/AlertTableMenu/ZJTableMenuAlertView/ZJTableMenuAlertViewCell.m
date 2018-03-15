//
//  ZJTableMenuAlertViewCell.m
//  AlertTableMenu
//
//  Created by luozhijun on 15-4-30.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "ZJTableMenuAlertViewCell.h"

@implementation ZJTableMenuAlertViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _accessoryViewAndPaddingWidth = ZJTableMenuAlertViewCellAccessoryViewAndPaddingDefaultWidth;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        BGYStaticTextView *titleLabel = [[BGYStaticTextView alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier accessoryViewAndPaddingWidth:(CGFloat)accessoryViewAndPaddingWidth
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (accessoryViewAndPaddingWidth >= 0) {
            _accessoryViewAndPaddingWidth = accessoryViewAndPaddingWidth;
        }
    }
    return self;
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = [titleText copy];
    _titleLabel.text = titleText;
    
    CGFloat titleLabelX = 5.f;
    CGFloat titleLabelY = 8.f;
    CGFloat titleLabelWidth = ZJTableMenuAlertViewCellDefaultWidth - titleLabelX - _accessoryViewAndPaddingWidth;
    CGFloat titleLabelHeight = [self.titleLabel sizeThatFits:CGSizeMake(titleLabelWidth, MAXFLOAT)].height;
    
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelWidth, titleLabelHeight);
    _cellHeight = titleLabelHeight + 2 * titleLabelY;
}

@end
