//
//  PAPlaceholderTextView.swift
//  asdfaf
//
//  Created by luozhijun on 2017/2/13.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

class PAPlaceholderTextView: UITextView {
    
    //MARK: - Properties
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    var placeholderAttributes: [NSAttributedStringKey: Any] = defaultPlaceholderAttributes {
        didSet {
            if let font = placeholderAttributes[NSAttributedStringKey.font] as? UIFont {
                placeholderLabel.font = font
            }
            if let color = placeholderAttributes[NSAttributedStringKey.foregroundColor] as? UIColor {
                placeholderLabel.textColor = color
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    var attributedPlaceholder: NSAttributedString?
    
    static private var defaultPlaceholderAttributes: [NSAttributedStringKey: Any] {
        return [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]
    }
    fileprivate var placeholderLabel = UILabel()
    
    required init(placeholder: String?, placeholderAttributes: [NSAttributedStringKey: Any] = defaultPlaceholderAttributes, textContainer: NSTextContainer?) {
        super.init(frame: .zero, textContainer: textContainer)
        self.placeholder = placeholder
        self.placeholderAttributes = placeholderAttributes
        placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = placeholderAttributes[NSAttributedStringKey.font] as! UIFont
        placeholderLabel.textColor = placeholderAttributes[NSAttributedStringKey.foregroundColor] as! UIColor
        placeholderLabel.tag = 1
        placeholderLabel.numberOfLines = 0
        addSubview(placeholderLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: Notification.Name.UITextViewTextDidChange, object: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let placeholderX: CGFloat = 5
        let placeholderY: CGFloat = 6
        let palceholderMaxWidth = frame.width - 2 * placeholderX
        let needSize = placeholderLabel.sizeThatFits(CGSize(width: palceholderMaxWidth, height: CGFloat.greatestFiniteMagnitude))
        placeholderLabel.frame = CGRect(x: placeholderX, y: placeholderY, width: needSize.width, height: needSize.height)
    }
    
    @objc private func textDidChange() {
        if text.characters.count > 0 {
            placeholderLabel.isHidden = true
        } else {
            placeholderLabel.isHidden = false
        }
    }
}
