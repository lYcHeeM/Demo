//
//  ZJTableMenuAlertViewCell.h
//  AlertTableMenu
//
//  Created by luozhijun on 15-4-30.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "BGYStaticTextView.h"
#import "CXAlertView.h"

@class ZJTableMenuAlertViewCellModel;

static const CGFloat ZJTableMenuAlertViewCellAccessoryViewAndPaddingDefaultWidth = 40.f;
#define ZJTableMenuAlertViewCellDefaultWidth CXAlertViewDefaultWidth

@interface ZJTableMenuAlertViewCell : UITableViewCell

@property (nonatomic, weak              ) BGYStaticTextView *titleLabel;
@property (nonatomic, copy              ) NSString          *titleText;
@property (nonatomic, assign            ) CGFloat           accessoryViewAndPaddingWidth;
@property (nonatomic, assign, readonly  ) CGFloat           cellHeight;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier accessoryViewAndPaddingWidth:(CGFloat)accessoryViewAndPaddingWidth;
@end
