//
//  UImageView+Extension.swift
//  wanjia2B
//
//  Created by luozhijun on 2017/2/14.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit

extension UIImageView {
    /// 不触发离屏渲染地使imageView拥有圆角.
    /// 如果该过程成功, 则返回新的image, 否则返回nil
    @discardableResult
    func roundingImage(forRadius cornerRadius: CGFloat, atCorners corners: UIRectCorner = .allCorners, contentMode: UIViewContentMode = .scaleAspectFill, sizeToFit: CGSize = CGSize.zero) -> UIImage? {
        self.contentMode = contentMode
        
        var constraintSize = sizeToFit
        if constraintSize == .zero {
            constraintSize = bounds.size
        }
        let constraintRect = CGRect(x: 0, y: 0, width: constraintSize.width, height: constraintSize.height)
        
        UIGraphicsBeginImageContextWithOptions(constraintSize, false, UIScreen.main.scale)
        var roundedImage: UIImage?
        if let context = UIGraphicsGetCurrentContext() {
            context.addPath(UIBezierPath(roundedRect: constraintRect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath)
            context.clip()
            layer.render(in: context)
            roundedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        if roundedImage != nil {
            image = roundedImage
        }
        return roundedImage
    }
}
