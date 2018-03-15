//
//  HTCopyableLabel.m
//  HotelTonight
//
//  Created by Jonathan Sibley on 2/6/13.
//  Copyright (c) 2013 Hotel Tonight. All rights reserved.
//

#import "HTCopyableLabel.h"
#import "UIColor+ZJ.h"

#define RGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

@interface HTCopyableLabel ()

@end

@implementation HTCopyableLabel

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    if (self.minimumPressDuration) {
        _longPressGestureRecognizer.minimumPressDuration = self.minimumPressDuration;
    } else {
        _longPressGestureRecognizer.minimumPressDuration = 0.10;
    }
    [self addGestureRecognizer:_longPressGestureRecognizer];
    
    if (!self.highlightedBackgroundColor) {
        self.highlightedBackgroundColor = RGBColor(167, 202, 255, 1.0);
    }
    if (!self.highlightEndBackgroundColor) {
        self.highlightEndBackgroundColor = self.backgroundColor;
    }
    
    _copyingEnabled = YES;
    _copyMenuArrowDirection = UIMenuControllerArrowDefault;
    self.userInteractionEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recoverBackgroundColor) name:UIMenuControllerDidHideMenuNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public

- (void)setCopyingEnabled:(BOOL)copyingEnabled
{
    if (_copyingEnabled != copyingEnabled)
    {
        [self willChangeValueForKey:@"copyingEnabled"];
        _copyingEnabled = copyingEnabled;
        [self didChangeValueForKey:@"copyingEnabled"];

        self.userInteractionEnabled = copyingEnabled;
        self.longPressGestureRecognizer.enabled = copyingEnabled;
    }
}

#pragma mark - Callbacks

- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer == self.longPressGestureRecognizer)
    {
        [self recoverBackgroundColor];
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
        {
//            NSAssert([self becomeFirstResponder], @"Sorry, UIMenuController will not work with %@ since it cannot become first responder", self);
            [self becomeFirstResponder];    // must be called even when NS_BLOCK_ASSERTIONS=0
            
            [UIView animateWithDuration:0.05 animations:^{
                self.layer.backgroundColor = self.highlightedBackgroundColor.CGColor;
            }];
            UIMenuController *copyMenu = [UIMenuController sharedMenuController];
            if ([self.copyableLabelDelegate respondsToSelector:@selector(copyMenuTargetRectInCopyableLabelCoordinates:)])
            {
                [copyMenu setTargetRect:[self.copyableLabelDelegate copyMenuTargetRectInCopyableLabelCoordinates:self] inView:self];
            }
            else
            {
                [copyMenu setTargetRect:self.bounds inView:self];
            }
            copyMenu.arrowDirection = self.copyMenuArrowDirection;
            [copyMenu setMenuVisible:YES animated:YES];
        }
    }
}

- (void)recoverBackgroundColor
{
    if ([[UIColor colorWithCGColor:self.layer.backgroundColor] isEqualToColor:self.highlightedBackgroundColor])
    {
        [UIView animateWithDuration:0.35 animations:^{
            self.layer.backgroundColor = self.highlightEndBackgroundColor.CGColor;
        }];
    }
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder
{
    return self.copyingEnabled;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL retValue = NO;

    if (action == @selector(copy:))
    {
        if (self.copyingEnabled)
        {
            retValue = YES;
        }
	}
    else
    {
        // Pass the canPerformAction:withSender: message to the superclass
        // and possibly up the responder chain.
        retValue = [super canPerformAction:action withSender:sender];
    }

    return retValue;
}

- (void)copy:(id)sender
{
    if (self.copyingEnabled)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSString *stringToCopy;
        if ([self.copyableLabelDelegate respondsToSelector:@selector(stringToCopyForCopyableLabel:)])
        {
            stringToCopy = [self.copyableLabelDelegate stringToCopyForCopyableLabel:self];
        }
        else
        {
            stringToCopy = self.text;
        }

        [pasteboard setString:stringToCopy];
    }
}

@end
