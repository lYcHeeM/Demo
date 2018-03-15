//
//  ZJWordDetectingLabel.m
//  UILabelLineHeighText
//
//  Created by luozhijun on 15-1-20.
//  Copyright (c) 2015年 bgyun. All rights reserved.
//

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#import "ZJWordDetectingLabel.h"
#import "UIColor+ZJ.h"

NSString *const ZJWordDetectingLabelOutSideScrollViewDidScrollNotification = @"kZJWordDetectingLabelOutSideScrollViewDidScrollNotification";
NSString *const ZJWordDetectingLabelOutSideViewDidTouchNotification = @"kZJWordDetectingLabelOutSideViewDidTouchNotification";
NSString *const ZJWordDetectingLabelDidTouchNotification = @"kZJWordDetectingLabelOutSideViewDidTouchNotification";
NSString *const ZJWordDetectingLabelDidTouchNotificationKey = @"ZJWordDetectingLabelDidTouchNotificationKey";

@interface ZJWordDetectingLabel () 
/**
 *  菜单的显示参照rect是否是self.bounds
 */
@property (nonatomic, assign) BOOL menuControllerTargetRectIsBounds;
/**
 *  是否已经令actionSheet显示<br/>
 *  因为发现longPressGestureDidFire:这个方法会连续调用两次<br/>
 *  故用此标志位来控制, 否则会有连续两个actionSheet被显示
 */
@property (nonatomic, assign) BOOL isShowingActionSheet;
/**
 *  是否点击了不同的链接 (和上次点击的链接比较) <br/>
 *  用于在recoverBackgroundColor方法中判断是否应该setNeesDisplay
 */
@property (nonatomic, assign) BOOL hasTouchedDifferentLink;
@end

@implementation ZJWordDetectingLabel

BOOL ZJIsPad(void) {
    static NSInteger isPad = -1;
    if (isPad < 0) {
        isPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? 1 : 0;
    }
    return isPad > 0;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    _copyEnableInWord = YES;
    _copyEnableInTotal = YES;
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self baseSetting];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    _copyEnableInWord = YES;
    _copyEnableInTotal = YES;
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    [self baseSetting];
    return self;
}

- (void)baseSetting
{
    _shouldChangeBackgroundColor = YES;
    self.userInteractionEnabled = YES;
    
    if (!self.highlightedBackgroundColor) {
        self.highlightedBackgroundColor = RGBACOLOR(167, 202, 255, 1.0);
    }
    if (!self.highlightEndBackgroundColor) {
        self.highlightEndBackgroundColor = self.backgroundColor;
    }
    
    // TTTAtributedLabel很奇怪的一点, 经测试
    // 必须先移除所有(也可能是某个或某些)文字属性, 再添加对应的文字属性
    // 才能做好和UILabel的文字排版一样
//    __weak typeof(self) weakSelf = self;
//    [self setText:self.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//        NSRange range = NSMakeRange(0, mutableAttributedString.length);
//        [mutableAttributedString enumerateAttributesInRange:range options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
//            for (NSString *key in attrs.allKeys) {
//                [mutableAttributedString removeAttribute:key range:range];
//            }
//        }];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineBreakMode = weakSelf.lineBreakMode;
//        [mutableAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
//        [mutableAttributedString addAttribute:NSFontAttributeName value:weakSelf.font range:range];
//        return mutableAttributedString;
//    }];
    
    [self setupDefaultLinkAttributes];
    
    // 添加通知
    if (self.copyEnableInWord || self.copyEnableInTotal || self.allowHighlightBgColorWhenTouching) {
        [self addRecoverBgColorNotifications];
    }
    // 发现可以使高亮背景色和MenuController一起消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recoverBackgroundColor) name:UIMenuControllerDidHideMenuNotification object:nil];
}

- (void)setupDefaultLinkAttributes
{
    // 修改默认的断行模式
    // 以及默认的链接文字属性
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = self.font.lineHeight * 0.165;
    NSDictionary *paragraphAtt = @{(NSString *)kCTParagraphStyleAttributeName : paragraphStyle};
    self.linkAttributes = paragraphAtt;
    self.inactiveLinkAttributes = paragraphAtt;
    if (!self.highlightedBackgroundColor || [self.highlightedBackgroundColor isKindOfClass:[NSNull class]]) {
        self.highlightedBackgroundColor = RGBACOLOR(167, 202, 255, 1.0);
    }
    self.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName : self.textColor,
                                  kTTTBackgroundFillColorAttributeName : (__bridge id)self.highlightedBackgroundColor.CGColor,
                                  (NSString *)kCTParagraphStyleAttributeName : paragraphStyle};
}

- (void)addRecoverBgColorNotifications
{
    // 暂时注释这些代码, 注释后, 在单击(非长按)的话如果高亮了label的话
    // 在点击其他地方或者滑动scrollView时不会还原背景色
    // 根据需求可打开
    //    [[NSNotificationCenter defau ltCenter] removeObserver:self];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recoverBackgroundColor) name:ZJWordDetectingLabelOutSideScrollViewDidScrollNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recoverBackgroundColor) name:ZJWordDetectingLabelOutSideViewDidTouchNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.bounds, point)) {
        return YES;
    } else {
        [self recoverBackgroundColor];
        return NO;
    }
}

#pragma mark - ZJWordDetectingLabel
- (void)setText:(id)text
{
    [super setText:text];
    
    // 为了使得 检测单词 和 不检测单词 时label的排版一样
    // 在每次设置文字时默认把添加的文字全体当做一个单词(需要打开对应位置的注释-->line408)
    [self detectAllWordsBySeparatorsInString:@""];
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor
{
    _highlightedBackgroundColor = highlightedBackgroundColor;
    
    NSMutableDictionary *activeLineAttrs = [NSMutableDictionary dictionaryWithDictionary:self.activeLinkAttributes];
    [activeLineAttrs setObject:(__bridge id)highlightedBackgroundColor.CGColor forKey:kTTTBackgroundFillColorAttributeName];
    self.activeLinkAttributes = activeLineAttrs;
}

- (void)setCopyEnableInTotal:(BOOL)copyEnableInTotal
{
    _copyEnableInTotal = copyEnableInTotal;
    if (copyEnableInTotal == YES) {
        [self addRecoverBgColorNotifications];
    }
}

- (void)setCopyEnableInWord:(BOOL)copyEnableInWord
{
    _copyEnableInWord = copyEnableInWord;
    if (copyEnableInWord == YES) {
        [self addRecoverBgColorNotifications];
    }
}

- (void)setAllowHighlightBgColorWhenTouching:(BOOL)allowHighlightBgColorWhenTouching
{
    _allowHighlightBgColorWhenTouching = allowHighlightBgColorWhenTouching;
    if (allowHighlightBgColorWhenTouching == YES) {
        [self addRecoverBgColorNotifications];
    }
}

- (NSString *)textString
{
    if ([self.text isKindOfClass:[NSString class]]) {
        return self.text;
    } else if ([self.text isKindOfClass:[NSAttributedString class]]) {
        return [self.text string];
    } else {
        return nil;
    }
}

- (void)setTextAttributesForAllText:(NSDictionary *)attributes
{
    [self setTextAttributes:attributes inRange:NSMakeRange(0, [self.text length])];
}

- (void)setTextAttributes:(NSDictionary *)attributes inRange:(NSRange)targetRange
{
    [self setText:self.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
#pragma mark 先移除对应的属性, 似乎不需要, 暂时先不管
//        NSRange range = NSMakeRange(0, mutableAttributedString.length);
//        for (NSString *addingAttrKey in attributes.allKeys) {
//            [mutableAttributedString enumerateAttributesInRange:range options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
//                for (NSString *key in attrs.allKeys) {
//                    if ([key isEqualToString:addingAttrKey]) {
//                        [mutableAttributedString removeAttribute:key range:range];
//                    }
//                }
//            }];
//        }
        [mutableAttributedString addAttributes:attributes range:targetRange];
        return mutableAttributedString;
    }];
    
    // 因为调用setText:afterInheritingLabelAttributesAndConfiguringWithBlock:方法
    // 会导致所有之前添加的链接失效, 所以这里冲天添加一次;
    [self detectAllWordsBySeparatorsInString:nil];
}

- (void)recoverBackgroundColor
{
    if (![[UIColor colorWithCGColor:self.layer.backgroundColor] isEqualToColor:self.highlightEndBackgroundColor])
    {
        [UIView animateWithDuration:0.35 animations:^{
            self.layer.backgroundColor = self.highlightEndBackgroundColor.CGColor;
        }];
    }
    if (self.seletedCheckingResult && !self.hasTouchedDifferentLink) {
        [self setNeedsDisplay];
        if (!self.isShowingActionSheet) {
            _seletedCheckingResult = nil;
        }
    }
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _touchPoint = [touch locationInView:self];
    
    [super touchesBegan:touches withEvent:event];
    
    self.hasTouchedDifferentLink = NO;
    if (_activeLink && (_activeLink == _seletedCheckingResult)) { // 如果点击了重复的链接, 取消链接高亮
        [self setNeedsDisplay];
        _seletedCheckingResult = nil;
        if ([UIMenuController sharedMenuController].isMenuVisible) {
            [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
        }
        return;
    } else if (_activeLink) {
        self.hasTouchedDifferentLink = YES;
    }
    
    BOOL shouldChangeBgColor = YES;
    // 如果背景色已经是高亮背景 --> 还原背景色
    if ([[UIColor colorWithCGColor:self.layer.backgroundColor] isEqualToColor:self.highlightedBackgroundColor]) {
        shouldChangeBgColor = NO;
        [UIView animateWithDuration:0.35 animations:^{
            self.layer.backgroundColor = self.highlightEndBackgroundColor.CGColor;
        }];
//        if ([UIMenuController sharedMenuController].isMenuVisible) {
//            [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
//        }
//        return;
    }
    
    if ([UIMenuController sharedMenuController].isMenuVisible) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }
    
    // 赋值
    _seletedCheckingResult = _activeLink;
    if (_activeLink) { // 如果点击的位置有链接, 不允许改变label的背景色
        _shouldChangeBackgroundColor = NO;
        _menuControllerTargetRectIsBounds = NO;
        shouldChangeBgColor = NO;
        
    } else {
        _shouldChangeBackgroundColor = YES;
        if (self.copyEnableInTotal) { // 如果点击的位置没有链接而且开启了全局拷贝
            _menuControllerTargetRectIsBounds = YES;
        } else if (!self.allowHighlightBgColorWhenTouching) {
            shouldChangeBgColor = NO;
        }
        
        if (self.seletedCheckingResult) {
            [self setNeedsDisplay];
            _seletedCheckingResult = nil;
        }
    }
    
    if (shouldChangeBgColor) {
        self.layer.backgroundColor = self.highlightedBackgroundColor.CGColor;
    }
    
    [self shouldShowMenuController];
    
    // 通知外界点击了label
    if ([self.delegate respondsToSelector:@selector(wordDetectingLabel:didTappedAtPoint:)]) {
        [self.delegate wordDetectingLabel:self didTappedAtPoint:[touch locationInView:self]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZJWordDetectingLabelDidTouchNotification object:self userInfo:@{ZJWordDetectingLabelDidTouchNotificationKey :[NSValue valueWithCGPoint:[touch locationInView:self]]}];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    _shouldChangeBackgroundColor = YES;
    _hasTouchedDifferentLink = NO;
    
    // 是否还原背景色
    if (self.cancelHighLightedBackgroundColorWhenTouchEndOrCancel) {
        [self recoverBackgroundColor];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    _shouldChangeBackgroundColor = YES;
    _hasTouchedDifferentLink = NO;
    
    // 是否还原背景色
    if (self.cancelHighLightedBackgroundColorWhenTouchEndOrCancel) {
        [self recoverBackgroundColor];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL retValue = NO;
    
    if (action == @selector(copy:)) {
        if (self.copyEnableInTotal || self.copyEnableInWord)
        {
            retValue = YES;
        }
    }
    else {
        // Pass the canPerformAction:withSender: message to the superclass
        // and possibly up the responder chain.
        retValue = [super canPerformAction:action withSender:sender];
    }
    
    return retValue;
}

- (void)copy:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *stringToCopy;
    if ([self.delegate respondsToSelector:@selector(stringToCopyForLabel:atTouchPoint:)]) {
        stringToCopy = [self.delegate stringToCopyForLabel:self atTouchPoint:self.touchPoint];
    }
    else {
        if (_seletedCheckingResult) {
            stringToCopy = [self.textString substringWithRange:_seletedCheckingResult.range];;
        } else {
            stringToCopy = self.textString;
        }
    }
    
    [pasteboard setString:stringToCopy];
}

#pragma mark - detect words
- (void)detectAllWordsBySeparatorsInString:(NSString *)separatorsString
{
    if (!self.textString.length) {
        return;
    }
    
    [self setupDefaultLinkAttributes];
    NSString *text = self.textString;
    
    [self detectWordsInRange:NSMakeRange(0, text.length) separatorsInString:separatorsString];
}

- (void)detectWordsInRange:(NSRange)range separatorsInString:(NSString *)separatorsString
{
    NSString *text = self.textString;
    BOOL error = (range.length > text.length) || (range.location > text.length - 1);
    NSAssert(!error, @"range error  %s", __PRETTY_FUNCTION__);
    
    NSString *string = [self.textString substringWithRange:range];
    
    NSString *currSeparatorString = nil;
    if (separatorsString == nil) {
        currSeparatorString = @",， .。\'‘’\"“”";
    } else if (separatorsString.length == 0) {
        [self detectWords:@[text] firstWordRange:NSMakeRange(0, text.length)];
        return;
    }
    NSCharacterSet *separators = [NSCharacterSet characterSetWithCharactersInString:currSeparatorString];
    NSMutableArray *words = [NSMutableArray arrayWithArray:[string componentsSeparatedByCharactersInSet:separators]];
    
    // 删除分隔符 和 不在指定范围内的单词
    NSMutableIndexSet *removingWordIndexes = [NSMutableIndexSet indexSet];
    int i = 0;
    NSUInteger nextLocation = 0;
    for (; i < words.count; ++i) {
        NSString *word = words[i];
        if ([currSeparatorString rangeOfString:word].length || word.length == 0) { // 删除分隔符
            [removingWordIndexes addIndex:i];
        } else { // 删除不在指定范围内的单词
            NSRange searchRange = NSMakeRange(nextLocation, range.length - nextLocation);
            NSRange wordRange = [string rangeOfString:word options:NSCaseInsensitiveSearch range:searchRange];
            if (wordRange.location != NSNotFound) {
                nextLocation = wordRange.location + wordRange.length;
            } else {
                [removingWordIndexes addIndex:i];
            }
        }
    }
    [words removeObjectsAtIndexes:removingWordIndexes];
    
    if (words.count) {
        // 获取第一个单词在self.text中的范围
        NSRange firstWordRange = [self.textString rangeOfString:words[0] options:NSCaseInsensitiveSearch range:range];
        [self detectWords:words firstWordRange:firstWordRange];
    }
}

- (void)detectWords:(NSArray *)words firstWordRange:(NSRange)firstWordRange
{
    NSString *string = self.textString;
    
    NSUInteger nextLocation = firstWordRange.location;
    for (NSString *word in words) {
        NSRange searchRange = NSMakeRange(nextLocation, string.length - nextLocation);
        NSRange wordRange = [string rangeOfString:word options:NSCaseInsensitiveSearch range:searchRange];
        
        if (wordRange.location != NSNotFound) {
            [self addLinkToURL:nil withRange:wordRange];
            nextLocation = wordRange.location + wordRange.length;
        }
    }
}

#pragma mark - menuController
- (BOOL)shouldShowMenuController
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    menuController.arrowDirection = UIMenuControllerArrowDefault;
    
    // 如果未开启复制
    // 或者当前的背景色不是高亮背景色且菜单显示的rect为self.bounds时
    // 不可显示menuController, 并且隐藏当前的menuController
    // 这是为了达到点击非链接位置后高亮背景, 再次点击非链接位置还原背景并且隐藏menuController
    if ((!self.copyEnableInTotal && !self.copyEnableInWord) ||
        (![[UIColor colorWithCGColor:self.layer.backgroundColor] isEqualToColor:self.highlightedBackgroundColor] && self.menuControllerTargetRectIsBounds))
    {
        [menuController setMenuVisible:NO animated:YES];
        return NO;
    }
    
    BOOL shouldShowMenuController = YES;
    
    if ([self.delegate respondsToSelector:@selector(wordDetectingLabel:shouldShowMenuController:withTextCheckingResult:atPoint:wordRects:)]) {
        NSTextCheckingResult *res = nil;
        if (_seletedCheckingResult) { // 如果是添加的链接, 则传递对应的NSTextCheckingResult
            res = _seletedCheckingResult;
        } else { // 如果不是连接, 则传递一个随便创建的NSTextCheckingResult, 只需要拿到range就行
            res = [NSTextCheckingResult replacementCheckingResultWithRange:NSMakeRange(0, ((NSString *)self.text).length) replacementString:self.text];
        }
        shouldShowMenuController = [self.delegate wordDetectingLabel:self shouldShowMenuController:menuController withTextCheckingResult:res atPoint:self.touchPoint wordRects:self.highlightedTextRects];
    }
    
    if (shouldShowMenuController) {
        [self becomeFirstResponder];
        if ([self.delegate respondsToSelector:@selector(menuTargetRectInLabelCoordinates:atTouchPoint:)]) {
            CGRect targetRect = [self.delegate menuTargetRectInLabelCoordinates:self atTouchPoint:self.touchPoint];
            [menuController setTargetRect:targetRect inView:self];
            [menuController setMenuVisible:YES animated:YES];
        } else if (self.menuControllerTargetRectIsBounds && self.copyEnableInTotal) {
            [menuController setTargetRect:self.bounds inView:self];
            [menuController setMenuVisible:YES animated:YES];
        } else if (!self.menuControllerTargetRectIsBounds && self.copyEnableInWord) {
            [menuController setTargetRect:[self.highlightedTextRects[0] CGRectValue] inView:self];
            [menuController setMenuVisible:YES animated:YES];
        } else {
            shouldShowMenuController = NO;
        }
    }
    
    return shouldShowMenuController;
}

#pragma mark - show actionSheet
- (void)longPressGestureDidFire:(UILongPressGestureRecognizer *)sender
{
    [super longPressGestureDidFire:sender];
    
    // 效仿NIAttributedLabel
    // 长按时显示actionSheet
    if (self.seletedCheckingResult && !self.isShowingActionSheet) {
        
        BOOL shouldShowActionSheet = NO;
        UIActionSheet *actionSheet = [self actionSheetForResult:self.seletedCheckingResult];
        
        if ([self.delegate respondsToSelector:@selector(wordDetectingLabel:shouldShowActionSheet:withTextCheckingResult:atPoint:wordRects:)]) {
            shouldShowActionSheet = [self.delegate wordDetectingLabel:self shouldShowActionSheet:actionSheet withTextCheckingResult:self.seletedCheckingResult atPoint:self.touchPoint wordRects:self.highlightedTextRects];
        }
        
        if (shouldShowActionSheet) {
            // 因为发现longPressGestureDidFire:这个方法会连续调用两次
            // 故用此标志位来控制, 否则会有连续两个actionSheet被显示
            self.isShowingActionSheet = YES;
            if (ZJIsPad()) {
                [actionSheet showFromRect:CGRectMake(self.touchPoint.x - 22, self.touchPoint.y - 22, 44, 44) inView:self animated:YES];
            } else {
                [actionSheet showInView:self];
            }
        }
    }
    
    if (sender.state == UIGestureRecognizerStateBegan && ![UIMenuController sharedMenuController].isMenuVisible) {
//        [self shouldShowMenuController];
    }
    
    // 是否还原背景色
//    if (self.cancelHighLightedBackgroundColorWhenTouchEndOrCancel) {
//        [self recoverBackgroundColor];
//    }
}

- (UIActionSheet *)actionSheetForResult:(NSTextCheckingResult *)result {
    UIActionSheet* actionSheet =
    [[UIActionSheet alloc] initWithTitle:nil
                                delegate:self
                       cancelButtonTitle:nil
                  destructiveButtonTitle:nil
                       otherButtonTitles:nil];
    
    NSString* title = nil;
    if (NSTextCheckingTypeLink == result.resultType) {
        if ([result.URL.scheme isEqualToString:@"mailto"]) {
            title = result.URL.resourceSpecifier;
            [actionSheet addButtonWithTitle:NSLocalizedString(@"Open in Mail", @"在邮件中打开")];
            [actionSheet addButtonWithTitle:NSLocalizedString(@"Copy Email Address", @"复制Email地址")];
            
        } else {
            title = result.URL.absoluteString;
            [actionSheet addButtonWithTitle:NSLocalizedString(@"Open in Safari", @"在浏览器中打开")];
            [actionSheet addButtonWithTitle:NSLocalizedString(@"Copy URL", @"复制url")];
        }
        
    } else if (NSTextCheckingTypePhoneNumber == result.resultType) {
        title = result.phoneNumber;
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Call", @"拨打电话")];
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Copy Phone Number", @"复制号码")];
        
    } else if (NSTextCheckingTypeAddress == result.resultType) {
        title = [self.text substringWithRange:self.seletedCheckingResult.range];
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Open in Maps", @"使用地图打开")];
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Copy Address", @"复制地址")];
        
    }
    actionSheet.title = title;
    
    if (!ZJIsPad()) {
        [actionSheet setCancelButtonIndex:[actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"取消")]];
    }
    
    return actionSheet;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (NSTextCheckingTypeLink == self.seletedCheckingResult.resultType) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:self.seletedCheckingResult.URL];
            
        } else if (buttonIndex == 1) {
            if ([self.seletedCheckingResult.URL.scheme isEqualToString:@"mailto"]) {
                if (self.seletedCheckingResult.URL.resourceSpecifier) {
                    [[UIPasteboard generalPasteboard] setString:self.seletedCheckingResult.URL.resourceSpecifier];
                }
            } else {
                if (self.seletedCheckingResult.URL) {
                    [[UIPasteboard generalPasteboard] setURL:self.seletedCheckingResult.URL];
                }
            }
        }
        
    } else if (NSTextCheckingTypePhoneNumber == self.seletedCheckingResult.resultType) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:self.seletedCheckingResult.phoneNumber]]];
            
        } else if (buttonIndex == 1) {
            if (self.seletedCheckingResult.phoneNumber) {
                [[UIPasteboard generalPasteboard] setString:self.seletedCheckingResult.phoneNumber];
            }
        }
        
    } else if (NSTextCheckingTypeAddress == self.seletedCheckingResult.resultType) {
        NSString* address = [self.textString substringWithRange:self.seletedCheckingResult.range];
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[@"http://maps.google.com/maps?q=" stringByAppendingString:address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            
        } else if (buttonIndex == 1) {
            [[UIPasteboard generalPasteboard] setString:address];
        }
    }
    
    self.isShowingActionSheet = NO;
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    self.isShowingActionSheet = NO;
    _seletedCheckingResult = nil;
}
@end
