//
//  PAPopupContainerView.swift
//  wanjia2B
//
//  Created by luozhijun on 2017/2/16.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit

@objc protocol PAPopupContainerViewDelegate : NSObjectProtocol {
    func popupViewWillShow(_ popupView: PAPopupContainerView)
    func popupViewDidShow(_ popupView: PAPopupContainerView)
    func popupViewWillHide(_ popupView: PAPopupContainerView)
    func popupViewDidHide(_ popupView: PAPopupContainerView)
}

/** 底部弹窗视图的载体(父类), 抽象公共组件和动画 */
class PAPopupContainerView: UIView {
    
    static var defaultContentHeight = UIScreen.main.bounds.height * 0.65
    
    var animationDuration: TimeInterval = 0.25
    var coverAlpha: CGFloat = 0.2
    
    fileprivate var contentHeight = defaultContentHeight
    fileprivate var titleAreaHeight: CGFloat = (UIScreen.main.bounds.width == 320) ? 44 : 50
    
    fileprivate var cover = UIView()
    var contentView       = UIToolbar()
    lazy var closeButton  = UIButton(type: .system)
    lazy var titleLabel   = UILabel()
    fileprivate lazy var titleSeparator = UIImageView()
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    fileprivate var isShowing = false
    
    weak var delegate : PAPopupContainerViewDelegate?
    var willShowAction: ((PAPopupContainerView) -> Swift.Void)?
    var didShowAction : ((PAPopupContainerView) -> Swift.Void)?
    var willHideAction: ((PAPopupContainerView) -> Swift.Void)?
    var didHideAction : ((PAPopupContainerView) -> Swift.Void)?
    
    required init(contentHeight: CGFloat = defaultContentHeight, title: String? = nil) {
        super.init(frame: .zero)
        if contentHeight > 0.5 {
            self.contentHeight = contentHeight
        }
        
        addSubview(cover)
        cover.alpha = coverAlpha
        cover.backgroundColor = .black
        cover.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(coverTapped)))
        
        addSubview(contentView)
        
        if let title = title {
            contentView.addSubview(titleLabel)
            titleLabel.text = title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            titleLabel.textColor = .black
            titleLabel.textAlignment = .center
        
            contentView.addSubview(closeButton)
            closeButton.tintColor = UIColor.paOrangeColor()
            closeButton.setImage(UIImage(named: "ic_close_red"), for: .normal)
            closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
            
            contentView.addSubview(titleSeparator)
            titleSeparator.layer.backgroundColor = UIColor.lightGray.cgColor
        }
        
        addSubview(indicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        didSet {
            let padding_10: CGFloat = 10
            
            cover.frame = bounds
            contentView.frame = CGRect(x: 0, y: frame.height - contentHeight, width: frame.width, height: contentHeight)
            
            if titleLabel.superview != nil {
                closeButton.frame = CGRect(x: 2, y: 0, width: titleAreaHeight, height: titleAreaHeight)
                
                let titleLabelHeight = titleLabel.sizeThatFits(PADeviceSize.greatestSize).height
                let titleLabelX      = closeButton.frame.maxX + padding_10
                let titleLabelY      = (titleAreaHeight - titleLabelHeight)/2.0
                let titleLabelWidth  = frame.size.width - 2 * titleLabelX
                titleLabel.frame     = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelWidth, height: titleLabelHeight)
                
                titleSeparator.frame = CGRect(x: 0, y: titleAreaHeight - PADeviceSize.separatorSize, width: frame.width, height: PADeviceSize.separatorSize)
            }
            
            indicator.center = contentView.center
        }
    }
}

extension PAPopupContainerView {
    
    func show(animated: Bool = true, onView view: UIView) {
        guard isShowing == false else { return }
        
        if self.delegate?.responds(to: #selector(PAPopupContainerViewDelegate.popupViewWillShow)) == true {
            self.delegate?.popupViewWillShow(self)
        }
        self.willShowAction?(self)
        
        let didShowOperation: () -> Swift.Void = {
            if self.delegate?.responds(to: #selector(PAPopupContainerViewDelegate.popupViewDidShow)) == true {
                self.delegate?.popupViewDidShow(self)
            }
            self.didShowAction?(self)
        }
        
        view.addSubview(self)
        frame = view.bounds
        if animated == false {
            isShowing = true
            didShowOperation()
        } else {
            contentView.transform = CGAffineTransform(translationX: 0, y: contentHeight)
            cover.alpha = 0
            let coverFinalFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - contentHeight)
            UIView.animate(withDuration: animationDuration, animations: {
                self.contentView.transform = .identity
                self.cover.alpha = self.coverAlpha
                self.cover.frame = coverFinalFrame
            }, completion: { (_) in
                self.isShowing = true
                didShowOperation()
            })
        }
    }
    
    func hide(animated: Bool = true) {
        guard isShowing == true else { return }
        
        if self.delegate?.responds(to: #selector(PAPopupContainerViewDelegate.popupViewWillHide)) == true {
            self.delegate?.popupViewWillHide(self)
        }
        self.willHideAction?(self)
        
        let didHideOperation: () -> Swift.Void = {
            if self.delegate?.responds(to: #selector(PAPopupContainerViewDelegate.popupViewDidHide)) == true {
                self.delegate?.popupViewDidHide(self)
            }
            self.didHideAction?(self)
        }
        
        indicator.stopAnimating()
        if animated == false {
            self.removeFromSuperview()
            self.isShowing = false
            didHideOperation()
        } else {
            UIView.animate(withDuration: animationDuration, animations: {
                self.contentView.transform = CGAffineTransform(translationX: 0, y: self.contentHeight)
                self.cover.alpha = 0
                self.cover.frame = self.bounds
            }, completion: { (_) in
                self.removeFromSuperview()
                self.contentView.transform = .identity
                self.cover.alpha = self.coverAlpha
                self.isShowing = false
                didHideOperation()
            })
        }
    }
    
    @objc fileprivate func closeButtonClicked() {
        hide()
    }
    
    @objc fileprivate func coverTapped() {
        hide()
    }
}
