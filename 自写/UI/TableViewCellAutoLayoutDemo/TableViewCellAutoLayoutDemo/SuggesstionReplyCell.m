//
//  SuggestionReplyCell.m
//  TableViewCellAutoLayoutDemo
//
//  Created by luozhijun on 15-6-12.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "SuggesstionReplyCell.h"
#import "Masonry.h"

@implementation SuggesstionReplyCell

#pragma mark - -setupUI
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ZJWordDetectingLabel *replyContentLabel = [[ZJWordDetectingLabel alloc] init];
        [self.contentView addSubview:replyContentLabel];
        self.replyContentLabel = replyContentLabel;
        replyContentLabel.numberOfLines = 0;
        replyContentLabel.textColor = [UIColor grayColor];
        replyContentLabel.font = [UIFont systemFontOfSize:14];
        replyContentLabel.copyEnableInTotal = YES;
        replyContentLabel.copyEnableInWord = YES;
        replyContentLabel.delegate = self;
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    CGFloat padding_10 = 10.f;
    CGFloat padding_5 = 5.f;
    UIEdgeInsets replyContentLabelEageInsets = UIEdgeInsetsMake(padding_5, padding_10, padding_5, padding_10);
    
    [self.replyContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).mas_offset(replyContentLabelEageInsets);
    }];
}

#pragma mark - -setters
- (void)setSuggestionReplyModel:(SuggesstionReplyEntity *)suggestionReplyModel
{
    _suggestionReplyModel = suggestionReplyModel;
    
    self.replyContentLabel.text = [NSString stringWithFormat:@"%@ 回复 %@: %@", suggestionReplyModel.from, suggestionReplyModel.to, suggestionReplyModel.content];
    
    NSMutableDictionary *inactiveLinkAttrs = [NSMutableDictionary dictionaryWithDictionary:self.replyContentLabel.inactiveLinkAttributes];
    [inactiveLinkAttrs setObject:[UIColor purpleColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    self.replyContentLabel.inactiveLinkAttributes = inactiveLinkAttrs;
    self.replyContentLabel.linkAttributes = inactiveLinkAttrs;
    
    NSRange fromNameRange = [self.replyContentLabel.textString rangeOfString:suggestionReplyModel.from];
    NSRange toNameRange = [self.replyContentLabel.textString rangeOfString:suggestionReplyModel.to];

    [self.replyContentLabel addLinkToURL:[NSURL URLWithString:@"http://www.bgy.com.cn/china/index.aspx"] withRange:fromNameRange];
    [self.replyContentLabel addLinkToURL:[NSURL URLWithString:@"http://www.qq.com/"] withRange:toNameRange];
}

#pragma mark - -ZJWordDetectingLabelDelegate
- (BOOL)wordDetectingLabel:(ZJWordDetectingLabel *)wordDetectingLabel shouldShowActionSheet:(UIActionSheet *)actionSheet withTextCheckingResult:(NSTextCheckingResult *)textCheckingResult atPoint:(CGPoint)point wordRects:(NSArray *)wordRects
{
    if (textCheckingResult.range.length == wordDetectingLabel.textString.length) {
        return NO;
    } else {
        return YES;
    }
}

@end
