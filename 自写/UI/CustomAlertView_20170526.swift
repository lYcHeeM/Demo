//
//  CustomAlertView.swift
//  wanjia2B
//
//  Created by luozhijun on 2017/5/18.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit

fileprivate let viewMargin     : CGFloat = 1.0
fileprivate let leftMargin     : CGFloat = 10
fileprivate let topMargin      : CGFloat = 30
fileprivate let titleMargin    : CGFloat = 20.0
fileprivate let alertViewWidth : CGFloat = 270.0
//float运算误差
fileprivate let alertviewHeight: CGFloat = 150.0
fileprivate let titleHeight    : CGFloat = 20.0
fileprivate let imageViewHeight: CGFloat = 106
fileprivate let buttonHeight   : CGFloat = 44


@objc protocol CustomALertviewDelegate: NSObjectProtocol {
    @objc optional func customAlertView(_ alertView: CustomAlertView, didClickButtonAt index: Int)
}

class CustomAlertView: UIView {
    
    weak var delegate: CustomALertviewDelegate?
    var message: String? {
        didSet {
            messageLabel.text = message
        }
    }
    
    fileprivate var alertView      = UIView()
    fileprivate var backgroundview = UIView()
    fileprivate var messageLabel   = UILabel()
    fileprivate var title             : String?
    fileprivate var cancelButtonTitle : String?
    fileprivate var confirmButtonTitle: String?
    fileprivate var image             : UIImage?
    
    fileprivate var cancelButtonCallBack : (() -> Void)?
    fileprivate var confirmButtonCallBack: (() -> Void)?
    
    required init(title: String?, message: String?, cancelButtonTitle: String? = "取消", confirmButtonTitle: String? = "确定") {
        super.init(frame: UIScreen.main.bounds)
        self.title              = title
        self.message            = message
        self.cancelButtonTitle  = cancelButtonTitle
        self.confirmButtonTitle = confirmButtonTitle
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    class func show(withTitle title: String? = nil, message: String?, cancelButtonTitle: String? = "取消", confimButtonTitle: String? = "确定", cancelButtonCallBack: (() -> Swift.Void)? = nil, confirmButtonCallBack: (() -> Swift.Void)?) -> CustomAlertView {
        let alert = CustomAlertView(title: title, message: message, cancelButtonTitle: cancelButtonTitle, confirmButtonTitle: confimButtonTitle)
        alert.cancelButtonCallBack  = cancelButtonCallBack
        alert.confirmButtonCallBack = confirmButtonCallBack
        alert.show()
        return alert
    }
    
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.25) {
            self.alertView.alpha = 1.0
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.2, animations: { 
            self.alpha = 0.0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
}

//MARK: - Setup UI
extension CustomAlertView {
    fileprivate func setupSubviews() {
        // 创建遮板
        addSubview(backgroundview)
        backgroundview.frame           = UIScreen.main.bounds
        backgroundview.backgroundColor = .black
        backgroundview.alpha           = 0.3
        backgroundview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgoundviewTapped)))
        
        // 创建alertView
        addSubview(alertView)
        alertView.frame = CGRect(x: 0, y: 0, width: alertViewWidth, height: alertviewHeight)
        alertView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        alertView.backgroundColor    = .groupTableViewBackground
        alertView.alpha              = 0.0
        alertView.layer.cornerRadius = 10
        alertView.clipsToBounds      = true
        
        // 创建展示标题框
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: alertViewWidth, height: imageViewHeight)
        alertView.addSubview(imageView)
        imageView.contentMode     = .scaleToFill
        imageView.backgroundColor = .white
        imageView.image           = image
        
        // messageLabel
        let labelWidth: CGFloat = alertViewWidth - leftMargin*2
        var messageFrame = CGRect(x: leftMargin, y: titleMargin, width: labelWidth, height: imageViewHeight - topMargin)
        if let title = title, title.isEmpty == false {
            messageFrame = CGRect(x: leftMargin, y: topMargin + titleHeight + titleMargin, width: labelWidth, height: titleHeight)
            let titleLabel = UILabel(frame: CGRect(x: leftMargin, y: topMargin, width: labelWidth, height: titleHeight))
            titleLabel.text          = title
            titleLabel.textColor     = UIColor.paOrangeColor()
            titleLabel.font          = UIFont.systemFont(ofSize: 17)
            titleLabel.textAlignment = .center
            imageView.addSubview(titleLabel)
        }
        
        imageView.addSubview(messageLabel)
        messageLabel.frame         = messageFrame
        messageLabel.text          = message
        messageLabel.numberOfLines = 2
        messageLabel.font          = UIFont.systemFont(ofSize: 15)
        messageLabel.textAlignment = .center
        
        // Buttons
        let isCancelButtonTitleEmpty  = cancelButtonTitle  == nil || cancelButtonTitle?.isEmpty  == true
        let isConfirmButtonTitleEmpty = confirmButtonTitle == nil || confirmButtonTitle?.isEmpty == true
        
        if isCancelButtonTitleEmpty && isConfirmButtonTitleEmpty {
            alertView.frame.size.height = imageViewHeight
            return
        } else {
            let buttonFrame = CGRect(x: 0, y: imageViewHeight + viewMargin, width: alertViewWidth, height: buttonHeight)
            var singleButton: UIButton!
            if isCancelButtonTitleEmpty {
                singleButton = button(with: buttonFrame, title: confirmButtonTitle)
                alertView.addSubview(singleButton)
            } else if isConfirmButtonTitleEmpty {
                singleButton = button(with: buttonFrame, title: cancelButtonTitle)
                alertView.addSubview(singleButton)
            } else {
                let buttonWidth = (alertViewWidth - viewMargin) / 2.0
                let cancelButtonFrame = CGRect(x: 0, y: imageViewHeight + viewMargin, width: buttonWidth, height: buttonHeight)
                let confirmButtonFrame = CGRect(x: buttonWidth + viewMargin, y: imageViewHeight + viewMargin, width: buttonWidth, height: buttonHeight)
                let cancelButton  = button(with: cancelButtonFrame, title: cancelButtonTitle)
                alertView.addSubview(cancelButton)
                cancelButton.tag  = 1
                let confirmButton = button(with: confirmButtonFrame, title: confirmButtonTitle)
                alertView.addSubview(confirmButton)
                confirmButton.tag = 2
            }
        }
    }
    
    fileprivate func button(with frame: CGRect, title: String?) -> UIButton {
        let button   = UIButton(type: .system)
        button.tintColor = .clear
        button.frame     = frame
        button.setTitle(title, for: .normal)
        button.setTitleColor(.paOrangeColor(), for: .normal)
        button.backgroundColor   = .white
        button.titleLabel?.font  = UIFont.systemFont(ofSize: 15)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return button
    }
}

//MARK: - Handle Events
extension CustomAlertView {
    @objc fileprivate func backgoundviewTapped(recoginzer: UITapGestureRecognizer) {
        let location = recoginzer.location(in: backgroundview)
        if !alertView.frame.contains(location) {
            dismiss()
        }
    }
    
    @objc fileprivate func buttonClicked(sender: UIButton) {
        delegate?.customAlertView?(self, didClickButtonAt: sender.tag - 1)
        if sender.tag == 1 || sender.tag == 3 {
            cancelButtonCallBack?()
        }
        if sender.tag == 2 || sender.tag == 3 {
            confirmButtonCallBack?()
        }
        dismiss()
    }
}





