//
//  SuggestionReplyCell.h
//  TableViewCellAutoLayoutDemo
//
//  Created by luozhijun on 15-6-12.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJWordDetectingLabel.h"
#import "SuggesstionReplyEntity.h"

@interface SuggesstionReplyCell : UITableViewCell <ZJWordDetectingLabelDelegate>

@property (nonatomic, weak) ZJWordDetectingLabel *replyContentLabel;

@property (nonatomic, strong) SuggesstionReplyEntity *suggestionReplyModel;

@end
