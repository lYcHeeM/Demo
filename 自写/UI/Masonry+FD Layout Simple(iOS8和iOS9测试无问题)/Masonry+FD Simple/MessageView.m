//
//  MessageView.m
//  Masonry+FD Simple
//
//  Created by luozhijun on 16/1/2.
//  Copyright © 2016年 DDFinance. All rights reserved.
//

#import "MessageView.h"
#import "MessageModel.h"

@interface MessageView ()
@property (nonatomic, strong) MASConstraint *iconViewSizeConstraint;
@end

@implementation MessageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        self.iconView = [UIImageView new];
        [self addSubview:self.iconView];
        self.iconView.layer.masksToBounds = YES;
        self.iconView.layer.cornerRadius = MessageViewIconViewSize.width / 2.f;
        self.iconView.backgroundColor = [UIColor lightGrayColor];
        
        self.contentLabel = [[UILabel alloc] init];
        [self addSubview:self.contentLabel];
        self.contentLabel.textColor = [UIColor colorWithWhite:0 alpha:0.65];
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.contentLabel.numberOfLines = 0;
        [self.contentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        self.timeStampLabel = [[UILabel alloc] init];
        [self addSubview:self.timeStampLabel];
        self.timeStampLabel.textColor = [UIColor lightGrayColor];
        self.timeStampLabel.font = [UIFont systemFontOfSize:13];
        self.timeStampLabel.numberOfLines = 0;
        [self.timeStampLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        [self setupContraints];
    }
    return self;
}

- (instancetype)initWithStyle:(MessageViewStyle)style
{
    _style = style;
    return [self initWithFrame:CGRectZero];
}

- (void)setupContraints
{
    CGFloat padding_3  = 3;
    CGFloat padding_12 = 12;
    
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self);
        self.iconViewSizeConstraint = make.size.equalTo(MessageViewIconViewSize);
    }];
    
    [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(padding_12);
        make.right.equalTo(self);
        make.top.equalTo(self.iconView);
    }];
    
    [self.timeStampLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel);
        
        // 下面两个约束的目的是
        // 1. 如果contentLabel与timeStampLabel的高度和小于头像, 则使timeStampLabel贴着头像底部
        // 2. 如果高度和大于头像, 则使timeStampLabel挨着contentLabel的底部
        // 为实现此效果, 还要设置约束优先级, 特别是ContentHugging的优先级, 注意在初始化两个label时, 已把ContentHugging设为最高优先级.
        // ContentHugging可以理解为:内容凝聚力-->令label的size和其实际内容的size保持一致的能力, 或者说防止label的size大于其真实内容size的能力.
        make.top.equalTo(self.contentLabel.bottom).offset(padding_3).priorityMedium();
        make.bottom.greaterThanOrEqualTo(self.iconView);
        
        make.bottom.equalTo(self).priorityMedium();
    }];
}

- (void)setMessageModel:(MessageModel *)messageModel
{
    _messageModel = messageModel;
    
    // 哎, 发现如果不这么做会报约束冲突警告, 虽然界面上没有任何问题
    if (_messageModel == nil) {
        self.iconViewSizeConstraint.sizeOffset = CGSizeZero;
        return;
    } else {
        self.iconViewSizeConstraint.sizeOffset = MessageViewIconViewSize;
    }
    
    if (_style == MessageViewStyleSend) {
        self.iconView.image = [UIImage imageNamed:@"ic_hezuo"];
        self.contentLabel.text = messageModel.content;
    } else {
        self.contentLabel.text = messageModel.back;
        self.iconView.image = [UIImage imageNamed:@"ic_chuliao"];
    }
    self.timeStampLabel.text = messageModel.updateTime;
}


@end
