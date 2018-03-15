//
//  ZJActivityIndicatorView.h
//  ImageViewAnimation
//
//  Created by luozhijun on 16/1/25.
//  Copyright © 2016年 DDFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGSize ZJActivityIndicatorViewDefaultSize = {24, 24};
static const CGSize ZJActivityIndicatorViewLargeSize   = {48, 48};

typedef NS_ENUM(NSInteger, ZJActivityIndicatorViewStyle) {
    ZJActivityIndicatorViewStyleCircle, // 24 x 24
    ZJActivityIndicatorViewStyleCircleLarge // 48 x 48
};

@interface ZJActivityIndicatorView : UIImageView
/**
 *  Sizes the view according to the style
 */
- (instancetype)initWithActivityIndicatorStyle:(ZJActivityIndicatorViewStyle)style NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong) UIColor *color;

/** Default is YES */
@property (nonatomic, assign) BOOL hidesWhenStopped;
@property (nonatomic, assign, readonly) BOOL isIndicatorAnimating;

- (void)startIndicatorAnimating;
- (void)stopIndicatorAnimating;

@end
