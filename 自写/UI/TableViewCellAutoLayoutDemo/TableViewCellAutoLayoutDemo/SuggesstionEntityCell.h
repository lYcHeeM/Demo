//
//  SuggestionEntityCell.h
//  TableViewCellAutoLayoutDemo
//
//  Created by luozhijun on 15-6-12.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCopyableLabel.h"
#import "TQStarRatingView.h"
#import "SuggesstionEntity.h"
#import "SuggesstionReplyEntity.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PhotoView.h"

#define RGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

static const CGFloat SuggesstionEntityCellIconViewWH                      = 50.f;
static const CGFloat SuggesstionEntityCellNameLabelFontSize               = 18.f;
static const CGFloat SuggesstionEntityCellTimeLabelFontSize               = 13.f;
static const CGFloat SuggesstionEntityCellSuggesstionContentLabelFontSize = 15.f;
static const CGSize  SuggesstionEntityCellStarRatingViewSize              = {120.f, 30.f};
static const CGFloat SuggesstionEntityCellThumbnailImageHeight            = 70.f;
static const CGFloat SuggesstionEntityCellReplyTableViewMaxHeight         = 400.f;

@interface SuggesstionEntityCell : UITableViewCell

@property (nonatomic, weak) UIImageView      *iconView;
@property (nonatomic, weak) HTCopyableLabel  *nameLabel;
@property (nonatomic, weak) HTCopyableLabel  *timeLabel;
@property (nonatomic, weak) UIImageView      *leftVerticalSeparator;
@property (nonatomic, weak) UIImageView      *bgView;
@property (nonatomic, weak) HTCopyableLabel  *suggesstionContentLabel;
@property (nonatomic, weak) PhotoView        *photoView;
@property (nonatomic, weak) UITableView      *suggesstionReplyTableView;
@property (nonatomic, weak) UIImageView      *replyTableViewTopSeparator;
@property (nonatomic, weak) UIImageView      *starRatingContainerViewTopSeparator;
@property (nonatomic, weak) UIView           *starRatingContainerView;
@property (nonatomic, weak) TQStarRatingView *starRatingView;
@property (nonatomic, weak) UIButton         *ratingViewRightButton;

@property (nonatomic, strong) NSIndexPath       *indexPath;
@property (nonatomic, strong) SuggesstionEntity *suggesstionModel;

@end
