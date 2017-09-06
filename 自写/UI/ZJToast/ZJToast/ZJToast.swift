//
//  ZJToast.swift
//  ZJToast
//
//  Created by luozhijun on 2017/7/20.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

public enum ZJToastStyle: Int {
    case textOnly
    case indicator
    case progress
}

open class ZJToast: UIView {
    
    static var horizontalMargin: CGFloat = 18
    static var verticalMargin  : CGFloat = 12
    static var indicatorScale  : CGFloat = 1.25
    static var subviewInteritemPadding_1: CGFloat = 8
    static var subviewInteritemPadding_2: CGFloat = 16
    
    fileprivate static let initialFrame = CGRect(x: -1.11, y: -1.11, width: 0, height: 0)
    
    fileprivate var style: ZJToastStyle = .textOnly
    fileprivate var shadowView          = UIView()
    fileprivate var backgroundView      = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    fileprivate var messageLabel        = UILabel()
    fileprivate lazy var progressView: ZJProgressView = {
        let rect = CGRect(x: 0, y: 0, width: 30, height: 30)
        let view = ZJProgressView(frame: rect, style: .pie, outlineWidth: 1)
        view.backgroundMaskColor = .clear
        view.tintColor = UIColor.red
        return view
    }()
    fileprivate var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.transform = CGAffineTransform(scaleX: ZJToast.indicatorScale, y: ZJToast.indicatorScale)
        return indicator
    }()
    fileprivate var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "btn_cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(cancelButtonDidClick), for: .touchUpInside)
        return button
    }()
    fileprivate var cancelButtonSeparator = UIView()
    
    open var cornerRadius: CGFloat = 6
    open var needsCancelButton = false
    open var animated = true
    open var animationDuration: TimeInterval = 0.25
    open var cancelButtonClicked: ((ZJToast) -> Swift.Void)?
    open var progress: CGFloat = 0 {
        didSet {
            progressView.progress = progress
        }
    }
    
    public required init(message: String?, style: ZJToastStyle = .textOnly, needsCancelButton: Bool, cornerRadius: CGFloat = 6) {
        self.style             = style
        self.cornerRadius      = cornerRadius
        self.needsCancelButton = needsCancelButton
        super.init(frame: ZJToast.initialFrame)
        setupSubviews()
        messageLabel.text = message
        frame = UIScreen.main.bounds
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func cancelButtonDidClick() {
        cancelButtonClicked?(self)
    }
}

//MARK: - Setup UI
extension ZJToast {
    fileprivate func setupSubviews() {
        addSubview(shadowView)
        shadowView.layer.cornerRadius  = cornerRadius
        shadowView.layer.shadowColor   = UIColor.black.cgColor
        shadowView.layer.shadowOffset  = CGSize(width: 0.7, height: 0.7)
        shadowView.layer.shadowRadius  = 2
        shadowView.layer.shadowOpacity = 0.6
        shadowView.backgroundColor     = UIColor.lightGray
        
        shadowView.addSubview(backgroundView)
        backgroundView.layer.cornerRadius  = cornerRadius
        backgroundView.layer.masksToBounds = true
        
        shadowView.addSubview(messageLabel)
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.textColor = UIColor.white//UIColor(colorLiteralRed: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        messageLabel.numberOfLines = 0
        
        if style == .indicator {
            shadowView.addSubview(indicator)
        } else if style == .progress {
            shadowView.addSubview(progressView)
        }
        if needsCancelButton {
            shadowView.addSubview(cancelButton)
            cancelButton.tintColor = messageLabel.textColor
            shadowView.addSubview(cancelButtonSeparator)
            cancelButtonSeparator.backgroundColor = messageLabel.textColor
        }
    }
    
    open override var frame: CGRect {
        didSet {
            guard frame != ZJToast.initialFrame else { return }
            let separatorWidth         = 3.5/UIScreen.main.scale
            let separatorHeight        = cancelButton.bounds.height * 1.2
            var toastNeedsSize         = CGRect(x: 0, y: 0, width: ZJToast.horizontalMargin * 2, height: ZJToast.verticalMargin * 2)
            var maxWidth: CGFloat      = frame.width - 2 * 50
            var contentHeight: CGFloat = 0
            
            if style == .indicator {
                let indicatorNeedsWidth = indicator.bounds.width * ZJToast.indicatorScale + ZJToast.subviewInteritemPadding_1
                maxWidth -= indicatorNeedsWidth
                toastNeedsSize.size.width += indicatorNeedsWidth
                contentHeight = indicator.bounds.height
            } else if style == .progress {
                let progressViewNeedsWidth = progressView.bounds.size.width + ZJToast.subviewInteritemPadding_1
                maxWidth -= progressViewNeedsWidth
                toastNeedsSize.size.width += progressViewNeedsWidth
                contentHeight = progressView.bounds.height
            }
            if needsCancelButton {
                let cancelButtonNeedsWidth = 2 * ZJToast.subviewInteritemPadding_2 + cancelButton.bounds.size.width + separatorWidth
                maxWidth -= cancelButtonNeedsWidth
                toastNeedsSize.size.width += cancelButtonNeedsWidth
            }
            let messageNeedsSize = messageLabel.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
            contentHeight = max(contentHeight, messageNeedsSize.height)
            contentHeight = max(contentHeight, separatorHeight)
            
            toastNeedsSize.size.width  += messageNeedsSize.width
            toastNeedsSize.size.height += contentHeight
            
            shadowView.frame = CGRect(x: (frame.width - toastNeedsSize.width)/2, y: (frame.height - toastNeedsSize.height)/2, width: toastNeedsSize.width, height: toastNeedsSize.height)
            let toastBounds = CGRect(x: 0, y: 0, width: toastNeedsSize.width, height: toastNeedsSize.height)
            shadowView.layer.shadowPath = UIBezierPath(roundedRect: toastBounds, cornerRadius: cornerRadius).cgPath
            backgroundView.frame = shadowView.bounds
            
            var layoutX = ZJToast.horizontalMargin
            if style == .indicator {
                indicator.frame = CGRect(x: layoutX, y: (toastNeedsSize.height - indicator.bounds.height * ZJToast.indicatorScale)/2, width: indicator.bounds.width, height: indicator.bounds.height)
                layoutX += ZJToast.subviewInteritemPadding_1 + indicator.bounds.width * ZJToast.indicatorScale
            } else if style == .progress {
                progressView.frame = CGRect(x: layoutX, y: (toastNeedsSize.height - progressView.bounds.height)/2, width: progressView.bounds.width, height: progressView.bounds.height)
                layoutX += ZJToast.subviewInteritemPadding_1 + progressView.bounds.size.width
            }
            messageLabel.frame = CGRect(x: layoutX, y: (toastNeedsSize.height - messageNeedsSize.height)/2, width: messageNeedsSize.width, height: messageNeedsSize.height)
            layoutX += messageNeedsSize.width + ZJToast.subviewInteritemPadding_2
            if needsCancelButton {
                cancelButtonSeparator.frame = CGRect(x: layoutX , y: (toastNeedsSize.height - separatorHeight)/2, width: separatorWidth, height: separatorHeight)
                cancelButton.frame = CGRect(x: cancelButtonSeparator.frame.maxX + ZJToast.subviewInteritemPadding_2, y: (toastNeedsSize.height - cancelButton.bounds.height)/2, width: cancelButton.bounds.width, height: cancelButton.bounds.height)
            }
            
            let tempF = frame
            super.frame = tempF
        }
    }
}


