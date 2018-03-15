//
//  SuggestionEntityCell.m
//  TableViewCellAutoLayoutDemo
//
//  Created by luozhijun on 15-6-12.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "SuggesstionEntityCell.h"
#import "Masonry.h"
#import "SuggesstionReplyCell.h"

NSString *const SuggesstionReplyCellReuseIdentifier = @"SuggesstionReplyCell";

@interface SuggesstionEntityCell () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MASConstraint *photoViewHeightConstraint;
@property (nonatomic, strong) MASConstraint *suggestionReplyViewHeightConstraint;
@property (nonatomic, strong) MASConstraint *starRatingContainerViewHeightConstraint;

@property (nonatomic, strong) NSMutableDictionary *offScreenCells;
@end

@implementation SuggesstionEntityCell

#pragma mark - -setupUI
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        // iconView
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        iconView.layer.cornerRadius = SuggesstionEntityCellIconViewWH / 2.0;
        iconView.clipsToBounds = YES;
        
        // nameLabel
        HTCopyableLabel *nameLabel = [[HTCopyableLabel alloc] init];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont systemFontOfSize:SuggesstionEntityCellNameLabelFontSize];
        
        // timeLabel
        HTCopyableLabel *timeLabel = [[HTCopyableLabel alloc] init];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.font = [UIFont systemFontOfSize:SuggesstionEntityCellTimeLabelFontSize];
        
        // leftVerticalSeparator
        UIImageView *leftVerticalSeparator = [[UIImageView alloc] init];
        [self.contentView addSubview:leftVerticalSeparator];
        self.leftVerticalSeparator = leftVerticalSeparator;
        leftVerticalSeparator.backgroundColor = [UIColor lightGrayColor];
        
        // bgView
        UIImageView *bgView = [[UIImageView alloc] init];
        [self.contentView addSubview:bgView];
        self.bgView = bgView;
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewLongPressed:)];
        recognizer.minimumPressDuration = 0.2;
        [bgView addGestureRecognizer:recognizer];
        bgView.userInteractionEnabled = YES;
        UIEdgeInsets capInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        bgView.image = [[UIImage imageNamed:@"common_card_background"] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
        bgView.highlightedImage = [[UIImage imageNamed:@"common_card_background_highlighted"] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
        
        // suggesstionContentLabel
        HTCopyableLabel *suggesstionContentLabel = [[HTCopyableLabel alloc] init];
        [self.bgView addSubview:suggesstionContentLabel];
        self.suggesstionContentLabel = suggesstionContentLabel;
        suggesstionContentLabel.numberOfLines = 0;
        suggesstionContentLabel.textColor = [UIColor darkGrayColor];
        suggesstionContentLabel.font = [UIFont systemFontOfSize:SuggesstionEntityCellSuggesstionContentLabelFontSize];
        
        // photoView
        PhotoView *photoView = [[PhotoView alloc] init];
        [self.bgView addSubview:photoView];
        self.photoView = photoView;
        
        // suggesstionReplyTableView
        UITableView *suggesstionReplyTableView = [[UITableView alloc] init];
        [self.bgView addSubview:suggesstionReplyTableView];
        self.suggesstionReplyTableView = suggesstionReplyTableView;
        [suggesstionReplyTableView registerClass:[SuggesstionReplyCell class] forCellReuseIdentifier:SuggesstionReplyCellReuseIdentifier];
        suggesstionReplyTableView.backgroundView = nil;
        suggesstionReplyTableView.backgroundColor = [UIColor clearColor];
        suggesstionReplyTableView.scrollEnabled = NO;
        suggesstionReplyTableView.dataSource = self;
        suggesstionReplyTableView.delegate = self;
        suggesstionReplyTableView.estimatedRowHeight = UITableViewAutomaticDimension;
        
        // starRatingContainerView
        UIView *starRatingContainerView = [[UIView alloc] init];
        [self.bgView addSubview:starRatingContainerView];
        self.starRatingContainerView = starRatingContainerView;
        starRatingContainerView.bounds = (CGRect){CGPointZero, SuggesstionEntityCellStarRatingViewSize};
        [self setupStarRatingView];
        
        // replyTableViewTopSeparator
        UIImageView *replyTableViewTopSeparator = [[UIImageView alloc] init];
        [self.suggesstionReplyTableView addSubview:replyTableViewTopSeparator];
        self.replyTableViewTopSeparator = replyTableViewTopSeparator;
        replyTableViewTopSeparator.backgroundColor = [UIColor lightGrayColor];
        
        // starRatingContainerViewTopSeparator
        UIImageView *starRatingContainerViewTopSeparator = [[UIImageView alloc] init];
        [self.starRatingContainerView addSubview:starRatingContainerViewTopSeparator];
        self.starRatingContainerViewTopSeparator = starRatingContainerViewTopSeparator;
        starRatingContainerViewTopSeparator.backgroundColor = replyTableViewTopSeparator.backgroundColor;
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupStarRatingView
{
    UILabel *satisficationLabel = [[UILabel alloc] init];
    satisficationLabel.text = @"满意度：";
    satisficationLabel.font = [UIFont boldSystemFontOfSize:15];
    satisficationLabel.textColor = [UIColor lightGrayColor];
    [self.starRatingContainerView addSubview:satisficationLabel];
    CGSize satisficationLabelNeedSize = [satisficationLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    satisficationLabel.frame = CGRectMake(6, 6, satisficationLabelNeedSize.width, satisficationLabelNeedSize.height);
    
    TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithBackgroundImageName:@"xing_hui" foregroundImageName:@"xing_dianliang" numberOfStars:5];
    [self.starRatingContainerView addSubview:starRatingView];
    self.starRatingView = starRatingView;
    starRatingView.zeroStarHintLabel.hidden = YES;
    [starRatingView setScore:0 withAnimation:NO];
    starRatingView.frame = CGRectMake(CGRectGetMaxX(satisficationLabel.frame) - 2 , 0, SuggesstionEntityCellStarRatingViewSize.width, SuggesstionEntityCellStarRatingViewSize.height);
}

- (void)setupConstraints
{
    CGFloat padding_2 = 2;
    CGFloat padding_3 = 3;
    CGFloat padding_5 = 5;
    CGFloat padding_8 = 8;
    CGFloat padding_10 = 10;
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(self.contentView).mas_offset(padding_10);
        make.size.mas_equalTo(CGSizeMake(SuggesstionEntityCellIconViewWH, SuggesstionEntityCellIconViewWH));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(padding_8);
        make.centerY.mas_equalTo(self.iconView);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.right.mas_equalTo(self.contentView).mas_offset(- padding_8);
    }];
    
    [self.leftVerticalSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.iconView);
        make.top.mas_equalTo(self.iconView.mas_bottom).mas_offset(padding_3);
        make.bottom.mas_equalTo(self.contentView).mas_offset(- padding_3);
        make.width.mas_equalTo(0.5);
    }];
    
    CGFloat bgViewWidth = [UIScreen mainScreen].bounds.size.width - padding_10 - SuggesstionEntityCellIconViewWH - padding_8 - padding_8;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(padding_8);
        make.right.mas_equalTo(self.timeLabel);
        make.bottom.mas_equalTo(self.contentView).mas_offset(- padding_5);
    }];
    
    [self.suggesstionContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(self.bgView).mas_offset(padding_8);
        make.right.mas_equalTo(self.bgView).mas_offset(- padding_8);
    }];
    
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.suggesstionContentLabel);
        make.top.mas_equalTo(self.suggesstionContentLabel.mas_bottom).mas_offset(padding_5);
        self.photoViewHeightConstraint = make.height.mas_equalTo(0);
    }];
    
#pragma mark 此处设置了suggesstionReplyTableView的bounds
    self.suggesstionReplyTableView.bounds = CGRectMake(0, 0, bgViewWidth - 2 * padding_2, 0);
    [self.suggesstionReplyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).mas_offset(padding_2);
        make.right.mas_equalTo(self.bgView).mas_offset(- padding_2);
        make.top.mas_equalTo(self.photoView.mas_bottom).mas_offset(padding_5);
        self.suggestionReplyViewHeightConstraint = make.height.mas_equalTo(0);
    }];
    
    [self.starRatingContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.suggesstionReplyTableView.mas_bottom);
        make.left.and.right.mas_equalTo(self.suggesstionReplyTableView);
        make.height.mas_equalTo(SuggesstionEntityCellStarRatingViewSize.height);
        make.bottom.mas_equalTo(self.bgView).priorityMedium();
    }];
    
    [self.replyTableViewTopSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.suggesstionReplyTableView);
        make.top.mas_equalTo(self.suggesstionReplyTableView).offset(1);
        make.height.mas_equalTo(self.leftVerticalSeparator.mas_width);
    }];
    
    [self.starRatingContainerViewTopSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.starRatingContainerView);
        make.top.mas_equalTo(self.starRatingContainerView).offset(- 0.6);
        make.height.mas_equalTo(self.replyTableViewTopSeparator.mas_height);
    }];
}

#pragma mark - -setters
- (void)setSuggesstionModel:(SuggesstionEntity *)suggesstionModel
{
    _suggesstionModel = suggesstionModel;
    
    // icon
    self.iconView.image = [UIImage imageNamed:suggesstionModel.icon];
    
    // name
    self.nameLabel.text = suggesstionModel.name;
    
    // time
    self.timeLabel.text = suggesstionModel.time;
    
    // suggestionContent
    self.suggesstionContentLabel.text = suggesstionModel.content;
    
    // photos
    CGFloat photoViewLinePadding = 2;
    if (suggesstionModel.images.count == 0) {
        self.photoViewHeightConstraint.offset(0);
    } else if (suggesstionModel.images.count <= 3) {
        self.photoViewHeightConstraint.offset(SuggesstionEntityCellThumbnailImageHeight);
    } else if (suggesstionModel.images.count <= 6) {
        self.photoViewHeightConstraint.offset(SuggesstionEntityCellThumbnailImageHeight * 2 + photoViewLinePadding);
    } else if (suggesstionModel.images.count <= 9) {
        self.photoViewHeightConstraint.offset(SuggesstionEntityCellThumbnailImageHeight * 3 + 2 * photoViewLinePadding);
    }
    NSMutableArray *imageNames = @[].mutableCopy;
    for (SuggesstionImage *aImageModel in suggesstionModel.images) {
        [imageNames addObject:aImageModel.thumbnail];
    }
    self.photoView.imageNames = imageNames;
    
    // replys
    CGFloat suggesstionReplyTableViewNeedHeight = 0;
    if (!suggesstionModel.revertCellsNeedHeight) {
        for (SuggesstionReplyEntity *aSuggestionReplyModel in suggesstionModel.reverts) {
            CGFloat height = [self.suggesstionReplyTableView fd_heightForCellWithIdentifier:SuggesstionReplyCellReuseIdentifier  configuration:^(SuggesstionReplyCell *cell) {
                cell.suggestionReplyModel = aSuggestionReplyModel;
            }];
            suggesstionReplyTableViewNeedHeight += height;
        }
        // 缓存在model中
        suggesstionModel.revertCellsNeedHeight = suggesstionReplyTableViewNeedHeight;
    } else {
        suggesstionReplyTableViewNeedHeight = suggesstionModel.revertCellsNeedHeight;
    }
    if (suggesstionReplyTableViewNeedHeight > SuggesstionEntityCellReplyTableViewMaxHeight) {
        self.suggesstionReplyTableView.scrollEnabled = YES;
        suggesstionReplyTableViewNeedHeight = SuggesstionEntityCellReplyTableViewMaxHeight;
    } else {
        self.suggesstionReplyTableView.scrollEnabled = NO;
    }
    self.suggestionReplyViewHeightConstraint.offset(suggesstionReplyTableViewNeedHeight);
    
    // starRatingView
    NSInteger randomStarCount = arc4random() % 6;
    [self.starRatingView setScore:randomStarCount / 5.0 withAnimation:NO];
    
    [self.suggesstionReplyTableView reloadData];
}

#pragma mark - -getters
- (NSMutableDictionary *)offScreenCells
{
    if (!_offScreenCells) {
        _offScreenCells = [NSMutableDictionary dictionary];
    }
    return _offScreenCells;
}

#pragma mark - -HandleEvents
- (void)bgViewLongPressed:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.bgView.highlighted = YES;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded
          || recognizer.state == UIGestureRecognizerStateCancelled) {
        self.bgView.highlighted = NO;
    }
}

#pragma mark - -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.suggesstionModel.reverts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SuggesstionReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:SuggesstionReplyCellReuseIdentifier forIndexPath:indexPath];
    
    cell.suggestionReplyModel = self.suggesstionModel.reverts[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:SuggesstionReplyCellReuseIdentifier cacheByIndexPath:indexPath configuration:^(SuggesstionReplyCell *cell) {
        cell.suggestionReplyModel = self.suggesstionModel.reverts[indexPath.row];
    }];
}


@end
