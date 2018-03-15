//
//  PhotoView.m
//  TableViewCellAutoLayoutDemo
//
//  Created by luozhijun on 15-6-13.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "PhotoView.h"
#import "UIView+ImageViewLayout.h"
#import "SuggesstionEntityCell.h"

@interface PhotoView ()
@property (nonatomic, strong) NSMutableArray *imageViews;
@end

@implementation PhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageViews = @[].mutableCopy;
    }
    return self;
}

- (void)setImageNames:(NSArray *)imageNames
{
    _imageNames = imageNames;
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    __weak typeof(self) weakSelf = self;
    for (UIImageView *aImageView in self.imageViews) {
        [aImageView removeFromSuperview];
    }
    [self addSameSizedImageViewsInRect:self.bounds inDirection:ZJLayoutDirectionHorizontal fixedSize:CGSizeMake(0, SuggesstionEntityCellThumbnailImageHeight) aspectRatio:NO fixedLineCount:@3 borderPadding:UIEdgeInsetsZero interitemPadding:@2 linePadding:@2 amount:_imageNames.count loopCompletionBlock:^(NSInteger index, UIImageView *imageView) {
        imageView.clipsToBounds = YES;
        imageView.image = [UIImage imageNamed:weakSelf.imageNames[index]];
        [weakSelf.imageViews addObject:imageView];
    }];
}


@end
