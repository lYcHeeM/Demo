//
//  FeedBackCell.h
//  Masonry+FD Simple
//
//  Created by luozhijun on 16/1/2.
//  Copyright © 2016年 DDFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageView, MessageModel;

extern NSString *FeedBackCellReuseIdentifier;

@interface FeedBackCell : UITableViewCell

@property (nonatomic, strong) MessageView *originalMessageView;
@property (nonatomic, strong) MessageView *repliedMessageView;
@property (nonatomic, strong) UIImageView *repliedMessageBgView;

@property (nonatomic, strong) MessageModel *messageModel;

@end
