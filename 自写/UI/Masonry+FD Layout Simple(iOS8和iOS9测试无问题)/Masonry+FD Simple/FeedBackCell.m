//
//  FeedBackCell.m
//  Masonry+FD Simple
//
//  Created by luozhijun on 16/1/2.
//  Copyright © 2016年 DDFinance. All rights reserved.
//

#import "FeedBackCell.h"
#import "MessageView.h"
#import "MessageModel.h"

NSString *FeedBackCellReuseIdentifier = @"FeedBackCellReuseIdentifier";

@interface FeedBackCell ()

@end

@implementation FeedBackCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.originalMessageView = [MessageView new];
        [self.contentView addSubview:self.originalMessageView];
        
        self.repliedMessageBgView = UIImageView.new;
        [self.contentView addSubview:self.repliedMessageBgView];
        self.repliedMessageBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.08];
        self.repliedMessageBgView.clipsToBounds = YES;
        
        self.repliedMessageView = [[MessageView alloc] initWithStyle:MessageViewStyleReply];
        [self.repliedMessageBgView addSubview:self.repliedMessageView];
        
        [self setupContraints];
    }
    return self;
}

- (void)setupContraints
{
    CGFloat padding_3  = 3;
    CGFloat padding_5  = 5;
    CGFloat padding_8  = 8;
    CGFloat padding_10 = 10;
    CGFloat padding_12 = 12;
    CGFloat padding_15 = 15;
    CGFloat padding_20 = 20;
    
    [self.originalMessageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(padding_8);
        make.left.equalTo(self.contentView).offset(padding_20);
        make.right.equalTo(self.contentView).offset(-padding_20);
    }];
    
    [self.repliedMessageBgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.originalMessageView.bottom).offset(padding_5);
        make.left.and.right.equalTo(self.originalMessageView);
        make.bottom.equalTo(self.contentView).offset(-padding_8);
    }];
    
    // repliedMessageView的约束在设置数据时添加
}

- (void)setMessageModel:(MessageModel *)messageModel
{
    _messageModel = messageModel;
    
    self.originalMessageView.messageModel = messageModel;
    
    CGFloat padding_10 = 10;
    CGFloat padding_20 = 20;
    
    if (messageModel.back.length) {
        [self.repliedMessageView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.repliedMessageBgView).offset(padding_20);
            make.top.equalTo(self.repliedMessageBgView).offset(padding_10);
            make.right.equalTo(self.repliedMessageBgView).offset(-padding_20);
            make.bottom.equalTo(self.repliedMessageBgView).offset(- padding_10);
        }];
        self.repliedMessageView.messageModel = messageModel;
    } else {
        self.repliedMessageView.messageModel = nil;
        [self.repliedMessageView remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.repliedMessageBgView);
            make.height.equalTo(0);
        }];
    }
}

@end
