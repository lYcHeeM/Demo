//
// ZJProgressHUD.m
// Version 0.9.1
// Created by Matej Bukovinski on 2.4.09.
//

#import "ZJProgressHUD.h"
#import <tgmath.h>

#pragma mark - by Zhijun
// on 151030 for notification
static bool zj_isiOS8OrLater() {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.f) {
        return true;
    } else {
        return false;
    }
}

const CGFloat kSmallScreenWidth          = 320.0f;
const CGFloat kSmallScreenHeight         = 480.0f;
const CGFloat k_iPhone5_ScreenHeight     = 568.0f;
const CGFloat k_iPhone6_ScreenWidth      = 375.f;
const CGFloat k_iPhone6_ScreenHeight     = 667.0f;
const CGFloat k_iPhone6Plus_ScreenWidth  = 414.0f;
const CGFloat k_iPhone6Plus_ScreenHeight = 736.0f;
const CGFloat kNavigationBarHeight       = 44.0f;
const CGFloat kiPhoneTopBarHeight        = 64.0f;
const CGFloat kTabBarHeight              = 49.0f;

NSString *const ZJHUDDidAddToSuperViewNotification = @"ZJHUDDidAddToSuperView";
NSString *const ZJHUDWillShowNotification          = @"ZJHUDWillShow";
NSString *const ZJHUDDidHideNotification           = @"ZJHUDDidHide";
NSString *const ZJHUDNotificationUserInfoKey       = @"ZJHUDNotificationUserInfoKey";
#pragma mark end

#if __has_feature(objc_arc)
	#define ZJ_AUTORELEASE(exp) exp
	#define ZJ_RELEASE(exp) exp
	#define ZJ_RETAIN(exp) exp
#else
	#define ZJ_AUTORELEASE(exp) [exp autorelease]
	#define ZJ_RELEASE(exp) [exp release]
	#define ZJ_RETAIN(exp) [exp retain]
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
    #define ZJLabelAlignmentCenter NSTextAlignmentCenter
#else
    #define ZJLabelAlignmentCenter UITextAlignmentCenter
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
	#define ZJ_TEXTSIZE(text, font) [text length] > 0 ? [text \
		sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
	#define ZJ_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
	#define ZJ_MULTILINE_TEXTSIZE(text, font, maxSize, _mode) [text length] > 0 ? [text \
		boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
		attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
	#define ZJ_MULTILINE_TEXTSIZE(text, font, maxSize, _mode) [text length] > 0 ? [text \
		sizeWithFont:font constrainedToSize:maxSize lineBreakMode:_mode] : CGSizeZero;
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
	#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_0
	#define kCFCoreFoundationVersionNumber_iOS_8_0 1129.15
#endif

#pragma mark - By Zhijun kPadding
// on 20151203
// original is 4.f
static const CGFloat kPadding = 6.f;
#pragma mark end
static const CGFloat kLabelFontSize = 16.f;
static const CGFloat kDetailsLabelFontSize = 12.f;


@interface ZJProgressHUD () {
	BOOL useAnimation;
	SEL methodForExecution;
	id targetForExecution;
	id objectForExecution;
	UILabel *label;
	UILabel *detailsLabel;
	BOOL isFinished;
	CGAffineTransform rotationTransform;
}

@property (atomic, ZJ_STRONG) UIView  *indicator;
@property (atomic, ZJ_STRONG) NSTimer *graceTimer;
@property (atomic, ZJ_STRONG) NSTimer *minShowTimer;
@property (atomic, ZJ_STRONG) NSDate  *showStarted;

@end

@implementation ZJProgressHUD

#pragma mark - Class methods

#pragma mark - By Zhijun Just added to superView
// on
// original is nothing
+ (ZJ_INSTANCETYPE)HUDAddedTo:(UIView *)view {
    ZJProgressHUD *hud = [[self alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
#pragma mark - by Zhijun Notification
    // on 150331
    // original is nothing
    [[NSNotificationCenter defaultCenter] postNotificationName:ZJHUDDidAddToSuperViewNotification object:nil userInfo:@{ZJHUDNotificationUserInfoKey : hud}];
#pragma mark end
    return ZJ_AUTORELEASE(hud);
}
#pragma mark end

+ (ZJ_INSTANCETYPE)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
#pragma mark - by Zhijun
    // on 20160810
    // original is
    /**
        ZJProgressHUD *hud = [[self alloc] initWithView:view];
        hud.removeFromSuperViewOnHide = YES;
        [view addSubview:hud];
        [hud show:animated];
     */
    ZJProgressHUD *hud = [self HUDAddedTo:view];
    [hud show:animated];
#pragma mark end
	return ZJ_AUTORELEASE(hud);
}

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated {
	ZJProgressHUD *hud = [self HUDForView:view];
	if (hud != nil) {
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:animated];
		return YES;
	}
	return NO;
}

+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated {
	NSArray *huds = [ZJProgressHUD allHUDsForView:view];
	for (ZJProgressHUD *hud in huds) {
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:animated];
	}
	return [huds count];
}

+ (ZJ_INSTANCETYPE)HUDForView:(UIView *)view {
	NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
	for (UIView *subview in subviewsEnum) {
		if ([subview isKindOfClass:self]) {
			return (ZJProgressHUD *)subview;
		}
	}
	return nil;
}

+ (NSArray *)allHUDsForView:(UIView *)view {
	NSMutableArray *huds = [NSMutableArray array];
	NSArray *subviews = view.subviews;
	for (UIView *aView in subviews) {
		if ([aView isKindOfClass:self]) {
			[huds addObject:aView];
		}
	}
	return [NSArray arrayWithArray:huds];
}

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// Set default values for properties
		self.animationType = ZJProgressHUDAnimationFade;
		self.mode = ZJProgressHUDModeIndeterminate;
		self.labelText = nil;
		self.detailsLabelText = nil;
		self.opacity = 0.7f;
		self.color = nil;
		self.labelFont = [UIFont boldSystemFontOfSize:kLabelFontSize];
		self.labelColor = [UIColor whiteColor];
		self.detailsLabelFont = [UIFont boldSystemFontOfSize:kDetailsLabelFontSize];
		self.detailsLabelColor = [UIColor whiteColor];
		self.activityIndicatorColor = [UIColor whiteColor];
		self.dimBackground = NO;
#pragma mark - By Zhijun fullScreenToCoverNavigationBar
        // on 20151110
        // original is nothing
        self.fullScreenToCoverNavigationBar = YES;
#pragma mark end
		self.margin = 20.0f;
		self.cornerRadius = 10.0f;
		self.graceTime = 0.0f;
		self.minShowTime = 0.0f;
		self.removeFromSuperViewOnHide = NO;
		self.minSize = CGSizeZero;
		self.square = NO;
		self.contentMode = UIViewContentModeCenter;
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
								| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

		// Transparent background
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		// Make it invisible for now
		self.alpha = 0.0f;
		
		_taskInProgress = NO;
		rotationTransform = CGAffineTransformIdentity;
		
#pragma mark - By Zhijun BlurBackground
        // on 160321
        // original is nothing
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        _bluredHUDBackground = [[UIVisualEffectView alloc] init];
        [self addSubview:self.bluredHUDBackground];
        _bluredHUDBackground.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _bluredHUDBackground.layer.masksToBounds = YES;
#endif
#pragma mark end
        
		[self setupLabels];
		[self updateIndicators];
		[self registerForKVO];
		[self registerForNotifications];
	}
	return self;
}

#pragma mark - By Zhijun Color Setters
// on 160321
// original is nothing
- (void)setColor:(UIColor *)__color
{
    _color = __color;
}

- (void)setLabelColor:(UIColor *)__labelColor
{
    _labelColor = __labelColor;
    self.activityIndicatorColor = _labelColor;
}

- (void)setHudBackgroundColor:(UIColor *)hudBackgroundColor
{
    self.color = hudBackgroundColor;
}
- (UIColor *)hudBackgroundColor
{
    return self.color;
}
#pragma mark end

#pragma mark - By Zhijun wipe out shadow when bluredBackground
// on 20160810
// original is nothing
- (void)setBluredBackground:(BOOL)bluredBackground
{
    _bluredBackground = bluredBackground;
    if (_bluredBackground) {
        self.layer.shadowColor = nil;
        self.layer.shadowOpacity = 0;
        self.layer.shadowOffset = CGSizeZero;
    }
}
#pragma mark end

- (void)setFullScreenToCoverNavigationBar:(BOOL)fullScreenToCoverNavigationBar
{
    _fullScreenToCoverNavigationBar = fullScreenToCoverNavigationBar;
    if (!_fullScreenToCoverNavigationBar) {
        _yOffset -= kiPhoneTopBarHeight/2.f;
    }
}

- (id)initWithView:(UIView *)view {
	NSAssert(view, @"View must not be nil.");
	return [self initWithFrame:view.bounds];
}

- (id)initWithWindow:(UIWindow *)window {
	return [self initWithView:window];
}

- (void)dealloc {
	[self unregisterFromNotifications];
	[self unregisterFromKVO];
}

#pragma mark - Show & hide

- (void)show:(BOOL)animated {
    
#pragma mark - by Zhijun Notification
    // on 160810
    // original is nothing
    [[NSNotificationCenter defaultCenter] postNotificationName:ZJHUDWillShowNotification object:nil userInfo:@{ZJHUDNotificationUserInfoKey : self}];
#pragma end
    
	useAnimation = animated;
	// If the grace time is set postpone the HUD display
	if (self.graceTime > 0.0) {
		self.graceTimer = [NSTimer scheduledTimerWithTimeInterval:self.graceTime target:self 
						   selector:@selector(handleGraceTimer:) userInfo:nil repeats:NO];
	} 
	// ... otherwise show the HUD imediately 
	else {
		[self showUsingAnimation:useAnimation];
	}
}

- (void)hide:(BOOL)animated {
	useAnimation = animated;
	// If the minShow time is set, calculate how long the hud was shown,
	// and pospone the hiding operation if necessary
	if (self.minShowTime > 0.0 && _showStarted) {
		NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:_showStarted];
		if (interv < self.minShowTime) {
			self.minShowTimer = [NSTimer scheduledTimerWithTimeInterval:(self.minShowTime - interv) target:self 
								selector:@selector(handleMinShowTimer:) userInfo:nil repeats:NO];
			return;
		} 
	}
	// ... otherwise hide the HUD immediately
	[self hideUsingAnimation:useAnimation];
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay {
	[self performSelector:@selector(hideDelayed:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
}

- (void)hideDelayed:(NSNumber *)animated {
	[self hide:[animated boolValue]];
}

#pragma mark - Timer callbacks

- (void)handleGraceTimer:(NSTimer *)theTimer {
	// Show the HUD only if the task is still running
	if (_taskInProgress) {
		[self showUsingAnimation:useAnimation];
	}
}

- (void)handleMinShowTimer:(NSTimer *)theTimer {
	[self hideUsingAnimation:useAnimation];
}

#pragma mark - View Hierrarchy

- (void)didMoveToSuperview {
    [self updateForCurrentOrientationAnimated:NO];
}

#pragma mark - Internal show & hide operations

- (void)showUsingAnimation:(BOOL)animated {
    // Cancel any scheduled hideDelayed: calls
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self setNeedsDisplay];
    
    if (animated && _animationType == ZJProgressHUDAnimationZoomIn) {
        self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
    } else if (animated && _animationType == ZJProgressHUDAnimationZoomOut) {
        self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
    }
    self.showStarted = [NSDate date];
    // Fade in
    if (animated) {
        
#pragma mark - By Zhijun Blurbackground
        // on 150321
        // original is nothing
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        if (_bluredBackground) {
            self.bluredHUDBackground.alpha = 0.f;
            self.indicator.alpha = 0.f;
            label.alpha = 0.f;
            self.alpha = 1.0f;
        }
#endif
#pragma mark end

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.35f];
        
#pragma mark - By Zhijun Blurbackground
        // on 150321
        // original is self.alpha = 1.0f;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        if (_bluredBackground) {
            self.bluredHUDBackground.alpha = 1.f;
            self.indicator.alpha = 1.f;
            label.alpha = 1.f;
        } else {
            self.alpha = 1.0f;
        }
#else
            self.alpha = 1.0f;
        }
#endif
#pragma mark end
        
        if (_animationType == ZJProgressHUDAnimationZoomIn || _animationType == ZJProgressHUDAnimationZoomOut) {
            self.transform = rotationTransform;
        }
        [UIView commitAnimations];
    }
    else {
        self.alpha = 1.0f;
    }
}


- (void)hideUsingAnimation:(BOOL)animated {
#pragma mark - By Zhijun Hide animation
        // on 20160306
        // original is
        /**
         // Fade out
         if (animated && showStarted) {
         [UIView beginAnimations:nil context:NULL];
         [UIView setAnimationDuration:0.30];
         [UIView setAnimationDelegate:self];
         [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
         // 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
         // in the done method
         if (_animationType == ZJProgressHUDAnimationZoomIn) {
         self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
         } else if (_animationType == ZJProgressHUDAnimationZoomOut) {
         self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
         }
         
         self.alpha = 0.02f;
         [UIView commitAnimations];
         }
         else {
         self.alpha = 0.0f;
         [self done];
         }
         self.showStarted = nil;
         */
    CGFloat animationDutation = 1.25;
    if ((_animationType == ZJProgressHUDAnimationZoomIn || _animationType == ZJProgressHUDAnimationZoomOut)
        && (_mode != ZJProgressHUDModeIndeterminate && _mode != ZJProgressHUDModeIndeterminateCancelButton)) {
        animationDutation = 0.25;
    }
    
    if (animated && _showStarted) {
        [UIView animateWithDuration:animationDutation delay:0 usingSpringWithDamping:2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if ((_animationType == ZJProgressHUDAnimationZoomIn || _animationType == ZJProgressHUDAnimationZoomOut)
                && (_mode != ZJProgressHUDModeIndeterminate && _mode != ZJProgressHUDModeIndeterminateCancelButton)) {
                // 去掉dimBackground
                self.dimBackground = NO;
                [self setNeedsDisplay];
                
                if (_animationType == ZJProgressHUDAnimationZoomIn) {
                    self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
                } else if (_animationType == ZJProgressHUDAnimationZoomOut) {
                    self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.75f, 0.75f));
                }
            }
            else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
                if (_bluredBackground) {
                    self.bluredHUDBackground.alpha = 0.f;
                    self.indicator.alpha = 0.f;
                    label.alpha = 0.f;
                } else {
                    self.alpha = 0.f;
                }
#else
                    self.alpha = 0.f;
#endif
            }
        } completion:^(BOOL finished){
            if (_animationType == ZJProgressHUDAnimationZoomIn || _animationType == ZJProgressHUDAnimationZoomOut) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.35 animations:^{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
                        if (_bluredBackground) {
                            self.bluredHUDBackground.alpha = 0.f;
                            self.indicator.alpha = 0.f;
                            label.alpha = 0.f;
                        } else {
                            self.alpha = 0.f;
                        }
#else
                        self.alpha = 0.f;
#endif
                    } completion:^(BOOL finished) {
                        [self done];
                    }];
                });
            } else {
                [self done];
            }
        }];
    }
    else {
        self.alpha = 0.0f;
        [self done];
    }
    self.showStarted = nil;
#pragma mark end
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context {
	[self done];
}

- (void)done {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	isFinished = YES;
	self.alpha = 0.0f;
	if (_removeFromSuperViewOnHide) {
		[self removeFromSuperview];
	}
#if NS_BLOCKS_AVAILABLE
	if (self.completionBlock) {
		self.completionBlock();
		self.completionBlock = NULL;
	}
#endif
	if ([self.delegate respondsToSelector:@selector(hudWasHidden:)]) {
		[self.delegate performSelector:@selector(hudWasHidden:) withObject:self];
	}
#pragma mark - by Zhijun Notification
    // on
    [[NSNotificationCenter defaultCenter] postNotificationName:ZJHUDDidHideNotification object:nil userInfo:@{ZJHUDNotificationUserInfoKey : self}];
#pragma mark end
}

#pragma mark - Threading

- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated {
	methodForExecution = method;
	targetForExecution = ZJ_RETAIN(target);
	objectForExecution = ZJ_RETAIN(object);	
	// Launch execution in new thread
	self.taskInProgress = YES;
	[NSThread detachNewThreadSelector:@selector(launchExecution) toTarget:self withObject:nil];
	// Show HUD view
	[self show:animated];
}

#if NS_BLOCKS_AVAILABLE

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block {
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	[self showAnimated:animated whileExecutingBlock:block onQueue:queue completionBlock:NULL];
}

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(void (^)())completion {
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	[self showAnimated:animated whileExecutingBlock:block onQueue:queue completionBlock:completion];
}

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue {
	[self showAnimated:animated whileExecutingBlock:block onQueue:queue	completionBlock:NULL];
}

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
	 completionBlock:(ZJProgressHUDCompletionBlock)completion {
	self.taskInProgress = YES;
	self.completionBlock = completion;
	dispatch_async(queue, ^(void) {
		block();
		dispatch_async(dispatch_get_main_queue(), ^(void) {
			[self cleanUp];
		});
	});
	[self show:animated];
}

#endif

- (void)launchExecution {
	@autoreleasepool {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		// Start executing the requested task
		[targetForExecution performSelector:methodForExecution withObject:objectForExecution];
#pragma clang diagnostic pop
		// Task completed, update view in main thread (note: view operations should
		// be done only in the main thread)
		[self performSelectorOnMainThread:@selector(cleanUp) withObject:nil waitUntilDone:NO];
	}
}

- (void)cleanUp {
	_taskInProgress = NO;
#if !__has_feature(objc_arc)
	[targetForExecution release];
	[objectForExecution release];
#else
	targetForExecution = nil;
	objectForExecution = nil;
#endif
	[self hide:useAnimation];
}

#pragma mark - UI

- (void)setupLabels {
	label = [[UILabel alloc] initWithFrame:self.bounds];
	label.adjustsFontSizeToFitWidth = NO;
	label.textAlignment = ZJLabelAlignmentCenter;
	label.opaque = NO;
	label.backgroundColor = [UIColor clearColor];
	label.textColor = self.labelColor;
	label.font = self.labelFont;
	label.text = self.labelText;
#pragma mark - By Zhijun labelText numberOfLine
    // on 20151113
    // original is nothing
    label.numberOfLines = 0;
#pragma mark end
	[self addSubview:label];
	
	detailsLabel = [[UILabel alloc] initWithFrame:self.bounds];
	detailsLabel.font = self.detailsLabelFont;
	detailsLabel.adjustsFontSizeToFitWidth = NO;
	detailsLabel.textAlignment = ZJLabelAlignmentCenter;
	detailsLabel.opaque = NO;
	detailsLabel.backgroundColor = [UIColor clearColor];
	detailsLabel.textColor = self.detailsLabelColor;
	detailsLabel.numberOfLines = 0;
	detailsLabel.font = self.detailsLabelFont;
	detailsLabel.text = self.detailsLabelText;

	[self addSubview:detailsLabel];
}

- (void)updateIndicators {
	
	BOOL isActivityIndicator = [_indicator isKindOfClass:[UIActivityIndicatorView class]];
	BOOL isRoundIndicator = [_indicator isKindOfClass:[ZJRoundProgressView class]];
	
    // `|| _mode == ZJProgressHUDModeIndeterminateCancelButton` is added by Zhijun on 160311
	if (_mode == ZJProgressHUDModeIndeterminate || _mode == ZJProgressHUDModeIndeterminateCancelButton) {
		if (!isActivityIndicator) {
			// Update to indeterminate _indicator
			[_indicator removeFromSuperview];
            self.indicator = ZJ_AUTORELEASE([[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]);
			[(UIActivityIndicatorView *)_indicator startAnimating];
            [self addSubview:_indicator];
        }
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000
		[(UIActivityIndicatorView *)_indicator setColor:self.activityIndicatorColor];
#endif
        
#pragma mark - by Zhijun Indicator
        // on 160311
        // original is nothing
        if (_mode == ZJProgressHUDModeIndeterminateCancelButton) {
            self.userInteractionEnabled = YES;
            if (!self.cancelButton) {
                _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
                UIImage *cancelButtonBgImage = [[UIImage imageNamed:@"ZJMBProgressHUD.bundle/ic_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                _cancelButton.bounds = (CGRect){CGPointZero, cancelButtonBgImage.size};
                [_cancelButton setImage:cancelButtonBgImage forState:UIControlStateNormal];
                [_cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                _cancelButton.tintColor = self.labelColor;
                [self addSubview:_cancelButton];
            }
            if (!self.cancelButtonSeparator) {
                _cancelButtonSeparator = [UIImageView new];
                _cancelButtonSeparator.layer.backgroundColor = [self.labelColor colorWithAlphaComponent:0.8].CGColor;
                [self addSubview:_cancelButtonSeparator];
            }
        }
	}
    else {
        [self.cancelButton removeFromSuperview];
        _cancelButton = nil;
        
        [self.cancelButtonSeparator removeFromSuperview];
        _cancelButtonSeparator = nil;
#pragma mark end
        
        if (_mode == ZJProgressHUDModeDeterminateHorizontalBar) {
            // Update to bar determinate _indicator
            [_indicator removeFromSuperview];
            self.indicator = ZJ_AUTORELEASE([[ZJBarProgressView alloc] init]);
            [self addSubview:_indicator];
        }
        else if (_mode == ZJProgressHUDModeDeterminate || _mode == ZJProgressHUDModeAnnularDeterminate) {
            if (!isRoundIndicator) {
                // Update to determinante _indicator
                [_indicator removeFromSuperview];
                self.indicator = ZJ_AUTORELEASE([[ZJRoundProgressView alloc] init]);
                [self addSubview:_indicator];
            }
            if (_mode == ZJProgressHUDModeAnnularDeterminate) {
                [(ZJRoundProgressView *)_indicator setAnnular:YES];
            }
        }
        else if (_mode == ZJProgressHUDModeCustomView && _customView != _indicator) {
            // Update custom view _indicator
            [_indicator removeFromSuperview];
            self.indicator = _customView;
            [self addSubview:_indicator];
            
            // -----------------------------------------
            // by ZhiJun
            // 20160314
            // original is nothing
            _customView.tintColor = self.labelColor;
            [self expendTextLengthWhenZJProgressHUDModeCustomView];
            // -----------------------------------------
        } else if (_mode == ZJProgressHUDModeText) {
            [_indicator removeFromSuperview];
            self.indicator = nil;
        }
    }
}

#pragma mark - By Zhijun Events
// on 160311
// original is nothing
- (void)cancelButtonClicked
{
    [self hide:YES];
    if (self.cancelButtonTouchedUpInside) {
        self.cancelButtonTouchedUpInside(self);
    }
}
#pragma mark end

#pragma mark - By Zhijun Setters
// on 160314
// original is nothing
- (void)sethorizontallyLayout:(BOOL)horizontallyLayout
{
    if (horizontallyLayout == _horizontallyLayout) {
        return;
    }
    
    _horizontallyLayout = horizontallyLayout;
    _cancelButtonSeparator.hidden = !_horizontallyLayout;
    _cancelButton.hidden = !_horizontallyLayout;
}
#pragma mark end

#pragma mark - Layout

- (void)layoutSubviews {
	[super layoutSubviews];
	
	// Entirely cover the parent view
    UIView *parent = self.superview;
#pragma mark By Zhijun fullScreenToCoverNavigationBar
    // on 141219
    // original :
    /**
    if (parent) {
        self.frame = parent.bounds;
    }
    */
    // byZj
    if (parent) {
        if (self.fullScreenToCoverNavigationBar) {
            self.frame = parent.bounds;
        } else { // 使hud不遮住导航栏
            CGRect f = parent.bounds;
            // 为了不遮挡导航栏下面的分割线, 加了1/[UIScreen mainScreen].scale
            CGFloat value = 64 + 1/[UIScreen mainScreen].scale;
            f.size.height -= value;
            f.origin.y = value;
            self.frame = f;
        }
    }
    // end
#pragma mark end

    CGRect bounds = self.bounds;
    
	// Determine the total width and height needed
	CGFloat maxWidth = bounds.size.width - 4 * _margin;
    CGFloat maxHeight = bounds.size.height - 4 * _margin;
	CGSize totalSize = CGSizeZero;
    
#pragma mark - By Zhijun Scale _indicator
    // on 20151113
    // original is nothing
    BOOL onlyIndicator = !self.labelText.length && _indicator;
    if ([_indicator isKindOfClass:[UIActivityIndicatorView class]]) {
        // 横竖添加两条线, 测试放大或缩小后的_indicator是否居中
        //        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(bounds.size.width / 2.f - 0.25f, 0, 0.5, bounds.size.height)];
        //        line1.backgroundColor = [UIColor redColor];
        //        [self addSubview:line1];
        //        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, bounds.size.height / 2.f - 0.25f, bounds.size.width, 0.5)];
        //        line2.backgroundColor = [UIColor redColor];
        //        [self addSubview:line2];
        CGFloat scaleRatio = 0.65f * zj_screenWidthScaleRatio();
        if (onlyIndicator) { // 只单独显示一个_indicator时
            scaleRatio = 0.8f * zj_screenWidthScaleRatio();
            self.minSize = hudMinimumSize_onlyIndicator();
        } else if (self.labelText.length && _indicator) {
            if (!self.horizontallyLayout) {
                self.minSize = hudMinimumSize_bouthTextAndIndicator_vertically();
            } else {
                self.minSize = CGSizeZero;
            }
        }
        
        if (self.horizontallyLayout) {
            scaleRatio = 0.6f * zj_screenWidthScaleRatio();
        }
        
        _indicator.transform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
    } else {
        _indicator.transform = CGAffineTransformIdentity;
    }
#pragma mark end
    CGRect indicatorF = CGRectMake(0, 0, _indicator.frame.size.width, _indicator.frame.size.height);
	indicatorF.size.width = MIN(indicatorF.size.width, maxWidth);
    
    if (onlyIndicator) {
        _cancelButtonSeparator.hidden = YES;
        _cancelButton.hidden = YES;
    }
    
    UILabel *tempLayoutLabel = [UILabel new];
    tempLayoutLabel.text = label.text;
    tempLayoutLabel.font = label.font;
    tempLayoutLabel.numberOfLines = 0;
    
    if (!self.horizontallyLayout || onlyIndicator) {
    
        totalSize.width = MAX(totalSize.width, indicatorF.size.width);
        totalSize.height += indicatorF.size.height;
        
#pragma mark - By Zhijun LabelText MultiLine
        // on 20151113
        // original is CGSize labelSize = ZJ_TEXTSIZE(label.text, label.font);
        CGSize labelSize = [tempLayoutLabel sizeThatFits:CGSizeMake(maxWidth, maxHeight)];
#pragma mark end
        labelSize.width = MIN(labelSize.width, maxWidth);
        totalSize.width = MAX(totalSize.width, labelSize.width);
        totalSize.height += labelSize.height;
        if (labelSize.height > 0.f && indicatorF.size.height > 0.f) {
            totalSize.height += kPadding;
        }
        
        CGFloat remainingHeight = bounds.size.height - totalSize.height - kPadding - 4 * _margin;
        CGSize maxSize = CGSizeMake(maxWidth, remainingHeight);
        CGSize detailsLabelSize = ZJ_MULTILINE_TEXTSIZE(detailsLabel.text, detailsLabel.font, maxSize, detailsLabel.lineBreakMode);
        totalSize.width = MAX(totalSize.width, detailsLabelSize.width);
        totalSize.height += detailsLabelSize.height;
        if (detailsLabelSize.height > 0.f && (indicatorF.size.height > 0.f || labelSize.height > 0.f)) {
            totalSize.height += kPadding;
        }
        
        totalSize.width += 2 * _margin;
        totalSize.height += 2 * _margin;
        
#pragma mark - By Zhijun
        // on 20151203
        // original is nothing
        CGFloat verticalPadding = kPadding;
        if (totalSize.height < _minSize.height) {
            verticalPadding = (_minSize.height - 2 * _margin - ((_minSize.height - totalSize.height) / 2) - indicatorF.size.height - labelSize.height - detailsLabelSize.height);
            if (indicatorF.size.height > .5f && labelSize.height > .5f && detailsLabelSize.height > .5f) { // 3个view都有
                verticalPadding /= 2;
            }
            else if ((indicatorF.size.height > 5.f && labelSize.height > .5f) ||
                     (indicatorF.size.height > .5f && detailsLabelSize.height > .5f) ||
                     (labelSize.height > .5f && detailsLabelSize.height > .5f)) { // 只有两个view
            } else { // 只有一个view或一个都没有
                verticalPadding = kPadding;
            }
        }
        // Tag 此方法中, 这行代码之下的所有kPadding都被我替换成verticalPadding
#pragma mark end
        
#pragma mark - By Zhijun Deprecate Round Values
        // on 20151203
        // original is
        /**
         // Position elements
         CGFloat yPos = round(((bounds.size.height - totalSize.height) / 2)) + _margin + yOffset;
         CGFloat xPos = xOffset;
         indicatorF.origin.y = yPos;
         indicatorF.origin.x = round((bounds.size.width - indicatorF.size.width) / 2) + xPos;
         */
#pragma mark end
        // Position elements
        CGFloat yPos = (bounds.size.height - totalSize.height) / 2.f + _margin + _yOffset;
        CGFloat xPos = _xOffset;
#pragma mark - By Zhijun 修改_indicator的Y值
        // on 20160304
        // original is indicatorF.origin.y = yPos;
        if (self.labelText.length) {
            // 为了视觉上好看，把_indicator往下挪一些
            indicatorF.origin.y = yPos + 1.5f;
        } else {
            indicatorF.origin.y = yPos;
        }
#pragma mark end
        indicatorF.origin.x = (bounds.size.width - indicatorF.size.width) / 2.f + xPos;
        _indicator.frame = indicatorF;
        
        yPos += indicatorF.size.height;
        
        if (labelSize.height > 0.f && indicatorF.size.height > 0.f) {
            yPos += verticalPadding;
        }
        CGRect labelF;
        labelF.origin.y = yPos;
#pragma mark - By Zhijun Deprecate Round Values
        // on 20151203
        // original is
        // labelF.origin.x = round((bounds.size.width - labelSize.width) / 2) + xPos;
        labelF.origin.x = (bounds.size.width - labelSize.width) / 2.f + xPos;
#pragma mark end
        labelF.size = labelSize;
        label.frame = labelF;
        yPos += labelF.size.height;
        
        if (detailsLabelSize.height > 0.f && (indicatorF.size.height > 0.f || labelSize.height > 0.f)) {
            yPos += verticalPadding;
        }
        CGRect detailsLabelF;
        detailsLabelF.origin.y = yPos;
        
#pragma mark - By Zhijun Deprecate Round Values
        // on 20151203
        // original is
        // detailsLabelF.origin.x = round((bounds.size.width - detailsLabelSize.width) / 2) + xPos;
        detailsLabelF.origin.x = (bounds.size.width - detailsLabelSize.width) / 2.f + xPos;
#pragma mark end
        detailsLabelF.size = detailsLabelSize;
        detailsLabel.frame = detailsLabelF;
	
    }
#pragma mark - By Zhijun HorizontalLayout
    // on 20160311
    // original is nothing
    // 不考虑DetailLabelText
    else {
        CGFloat verticalMargin = 1.2 * _margin;
        CGFloat horizontalMargin = 2 * _margin;
        CGFloat horizontalPadding = 2 * kPadding;
        CGFloat paddingBetweenIndicatorAndLabel = horizontalPadding - 3.f;
        
        totalSize.height = MAX(totalSize.height, indicatorF.size.height);
        totalSize.width += indicatorF.size.width;
        
        CGFloat horizontallyLayoutLabelMaxWidth = maxWidth * 2.0/3.0f;
        CGSize labelSize = [tempLayoutLabel sizeThatFits:CGSizeMake(maxWidth, maxHeight)];
        labelSize.width = MIN(labelSize.width, horizontallyLayoutLabelMaxWidth);
        
        totalSize.height = MAX(totalSize.height, labelSize.height);
        totalSize.width += labelSize.width;
        if (labelSize.width > 0.f && indicatorF.size.height > 0.f) {
            totalSize.width += paddingBetweenIndicatorAndLabel;
        }
        
        // Calculate cancelButtonSeparator size
        CGSize cancelButtonSeparatorSize = CGSizeZero;
        if (_cancelButtonSeparator) {
            cancelButtonSeparatorSize = CGSizeMake(1, labelSize.height + 2 * 2);
            totalSize.width += cancelButtonSeparatorSize.width;
            if (labelSize.width > 0.f) {
                totalSize.width += horizontalPadding;
            }
        }
        
        // Calculate cancelButton size
        CGSize cancelButtonSize = CGSizeZero;
        if (_cancelButton) {
            cancelButtonSize = CGSizeMake(self.cancelButton.bounds.size.width, self.cancelButton.bounds.size.height);
            totalSize.height = MAX(totalSize.height, cancelButtonSize.height);
            totalSize.width += cancelButtonSize.width + horizontalPadding;
        }
        
        totalSize.width += 2 * horizontalMargin;
        totalSize.height += 2 * verticalMargin;
        
        // Position elements
        CGFloat yPos = _yOffset;
        CGFloat xPos = (bounds.size.width - totalSize.width) / 2.f + horizontalMargin + _xOffset;
        indicatorF.origin.x = xPos;
        indicatorF.origin.y = (bounds.size.height - indicatorF.size.height) / 2.f + yPos;
        _indicator.frame = indicatorF;
        
        xPos += indicatorF.size.width;
        if (indicatorF.size.height > 0.f) {
            if (_labelText.length) {
                xPos += paddingBetweenIndicatorAndLabel;
            } else {
                xPos += horizontalPadding;
            }
        }
        
        CGRect labelF;
        labelF.origin.x = xPos;
        labelF.origin.y = (bounds.size.height - MAX(labelSize.height, cancelButtonSize.height)) / 2.f + yPos;
        labelF.size = labelSize;
//        if (label.text.length) {
//            labelF.origin.y -= 1 / [UIScreen mainScreen].scale;
//        }
        label.frame = labelF;
        
        xPos += labelF.size.width;
        if (labelF.size.width > 0.f) {
            xPos += horizontalPadding;
        }
        
        CGRect cancelButtonSeparatorF = CGRectZero;
        if (_cancelButtonSeparator) {
            cancelButtonSeparatorF.origin.x = xPos;
            cancelButtonSeparatorF.origin.y = (bounds.size.height - MAX(cancelButtonSeparatorSize.height, cancelButtonSize.height)) / 2.f + yPos;
            cancelButtonSeparatorF.size = cancelButtonSeparatorSize;
            self.cancelButtonSeparator.frame = cancelButtonSeparatorF;
        }
        
        xPos += cancelButtonSeparatorF.size.width;
        if (cancelButtonSeparatorF.size.width > 0.f) {
            xPos += horizontalPadding;
        }
        
        CGRect cancelButtonF = CGRectZero;
        if (_cancelButton) {
            cancelButtonF.origin.x = xPos;
            cancelButtonF.origin.y = CGRectGetMidY(cancelButtonSeparatorF) - cancelButtonSize.height/2.f;
            cancelButtonF.size = cancelButtonSize;
            self.cancelButton.frame = cancelButtonF;
        }
    }
#pragma mark end
    
	// Enforce minsize and quare rules
	if (self.square) {
		CGFloat max = MAX(totalSize.width, totalSize.height);
		if (max <= bounds.size.width - 2 * _margin) {
			totalSize.width = max;
		}
		if (max <= bounds.size.height - 2 * _margin) {
			totalSize.height = max;
		}
	}
	if (totalSize.width < _minSize.width) {
		totalSize.width = _minSize.width;
	} 
	if (totalSize.height < _minSize.height) {
		totalSize.height = _minSize.height;
	}
	
	_size = totalSize;
    
    
#pragma mark - By Zhijun BlurBackground
    // on 160321
    // original is nothing
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if (_bluredBackground) {
        self.bluredHUDBackground.center = CGPointMake(bounds.size.width/2.f + _xOffset, bounds.size.height/2.f + _yOffset);
        self.bluredHUDBackground.bounds = (CGRect){CGPointZero, self.size};
        self.bluredHUDBackground.layer.cornerRadius = self.cornerRadius;
        self.bluredHUDBackground.layer.shadowColor = [UIColor blackColor].CGColor;
        self.bluredHUDBackground.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    } else {
        [self.bluredHUDBackground removeFromSuperview];
    }
#endif
#pragma mark end

}

#pragma mark BG Drawing

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);

	if (self.dimBackground) {
		//Gradient colours
		size_t gradLocationsNum = 2;
		CGFloat gradLocations[2] = {0.0f, 1.0f};
#pragma mark - byZhijun Change dimBackground color
        // original is : CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
		CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.1f};
#pragma mark end
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
		CGColorSpaceRelease(colorSpace);
		//Gradient center
		CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		//Gradient radius
		CGFloat gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
		//Gradient draw
		CGContextDrawRadialGradient (context, gradient, gradCenter,
									 0, gradCenter, gradRadius,
									 kCGGradientDrawsAfterEndLocation);
		CGGradientRelease(gradient);
	}

	// Set background rect color
	if (self.color) {
		CGContextSetFillColorWithColor(context, self.color.CGColor);
	} else {
		CGContextSetGrayFillColor(context, 0.0f, self.opacity);
	}

	
	// Center HUD
	CGRect allRect = self.bounds;
	// Draw rounded HUD backgroud rect
#pragma mark - By Zhijun Deprecate Round Values
    // on 20151203
    // original is
    /**
     CGRect boxRect = CGRectMake(round((allRect.size.width - size.width) / 2) + self.xOffset,
     round((allRect.size.height - size.height) / 2) + self.yOffset, size.width, size.height);
     */
    CGRect boxRect = CGRectMake((allRect.size.width - self.size.width) / 2.f + self.xOffset,
                                (allRect.size.height - self.size.height) / 2.f + self.yOffset, self.size.width, self.size.height);
#pragma mark end
    
#pragma mark - By Zhijun Set ShadowPath Avoid OffScreenRender
    // on 20160304
    // original is nothing
    if (self.layer.shadowColor && !_bluredBackground) {
        self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:boxRect cornerRadius:_cornerRadius].CGPath;
    }
#pragma mark end
    
#pragma mark - By Zhijun BlurBackground
    // on 160321
    // original is
    /**
    	CGFloat radius = self.cornerRadius;
    	CGContextBeginPath(context);
    	CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
    	CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (CGFloat)M_PI / 2, 0, 0);
    	CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (CGFloat)M_PI / 2, 0);
    	CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (CGFloat)M_PI / 2, (CGFloat)M_PI, 0);
    	CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (CGFloat)M_PI, 3 * (CGFloat)M_PI / 2, 0);
    	CGContextClosePath(context);
    	CGContextFillPath(context);
     */
    if (!_bluredBackground) {
        CGFloat radius = self.cornerRadius;
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
        CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (CGFloat)M_PI / 2, 0, 0);
        CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (CGFloat)M_PI / 2, 0);
        CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (CGFloat)M_PI / 2, (CGFloat)M_PI, 0);
        CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (CGFloat)M_PI, 3 * (CGFloat)M_PI / 2, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
    }
#pragma mark end

	UIGraphicsPopContext();
}

#pragma mark - KVO

- (void)registerForKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (void)unregisterFromKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (NSArray *)observableKeypaths {
	return [NSArray arrayWithObjects:@"_mode", @"customView", @"labelText", @"labelFont", @"labelColor",
			@"detailsLabelText", @"detailsLabelFont", @"detailsLabelColor", @"progress", @"activityIndicatorColor", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
	} else {
		[self updateUIForKeypath:keyPath];
	}
}

- (void)updateUIForKeypath:(NSString *)keyPath {
	if ([keyPath isEqualToString:@"_mode"] || [keyPath isEqualToString:@"customView"] ||
		[keyPath isEqualToString:@"activityIndicatorColor"]) {
		[self updateIndicators];
	} else if ([keyPath isEqualToString:@"labelText"]) {
        // -----------------------------------------
        // by ZhiJun
        // on 20151110
        // original is label.text = self.labelText;
        [self expendTextLengthWhenZJProgressHUDModeCustomView];
        // -----------------------------------------
	} else if ([keyPath isEqualToString:@"labelFont"]) {
		label.font = self.labelFont;
	} else if ([keyPath isEqualToString:@"labelColor"]) {
		label.textColor = self.labelColor;
	} else if ([keyPath isEqualToString:@"detailsLabelText"]) {
		detailsLabel.text = self.detailsLabelText;
	} else if ([keyPath isEqualToString:@"detailsLabelFont"]) {
		detailsLabel.font = self.detailsLabelFont;
	} else if ([keyPath isEqualToString:@"detailsLabelColor"]) {
		detailsLabel.textColor = self.detailsLabelColor;
	} else if ([keyPath isEqualToString:@"progress"]) {
		if ([_indicator respondsToSelector:@selector(setProgress:)]) {
			[(id)_indicator setValue:@(self.progress) forKey:@"progress"];
		}
		return;
	}
    [self setNeedsLayout];
    [self setNeedsDisplay];
}
#pragma mark - By Zhijun Min TextLength when ZJProgressHUDModeCustomView
// on 20151110
// original is label.text = self.labelText;
- (void)expendTextLengthWhenZJProgressHUDModeCustomView {
    NSString *temp = [NSString stringWithFormat:@"%@", self.labelText];
    NSInteger textMinLengthWhenCustomView = 14;
    if (self.mode == ZJProgressHUDModeCustomView) { // 保证文字够长, 不够长则在最后补空格, 本来想在前后都补空格, 但是不知为何, 实际测试中, 在前面补空格label上的文字不会居中.
        if (temp.length < textMinLengthWhenCustomView) {
            NSInteger deltaLength = textMinLengthWhenCustomView - temp.length;
            NSInteger halfAddtionalTextLength = deltaLength;
            NSMutableString *leaddingSpace = [[NSMutableString alloc] init];
            for (NSInteger i = 0; i < halfAddtionalTextLength; ++ i) {
                temp = [temp stringByAppendingString:@" "];
            }
            [leaddingSpace appendString:temp];
            temp = leaddingSpace;
        }
    }
    label.text = self.labelText;
}
#pragma mark end

#pragma mark - Notifications

- (void)registerForNotifications {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

	[nc addObserver:self selector:@selector(statusBarOrientationDidChange:)
			   name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)unregisterFromNotifications {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationDidChange:(NSNotification *)notification {
	UIView *superview = self.superview;
	if (!superview) {
		return;
	} else {
		[self updateForCurrentOrientationAnimated:YES];
	}
}

- (void)updateForCurrentOrientationAnimated:(BOOL)animated {
    // Stay in sync with the superview in any case
    if (self.superview) {
        self.bounds = self.superview.bounds;
        [self setNeedsDisplay];
    }

    // Not needed on iOS 8+, compile out when the deployment target allows,
    // to avoid sharedApplication problems on extension targets
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
    // Only needed pre iOS 7 when added to a window
    BOOL iOS8OrLater = kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0;
    if (iOS8OrLater || ![self.superview isKindOfClass:[UIWindow class]]) return;

	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat radians = 0;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		if (orientation == UIInterfaceOrientationLandscapeLeft) { radians = -(CGFloat)M_PI_2; } 
		else { radians = (CGFloat)M_PI_2; }
		// Window coordinates differ!
		self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
	} else {
		if (orientation == UIInterfaceOrientationPortraitUpsideDown) { radians = (CGFloat)M_PI; } 
		else { radians = 0; }
	}
	rotationTransform = CGAffineTransformMakeRotation(radians);
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
	}
	[self setTransform:rotationTransform];
	if (animated) {
		[UIView commitAnimations];
	}
#endif
}

@end


@implementation ZJRoundProgressView

#pragma mark - Lifecycle

- (id)init {
	return [self initWithFrame:CGRectMake(0.f, 0.f, 37.f, 37.f)];
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		_progress = 0.f;
		_annular = NO;
		_progressTintColor = [[UIColor alloc] initWithWhite:1.f alpha:1.f];
		_backgroundTintColor = [[UIColor alloc] initWithWhite:1.f alpha:.1f];
		[self registerForKVO];
	}
	return self;
}

- (void)dealloc {
	[self unregisterFromKVO];
#if !__has_feature(objc_arc)
	[_progressTintColor release];
	[_backgroundTintColor release];
	[super dealloc];
#endif
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
	
	CGRect allRect = self.bounds;
	CGRect circleRect = CGRectInset(allRect, 2.0f, 2.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (_annular) {
		// Draw background
		BOOL isPreiOS7 = kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0;
		CGFloat lineWidth = isPreiOS7 ? 5.f : 2.f;
		UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
		processBackgroundPath.lineWidth = lineWidth;
		processBackgroundPath.lineCapStyle = kCGLineCapButt;
		CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		CGFloat radius = (self.bounds.size.width - lineWidth)/2;
		CGFloat startAngle = - ((CGFloat)M_PI / 2); // 90 degrees
		CGFloat endAngle = (2 * (CGFloat)M_PI) + startAngle;
		[processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
		[_backgroundTintColor set];
		[processBackgroundPath stroke];
		// Draw progress
		UIBezierPath *processPath = [UIBezierPath bezierPath];
		processPath.lineCapStyle = isPreiOS7 ? kCGLineCapRound : kCGLineCapSquare;
		processPath.lineWidth = lineWidth;
		endAngle = (self.progress * 2 * (CGFloat)M_PI) + startAngle;
		[processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
		[_progressTintColor set];
		[processPath stroke];
	} else {
		// Draw background
		[_progressTintColor setStroke];
		[_backgroundTintColor setFill];
		CGContextSetLineWidth(context, 2.0f);
		CGContextFillEllipseInRect(context, circleRect);
		CGContextStrokeEllipseInRect(context, circleRect);
		// Draw progress
		CGPoint center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
		CGFloat radius = (allRect.size.width - 4) / 2;
		CGFloat startAngle = - ((CGFloat)M_PI / 2); // 90 degrees
		CGFloat endAngle = (self.progress * 2 * (CGFloat)M_PI) + startAngle;
		[_progressTintColor setFill];
		CGContextMoveToPoint(context, center.x, center.y);
		CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
		CGContextClosePath(context);
		CGContextFillPath(context);
	}
}

#pragma mark - KVO

- (void)registerForKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (void)unregisterFromKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (NSArray *)observableKeypaths {
	return [NSArray arrayWithObjects:@"progressTintColor", @"backgroundTintColor", @"progress", @"annular", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self setNeedsDisplay];
}

@end


@implementation ZJBarProgressView

#pragma mark - Lifecycle

- (id)init {
	return [self initWithFrame:CGRectMake(.0f, .0f, 120.0f, 20.0f)];
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_progress = 0.f;
		_lineColor = [UIColor whiteColor];
		_progressColor = [UIColor whiteColor];
		_progressRemainingColor = [UIColor clearColor];
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		[self registerForKVO];
	}
	return self;
}

- (void)dealloc {
	[self unregisterFromKVO];
#if !__has_feature(objc_arc)
	[_lineColor release];
	[_progressColor release];
	[_progressRemainingColor release];
	[super dealloc];
#endif
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context, 2);
	CGContextSetStrokeColorWithColor(context,[_lineColor CGColor]);
	CGContextSetFillColorWithColor(context, [_progressRemainingColor CGColor]);
	
	// Draw background
	CGFloat radius = (rect.size.height / 2) - 2;
	CGContextMoveToPoint(context, 2, rect.size.height/2);
	CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius);
	CGContextAddLineToPoint(context, rect.size.width - radius - 2, 2);
	CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius);
	CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius);
	CGContextAddLineToPoint(context, radius + 2, rect.size.height - 2);
	CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius);
	CGContextFillPath(context);
	
	// Draw border
	CGContextMoveToPoint(context, 2, rect.size.height/2);
	CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius);
	CGContextAddLineToPoint(context, rect.size.width - radius - 2, 2);
	CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius);
	CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius);
	CGContextAddLineToPoint(context, radius + 2, rect.size.height - 2);
	CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius);
	CGContextStrokePath(context);
	
	CGContextSetFillColorWithColor(context, [_progressColor CGColor]);
	radius = radius - 2;
	CGFloat amount = self.progress * rect.size.width;
	
	// Progress in the middle area
	if (amount >= radius + 4 && amount <= (rect.size.width - radius - 4)) {
		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
		CGContextAddLineToPoint(context, amount, 4);
		CGContextAddLineToPoint(context, amount, radius + 4);
		
		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
		CGContextAddLineToPoint(context, amount, rect.size.height - 4);
		CGContextAddLineToPoint(context, amount, radius + 4);
		
		CGContextFillPath(context);
	}
	
	// Progress in the right arc
	else if (amount > radius + 4) {
		CGFloat x = amount - (rect.size.width - radius - 4);

		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
		CGContextAddLineToPoint(context, rect.size.width - radius - 4, 4);
		CGFloat angle = -acos(x/radius);
		if (isnan(angle)) angle = 0;
		CGContextAddArc(context, rect.size.width - radius - 4, rect.size.height/2, radius, M_PI, angle, 0);
		CGContextAddLineToPoint(context, amount, rect.size.height/2);

		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
		CGContextAddLineToPoint(context, rect.size.width - radius - 4, rect.size.height - 4);
		angle = acos(x/radius);
		if (isnan(angle)) angle = 0;
		CGContextAddArc(context, rect.size.width - radius - 4, rect.size.height/2, radius, -M_PI, angle, 1);
		CGContextAddLineToPoint(context, amount, rect.size.height/2);
		
		CGContextFillPath(context);
	}
	
	// Progress is in the left arc
	else if (amount < radius + 4 && amount > 0) {
		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
		CGContextAddLineToPoint(context, radius + 4, rect.size.height/2);

		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
		CGContextAddLineToPoint(context, radius + 4, rect.size.height/2);
		
		CGContextFillPath(context);
	}
}

#pragma mark - KVO

- (void)registerForKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (void)unregisterFromKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (NSArray *)observableKeypaths {
	return [NSArray arrayWithObjects:@"lineColor", @"progressRemainingColor", @"progressColor", @"progress", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self setNeedsDisplay];
}

@end
