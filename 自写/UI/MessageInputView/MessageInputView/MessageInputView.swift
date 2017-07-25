//
//  MessageInputView.swift
//  MessageInputView
//
//  Created by luozhijun on 2017/6/20.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

/** 消息输入视图的样式 */
enum MessageInputViewStyle: Int {
    /// 右侧一个加号按钮的样式; Only plus button at right side;
    case style1
    /// 左侧有切换语音输入按钮, 右侧有表情输入和加号按钮; Voice inputting button at left side, emotion inputting button and plus button at right side, the same as WeChat App;
    case style2
}

/** 超文本输入方式 */
enum HyperTextInputting: Int {
    case album
    case camera
    case location
}

/** 超文本输入方式模型 */
class HyperTextInputtingModel: NSObject {
    var mode: HyperTextInputting = HyperTextInputting.album
    var icon: UIImage?
    var title: String?
    
    static var defaultModes: [HyperTextInputtingModel] {
        var result = [HyperTextInputtingModel]()
        let methods: [HyperTextInputting] = [.album, .camera]
        let iconNames = ["messageView_pic", "messageView_camera"]
        for index in 0..<methods.count {
            let model = HyperTextInputtingModel()
            model.mode = methods[index]
            model.icon = UIImage(named: iconNames[index])
            result.append(model)
        }
        return result
    }
}

//MARK: - 
@objc protocol MessageInputViewDelegate: NSObjectProtocol {
    @objc optional func messageInputView(_ inputView: MessageInputView, willChangeFrameToFitText newFrame: CGRect, animated: Bool)
    @objc optional func messageInputView(_ inputView: MessageInputView, didChangeFrameToFitTextAnimated: Bool)
    @objc optional func messageInputViewCanTypeReturnCharacter(_ inputView: MessageInputView) -> Bool
    @objc optional func messageInputViewDidTypeReturnCharacter(_ inputView: MessageInputView)
}

//MARK: -
/** 类似iMessage\WeChat\What'sApp的消息输入视图 */
class MessageInputView: UIView {
    
    fileprivate var style: MessageInputViewStyle = MessageInputViewStyle.style2
    
    /// frame改变后会影响到的view, 典型如展示消息的tableView
    weak var frameAffectingView: UIView?
    weak var delegate: MessageInputViewDelegate?
    
    fileprivate var bgView         : UIToolbar = UIToolbar()
    fileprivate var topSeparator   : CALayer = CALayer()
    fileprivate var plusBtn        : UIButton = UIButton(type: .system)
    fileprivate var voiceInputBtn  : UIButton!
    fileprivate var emotionInputBtn: UIButton!
    fileprivate var textView       : UITextView = UITextView()
    fileprivate var bottomSeparator: UIImageView = UIImageView()
    
    fileprivate var minimumHeight: CGFloat = 0
    var maximumNumberOfLines: Int = 5
    fileprivate var maximumHeight: CGFloat {
        // 计算5行文字的高度
        let tempTextView = UITextView()
        tempTextView.font = self.textView.font
        tempTextView.text = "测\n测\n测\n测\n测"
        let fiveLineTextNeedsHeight = tempTextView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
        
        return fiveLineTextNeedsHeight + contentBorderPadding.top + contentBorderPadding.bottom
    }
    
    fileprivate var hyperTextInputtingView: HyperTextInputtingView!
    
    fileprivate var contentBorderPadding: UIEdgeInsets = UIEdgeInsets(top: 6, left: 3, bottom: 6, right: 3)
    static func defaultContentBorderPadding(forStyle style: MessageInputViewStyle = .style1) -> UIEdgeInsets {
        if style == .style1 {
            return UIEdgeInsets(top: 6, left: 3, bottom: 6, right: 3)
        } else {
            return UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        }
    }
    
    static let suggestedHeight: CGFloat = 44
    static let separatorColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1)
    
    fileprivate var buttonVerticalPadding: CGFloat = 0
    fileprivate var isTextLinesGreaterThanOne: Bool = false

    fileprivate var keyboardDidShow = false
    fileprivate var currentKeyboardHeight: CGFloat = 0
    
    var itemClicked: ((HyperTextInputtingModel, Int) -> Swift.Void)?
    
    var text: String? {
        return textView.text
    }
    
    required init(style: MessageInputViewStyle, frame: CGRect, contentBorderPadding: UIEdgeInsets = MessageInputView.defaultContentBorderPadding()) {
        super.init(frame: .zero)
        self.style                = style
        self.contentBorderPadding = contentBorderPadding
        minimumHeight             = frame.height
        
        setupSubviews()
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: Setup UI
extension MessageInputView {
    
    fileprivate func setupSubviews() {
        addSubview(bgView)
        // 去除顶部分割线
        bgView.clipsToBounds = true
        
        layer.addSublayer(topSeparator)
        topSeparator.backgroundColor = MessageInputView.separatorColor.cgColor
        
        addSubview(plusBtn)
        plusBtn.setImage(UIImage(named: "messageView_more"), for: .normal)
        plusBtn.sizeToFit()
        plusBtn.addTarget(self, action: #selector(plusBtnClicked), for: .touchUpInside)
        
        if style == .style2 {
            voiceInputBtn = UIButton(type: .system)
            addSubview(voiceInputBtn)
            voiceInputBtn.setImage(UIImage(named: "ToolViewInputVoice"), for: .normal)
            voiceInputBtn.setImage(UIImage(named: "ToolViewInputVoiceHL"), for: .highlighted)
            voiceInputBtn.sizeToFit()
            voiceInputBtn.addTarget(self, action: #selector(voiceInputBtnClicked), for: .touchUpInside)
            
            emotionInputBtn = UIButton(type: .system)
            addSubview(emotionInputBtn)
            emotionInputBtn.setImage(UIImage(named: "ToolViewEmotion"), for: .normal)
            emotionInputBtn.setImage(UIImage(named: "ToolViewEmotionHL"), for: .highlighted)
            emotionInputBtn.sizeToFit()
            emotionInputBtn.addTarget(self, action: #selector(emotionInputBtnClicked), for: .touchUpInside)
        }
        
        addSubview(textView)
        textView.delegate           = self
        textView.font               = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled    = false
        textView.returnKeyType      = .send
        textView.backgroundColor    = UIColor.clear
        textView.layer.cornerRadius = 2
        textView.layer.borderColor  = MessageInputView.separatorColor.cgColor
        textView.layer.borderWidth  = 1/UIScreen.main.scale
        
        addSubview(bottomSeparator)
        bottomSeparator.backgroundColor = MessageInputView.separatorColor
    }
    
    override var frame: CGRect {
        didSet {
            bgView.frame = bounds
            
            let separatorHeight: CGFloat = 1/UIScreen.main.scale
            topSeparator.frame = CGRect(x: 0, y: 0, width: frame.width, height: separatorHeight)
            
            let integralityHorizontalPadding: CGFloat = contentBorderPadding.left
            let textViewInteritemPadding: CGFloat = 3
            
            var plusBtnY: CGFloat = 0
            if !isTextLinesGreaterThanOne {
                buttonVerticalPadding = (frame.height - plusBtn.bounds.height)/2
                plusBtnY = buttonVerticalPadding
            } else { // 文字大于一行时按钮钉在底部, 下同
                plusBtnY = frame.height - buttonVerticalPadding - plusBtn.bounds.height
            }
            
            var textViewX    : CGFloat = integralityHorizontalPadding + textViewInteritemPadding
            var textViewWidth: CGFloat = 0
            let textViewHeght: CGFloat = frame.height - 2*contentBorderPadding.top - 2*separatorHeight
            let textViewY    : CGFloat = (frame.height - textViewHeght)/2
            
            if style == .style1 {
                textViewWidth = frame.width - 2*integralityHorizontalPadding - 2*textViewInteritemPadding - plusBtn.bounds.width
                plusBtn.frame.origin = CGPoint(x: textViewX + textViewWidth + textViewInteritemPadding, y: plusBtnY)
            } else if style == .style2, voiceInputBtn != nil, emotionInputBtn != nil {
                var voiceInputBtnY: CGFloat = 0
                if !isTextLinesGreaterThanOne {
                    buttonVerticalPadding = (frame.height - voiceInputBtn.bounds.height)/2
                    voiceInputBtnY = buttonVerticalPadding
                } else {
                    voiceInputBtnY = frame.height - buttonVerticalPadding - voiceInputBtn.bounds.height
                }
                voiceInputBtn.frame.origin = CGPoint(x: integralityHorizontalPadding, y: voiceInputBtnY)
                
                textViewX     = voiceInputBtn.frame.maxX + textViewInteritemPadding;
                textViewWidth = frame.width - voiceInputBtn.bounds.width - emotionInputBtn.bounds.width - plusBtn.bounds.width - 2*textViewInteritemPadding
                
                var emotionInputBtnY: CGFloat = 0
                if !isTextLinesGreaterThanOne {
                    buttonVerticalPadding = (frame.height - emotionInputBtn.bounds.height)/2
                    emotionInputBtnY = buttonVerticalPadding
                } else {
                    emotionInputBtnY = frame.height - buttonVerticalPadding - emotionInputBtn.bounds.height
                }
                emotionInputBtn.frame.origin = CGPoint(x: textViewX + textViewWidth + textViewInteritemPadding, y: emotionInputBtnY)
                
                plusBtn.frame.origin = CGPoint(x: emotionInputBtn.frame.maxX, y: plusBtnY)
            }
            textView.frame = CGRect(x: textViewX, y: textViewY, width: textViewWidth, height: textViewHeght)
            
            bottomSeparator.frame = CGRect(x: 0, y: frame.height - separatorHeight, width: frame.width, height: separatorHeight)
            
            if let frameAffectingView = frameAffectingView {
                frameAffectingView.frame.size.height = frame.minY
                // 上移时把tableView滚动到最后一行
                if oldValue.origin.y > frame.height {
                    if let tableView = frameAffectingView as? UITableView, let indexPathes = tableView.indexPathsForVisibleRows, indexPathes.count > 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                            tableView.scrollToRow(at: IndexPath(row: 29, section: 0), at: .bottom, animated: true)
                        })
                    }
                }
            }
            
            let tempFrame = frame
            super.frame = tempFrame
        }
    }
    
    /// 递归遍历子视图, 以设置顶部分割线
    @discardableResult
    fileprivate func recursivelyGetTopLine(_ subviews: [UIView]? = nil) -> UIImageView? {
        var subviews: [UIView]! = subviews
        if subviews == nil {
            subviews = self.subviews
        }
        
        for view in subviews {
            if let topLine = view as? UIImageView, topLine.frame.height.isEqual(to: 1.0/UIScreen.main.scale) {
                return topLine
            }
            return recursivelyGetTopLine(view.subviews)
        }
        
        return nil
    }
    
    fileprivate func setupHyperTextInputtingView() {
        if hyperTextInputtingView == nil, superview != nil {
            let inputtingModels = HyperTextInputtingModel.defaultModes
            let layout: (flow: UICollectionViewFlowLayout, suggestedHeight: CGFloat) = HyperTextInputtingView.defaultLayout(fittingWidth: self.frame.width, fittingItemCount: inputtingModels.count)
            let frame = CGRect(x: 0, y: superview!.frame.height, width: self.frame.width, height: layout.suggestedHeight)
            hyperTextInputtingView = HyperTextInputtingView(inputtingModels: inputtingModels, frame: frame, layout: layout.flow)
            hyperTextInputtingView.itemClicked = { [weak self] (model, indexPath) in
                self?.itemClicked?(model, indexPath.item)
            }
        }
    }
    
    /// 还原到初始高度
    fileprivate func resetHeight(animated: Bool = true) {
        let deltaHeight: CGFloat = minimumHeight - frame.height
        if deltaHeight < 0.01 {
            return
        }
        
        var selfFrame             = frame
        var textViewFrame         = textView.frame
        selfFrame.size.height     = minimumHeight
        selfFrame.origin.y        -= deltaHeight
        textViewFrame.size.height = minimumHeight - contentBorderPadding.top - contentBorderPadding.bottom
        
        delegate?.messageInputView?(self, willChangeFrameToFitText: selfFrame, animated: animated)
        if animated {
            UIView.animate(withDuration: 0.25, animations: { 
                self.frame          = selfFrame
                self.textView.frame = textViewFrame
            }, completion: { (_) in
                self.delegate?.messageInputView?(self, didChangeFrameToFitTextAnimated: animated)
            })
        } else {
            frame          = selfFrame
            textView.frame = textViewFrame
            delegate?.messageInputView?(self, didChangeFrameToFitTextAnimated: animated)
        }
    }
}

//MARK: Animation
extension MessageInputView {
    fileprivate func showHyperTextInputtingView(animationCurve: Int = 7) {
        setupHyperTextInputtingView()
        guard hyperTextInputtingView?.superview == nil else { return }
        
        superview?.addSubview(hyperTextInputtingView)
        endEditing(true)
        let upperHeight = hyperTextInputtingView.frame.height
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(rawValue: UInt(animationCurve << 16)), animations: {
            self.hyperTextInputtingView.frame.origin.y -= upperHeight
            self.frame.origin.y = self.hyperTextInputtingView.frame.minY - self.frame.height
        }) { (_) in
        }
    }
    
    func hideHyperTextInputtingView(animated: Bool = true) {
        guard hyperTextInputtingView?.superview != nil else { return }
        let downHeight = hyperTextInputtingView.frame.height
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.hyperTextInputtingView.frame.origin.y += downHeight
                self.frame.origin.y += downHeight
            }) { (_) in
                self.hyperTextInputtingView?.removeFromSuperview()
            }
        } else {
            self.frame.origin.y += downHeight
            self.hyperTextInputtingView.frame.origin.y += downHeight
            self.hyperTextInputtingView?.removeFromSuperview()
        }
    }
}

//MARK: Keyboard
extension MessageInputView {
    func keyboardInfo(of sender: Notification) -> (frame: CGRect, animationDuration: TimeInterval, animationCurve: Int) {
        var keyboardFrame = CGRect(x: 0, y: 0, width: 0, height: 258)
        if let kf = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            keyboardFrame = kf
        }
        var animationDuration: TimeInterval = 0.25
        if let ad = sender.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
            animationDuration = ad
        }
        var animationCurve: Int = 7
        if let ac = sender.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Int {
            animationCurve = ac
        }
        return (keyboardFrame, animationDuration, animationCurve)
    }
    
    override func didMoveToSuperview() {
        superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(superviewShouldEndEditing)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboradWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc fileprivate func superviewShouldEndEditing() {
        superview?.endEditing(true)
        hideHyperTextInputtingView(animated: true)
    }
    
    @objc fileprivate func keyboardWillShow(sender: Notification) {
        let keyboardInfo = self.keyboardInfo(of: sender)
        UIView.animate(withDuration: keyboardInfo.animationDuration, delay: 0, options: UIViewAnimationOptions(rawValue: UInt(keyboardInfo.animationCurve << 16)), animations: {
            self.hideHyperTextInputtingView(animated: false)
            self.frame.origin.y                       = keyboardInfo.frame.minY - self.frame.height
        }, completion: { (_) in
            self.keyboardDidShow = true
        })
    }
    
    @objc fileprivate func keyboradWillHide(sender: Notification) {
        let keyboardInfo = self.keyboardInfo(of: sender)
        UIView.animate(withDuration: keyboardInfo.animationDuration, delay: 0, options: UIViewAnimationOptions(rawValue: UInt(keyboardInfo.animationCurve << 16)), animations: {
            self.frame.origin.y                       += keyboardInfo.frame.height
        }, completion: { (_) in
            self.keyboardDidShow       = false
            self.currentKeyboardHeight = 0
        })
    }
    
    @objc fileprivate func keyboardWillChangeFrame(sender: Notification) {
        currentKeyboardHeight = keyboardInfo(of: sender).frame.height
    }
}

//MARK: Handle Events
extension MessageInputView {
    @objc fileprivate func plusBtnClicked() {
        showHyperTextInputtingView()
    }
    
    @objc fileprivate func emotionInputBtnClicked() {
        
    }
    
    @objc fileprivate func voiceInputBtnClicked() {
        
    }
}

//MARK: UITextViewDelegate
extension MessageInputView : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let needsHeight: CGFloat = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
        var deltaHeight: CGFloat = needsHeight - textView.frame.height
        var selfFrame            = frame
        let maxHeight            = maximumHeight
        
        isTextLinesGreaterThanOne = false
        textView.isScrollEnabled  = false
        if fabs(deltaHeight) > 0.1 {
            selfFrame.size.height += deltaHeight
            if selfFrame.size.height <= minimumHeight {
                deltaHeight               = minimumHeight - frame.height
                selfFrame.size.height     = minimumHeight
            } else if selfFrame.size.height > maxHeight {
                textView.isScrollEnabled  = true
                isTextLinesGreaterThanOne = true
                deltaHeight               = maxHeight - frame.height
                selfFrame.size.height     = maxHeight
            } else {
                let tempTextView = UITextView()
                tempTextView.font = textView.font
                tempTextView.text = "测"
                let oneLineHeight = tempTextView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
                if textView.frame.height + deltaHeight > oneLineHeight {
                    isTextLinesGreaterThanOne = true
                }
            }
            selfFrame.origin.y -= deltaHeight
            
            delegate?.messageInputView?(self, willChangeFrameToFitText: selfFrame, animated: true)
            
            if deltaHeight < 0 {
                bgView.barTintColor = superview?.backgroundColor
                backgroundColor     = superview?.backgroundColor
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                self.frame.size.height   = selfFrame.size.height
                self.frame.origin.y     -= deltaHeight
            }, completion: { (_) in
                self.bgView.barTintColor = nil
                self.backgroundColor     = nil
                self.delegate?.messageInputView?(self, didChangeFrameToFitTextAnimated: true)
            })
        }
    }
    
    /// 控制特殊字符, 比如换行和@
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            delegate?.messageInputViewDidTypeReturnCharacter?(self)
            if let bool = delegate?.messageInputViewCanTypeReturnCharacter?(self) {
                return bool
            }
        }
        return true
    }
}



