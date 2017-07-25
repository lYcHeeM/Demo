//
//  MessageView.h
//  Masonry+FD Simple
//
//  Created by luozhijun on 16/1/2.
//  Copyright © 2016年 DDFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageModel;

static const CGSize MessageViewIconViewSize = {50, 50};

typedef NS_ENUM(NSInteger, MessageViewStyle) {
    MessageViewStyleSend,
    MessageViewStyleReply
};

@interface MessageView : UIView

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel     *contentLabel;
@property (nonatomic, strong) UILabel     *timeStampLabel;

@property (nonatomic, strong) MessageModel *messageModel;

- (instancetype)initWithStyle:(MessageViewStyle)style;

@property (nonatomic, assign) MessageViewStyle style;

@end
