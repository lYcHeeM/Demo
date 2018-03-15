//
//  ZJWordDetectingLabel.h
//  UILabelLineHeighText
//
//  Created by luozhijun on 15-1-20.
//  Copyright (c) 2015年 bgyun. All rights reserved.
//

#import "TTTAttributedLabel.h"

extern NSString *const ZJWordDetectingLabelOutSideScrollViewDidScrollNotification;
extern NSString *const ZJWordDetectingLabelOutSideViewDidTouchNotification;
/** 点击了label后发出的通知, userInfo中附有点击的位置 */
extern NSString *const ZJWordDetectingLabelDidTouchNotification;
extern NSString *const ZJWordDetectingLabelDidTouchNotificationKey;

@class ZJWordDetectingLabel;

#pragma mark - 检测单词, 拷贝文字回调相关
@protocol ZJWordDetectingLabelDelegate <TTTAttributedLabelDelegate>
@optional
/* ----------------------------------------------
 *  检测单词, 拷贝文字回调相关
 * ---------------------------------------------- */

/**
 *  询问代理是否应该显示气泡菜单(UIMenuController)
 *
 *  @param wordDetectingLabel 告诉代理是哪个ZJWordDetectingLabel对象
 *  @param controller
 *  @param result             点击位置对应的NSTextCheckingResult对象, 如果点击位置没有链接, 则以整个label文字创建一个NSTextCheckingResult对象: <br/>
 *                            [NSTextCheckingResult replacementCheckingResultWithRange:NSMakeRange(0, ((NSString *)self.text).length) replacementString:self.text];
 *  @param point              点击的位置
 *  @param wordRects          单词所占的矩形区域, 可能包含多个矩形
 *
 *  @return 如果为YES, 则显示UIMenuController(默认只有拷贝选项); 若为NO, 则不显示.
 */
- (BOOL)wordDetectingLabel:(ZJWordDetectingLabel *)wordDetectingLabel shouldShowMenuController:(UIMenuController *)controller withTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point wordRects:(NSArray *)wordRects;
/**
 *  询问代理点击"拷贝按钮"时应该拷贝的文字<br/>
 *  @note 如果实现的此方法, 则不论选中label中哪个位置的文字, 点击"拷贝"按钮时, 拷贝到沾粘板的都将是代理返回的文字.<br/>
 *  如果没有实现此方法, 默认拷贝的就是当前选中的文字
 *
 *  @param wordDetectingLabel 告诉代理是哪个ZJWordDetectingLabel对象
 *  @param point              点击的位置
 *
 *  @return 将要拷贝到沾粘板的文字
 */
- (NSString *)stringToCopyForLabel:(ZJWordDetectingLabel *)wordDetectingLabel atTouchPoint:(CGPoint)point;
/**
 *  询问代理点击label某个位置后, 气泡菜单(UIMenuController)的目标矩形区域(targetRect).<br/>
 *  @note 如果实现了此方法, 气泡菜单的显示位置将会以此方法返回的矩形区域为参照.<br/>
 *  绝大多数情况下不需要实现, 除非气泡显示的位置不正确.
 *
 *  @param wordDetectingLabel 告诉代理是哪个ZJWordDetectingLabel对象
 *  @param point              点击的位置
 *
 *  @return 气泡菜单(UIMenuController)的目标矩形区域(targetRect)
 */
- (CGRect)menuTargetRectInLabelCoordinates:(ZJWordDetectingLabel *)wordDetectingLabel atTouchPoint:(CGPoint)point;
/**
 *  询问代理是否应该在长按某个链接时显示ActionSheet
 *
 *  @param wordDetectingLabel 告诉代理是哪个ZJWordDetectingLabel对象
 *  @param actionSheet        即将显示的ActionSheet
 *  @param textCheckingResult 点击位置对应的NSTextCheckingResult对象
 *  @param point              点击的位置
 *  @param wordRects          点击位置涉及到的矩形区域
 *
 *  @return 如果为YES, 则显示ActionSheet; 若为NO, 则不显示.
 */
- (BOOL)wordDetectingLabel:(ZJWordDetectingLabel *)wordDetectingLabel shouldShowActionSheet:(UIActionSheet *)actionSheet withTextCheckingResult:(NSTextCheckingResult *)textCheckingResult atPoint:(CGPoint)point wordRects:(NSArray *)wordRects;

#pragma mark end

/* ----------------------------------------------
 *  单击回调相关
 * ---------------------------------------------- */
- (void)wordDetectingLabel:(ZJWordDetectingLabel *)wordDetectingLabel didTappedAtPoint:(CGPoint)point;
@end

@interface ZJWordDetectingLabel : TTTAttributedLabel <UIActionSheetDelegate>
IB_DESIGNABLE
/**
 *  正在使链接高亮的时候, 是否应该改变整个label的背景颜色<br/>
 *  故外界可通过此标志位获知是否 <b>应该</b> 改变label的背景色<br/>
 *  普通状态下为YES, 正在使连接高亮的时候为NO
 */
@property (nonatomic, assign, readonly) BOOL shouldChangeBackgroundColor;

/**
 *  长按时整个label的高亮背景颜色<br/>
 *  RGBACOLOR(167, 202, 255, 1.0)
 */
@property (nonatomic, strong) IBInspectable UIColor *highlightedBackgroundColor;
/**
 *  长按结束时整个label的高亮背景颜色<br/>
 *  默认为label初始的self.backgroundColor
 */
@property (nonatomic, strong) IBInspectable UIColor *highlightEndBackgroundColor;

/**
 *  是否可拷贝全部文字
 */
@property (nonatomic, assign) IBInspectable BOOL copyEnableInTotal;
/**
 *  是否可拷贝单词
 */
@property (nonatomic, assign) IBInspectable BOOL copyEnableInWord;
/**
 *  是否允许在触摸时改变背景色
 *  @note: 如果在开启copyEnableInTotal中copyEnableInWord任意一个时, 此属性将无效
 */
@property (nonatomic, assign) IBInspectable BOOL allowHighlightBgColorWhenTouching;
/**
 *  选中的检查结果
 */
@property (nonatomic, strong, readonly) NSTextCheckingResult *seletedCheckingResult;
/**
 *  点击的位置, 或者上次点击的位置<br/>
 */
@property (nonatomic, assign, readonly) CGPoint touchPoint;
/**
 *  label的文字<br/>
 *  由于TTTAtributedLabel的text是id类型<br/>
 *  这里为了方便获取文字, 增加一个textString属性
 */
@property (nonatomic, copy, readonly) NSString *textString;

@property (nonatomic, weak) IBOutlet id <ZJWordDetectingLabelDelegate> delegate;

/**
 *  恢复为原来的背景色
 */
- (void)recoverBackgroundColor;
- (void)setTextAttributesForAllText:(NSDictionary *)attributes;
- (void)setTextAttributes:(NSDictionary *)attributes inRange:(NSRange)targetRange;

#pragma mark - 检测单词相关
/**
 *  检测self.text中所有词, 需要定义词与词之间的分隔符
 *
 *  @param separatorsString 分隔符组成的字符串, 如果为空, 则默认为@",， .。\'‘’\"“”"
 */
- (void)detectAllWordsBySeparatorsInString:(NSString *)separatorsString;

/**
 *  检测self.text中指定范围中的所有词, 需要定义词与词之间的分隔符
 *
 *  @param range            指定的范围
 *  @param separatorsString 分隔符组成的字符串, 如果为空, 则默认为@",， .。\'‘’\"“”:："
 */
- (void)detectWordsInRange:(NSRange)range separatorsInString:(NSString *)separatorsString;

/**
 *  检测self.text中外界指定的词, 需要提供第一个词在self.text中的范围(range)
 *
 *  @param words          指定的词,
 *                        @note 假设self.text = @"ace be to ace is a ace.",
 *                        如果提供的words为@[@"ace", @"ace"], 那么会认为这两个@"ace"分别是第1个和第2个
 *  @param firstWordRange 指定的词中第一个词在self.text中的范围(range)
 */
- (void)detectWords:(NSArray *)words firstWordRange:(NSRange)firstWordRange;
#pragma mark end
@end

