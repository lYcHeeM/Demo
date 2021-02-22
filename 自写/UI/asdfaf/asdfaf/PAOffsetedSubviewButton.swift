//
//  PATopImageBottomTitleButton.swift
//  wanjia2B
//
//  Created by luozhijun on 2016/12/4.
//  Copyright © 2016年 pingan. All rights reserved.
//

import UIKit

/** 子视图(imageView和titleLabel)错位的button */
class PAOffsetedSubviewButton: UIButton {

    enum Style {
        case imageTopTitleBottom
        case imageRightTitleLeft
    }
    
    fileprivate var style = Style.imageTopTitleBottom
    
    /**
     *  内部图片占整个button的高度比例, 默认为0.65
     *  - note 如果小于0.01 或者 大于1 则忽略此值, 改用titleLabel所需具体高度确定image和Label的高度, 只在style为'imageTopTitleBottom'有效
     */
    var imageHeightRatio: CGFloat = 0.65 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    /**
     只在style为'imageRightTitleLeft'有效, 如果≤0, 则使用图片默认size
     */
    var imageWidthRatio: CGFloat = 0 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    /**
     只在style为'imageRightTitleLeft'有效, 默认为3.0; 如果≤0, 则取0.
     */
    var horizontalGapBetweenImageViewAndTitleLabel: CGFloat = 3.0
    
    var imageRounded = false {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    init() {
        super.init(frame: .zero)
        baseSetting()
    }
    
    init(imageHeightRatio: CGFloat = 0.65, imageWidthRatio: CGFloat = 0, imageRounded: Bool = false, style: Style) {
        super.init(frame: .zero)
        self.style = style
        baseSetting()
        self.setValue(NSNumber(value: UIButtonType.system.rawValue), forKey: "buttonType")
        self.imageHeightRatio = imageHeightRatio
        self.imageRounded = imageRounded
        imageView?.clipsToBounds = imageRounded
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseSetting()
    }
    
    private func baseSetting() {
        imageView?.contentMode    = .scaleAspectFit
        titleLabel?.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let imageView = imageView, let titleLabel = titleLabel else { return }
        
        let constraintSize = CGSize(width: frame.width, height: frame.height)
        
        let titleLabelNeedsSize = titleLabel.sizeThatFits(constraintSize)
        var titleH: CGFloat = 0
        var imageH: CGFloat = 0
        var titleW: CGFloat = titleLabelNeedsSize.width
        var imageW = imageView.frame.size.width
        var imageX: CGFloat = 0
        var imageY: CGFloat = imageView.frame.origin.y
        var titleX: CGFloat = (frame.width - contentEdgeInsets.left - titleEdgeInsets.left - titleW - imageEdgeInsets.left - imageW - contentEdgeInsets.right)/2.0
        var titleY: CGFloat = titleLabel.frame.origin.y

        if style == .imageTopTitleBottom {
            if imageHeightRatio > 0.01 && imageHeightRatio <= 1 {
                titleH = frame.size.height * (1 - imageHeightRatio)
                imageH = frame.size.height * imageHeightRatio
            } else {
                titleH = titleLabelNeedsSize.height
                imageH = frame.size.height - titleH
            }
            // (imageView多余空白/2.0 + titleLabel多余空白/2.0)/4.0
            let imageHeightSpace = (imageH - (imageView.image?.size.height ?? imageH))/2.0
            let titleHeightSpace = (titleH - titleLabel.sizeThatFits(constraintSize).height)/2.0
            let commonMargin = (imageHeightSpace + titleHeightSpace)/4.0
            
            imageX = (frame.size.width - imageW) / 2.0
            imageY = commonMargin
            
            titleX = (frame.size.width - titleLabelNeedsSize.width) / 2.0
            titleY = frame.size.height - titleH - 2.0 * commonMargin
        } else if style == .imageRightTitleLeft {
            if imageWidthRatio > 0.01 && imageWidthRatio <= 1 {
                imageW = frame.width * imageWidthRatio
                titleW = frame.width * (1 - imageWidthRatio)
            }
            titleH = titleLabelNeedsSize.height
            imageH = imageView.frame.height
            imageX = titleX + titleLabelNeedsSize.width + imageEdgeInsets.left
        }
        
        titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
        imageView.frame = CGRect(x: imageX, y: imageY, width: imageW, height: imageH)
        if imageRounded {
            imageView.layer.cornerRadius = imageW / 2.0
        }
        
    }
}
