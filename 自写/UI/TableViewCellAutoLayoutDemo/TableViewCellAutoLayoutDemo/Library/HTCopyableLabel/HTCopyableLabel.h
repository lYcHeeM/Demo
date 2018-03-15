//
//  HTCopyableLabel.h
//  HotelTonight
//
//  Created by Jonathan Sibley on 2/6/13.
//  Copyright (c) 2013 Hotel Tonight. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTCopyableLabel;

@protocol HTCopyableLabelDelegate <NSObject>

@optional
- (NSString *)stringToCopyForCopyableLabel:(HTCopyableLabel *)copyableLabel;
- (CGRect)copyMenuTargetRectInCopyableLabelCoordinates:(HTCopyableLabel *)copyableLabel;

@end

@interface HTCopyableLabel : UILabel

IB_DESIGNABLE
@property (nonatomic, assign) IBInspectable BOOL copyingEnabled; // Defaults to YES

@property (nonatomic, weak) IBOutlet id<HTCopyableLabelDelegate> copyableLabelDelegate;

@property (nonatomic, assign) UIMenuControllerArrowDirection copyMenuArrowDirection; // Defaults to UIMenuControllerArrowDefault

@property (nonatomic, strong) UIColor *highlightedBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *highlightEndBackgroundColor;
@property (nonatomic, assign) IBInspectable CGFloat minimumPressDuration;
// You may want to add longPressGestureRecognizer to a container view
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end
