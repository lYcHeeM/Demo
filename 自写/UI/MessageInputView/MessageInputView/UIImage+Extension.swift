//
//  UIImage+Extension.swift
//  wanjia2B
//
//  Created by luozhijun on 2016/10/26.
//  Copyright © 2016年 pingan. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    /// 用颜色创建一张图片
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    /// 返回一张有圆角的图片
    func roundingCorner(forRadius radius: CGFloat, atCorners corners: UIRectCorner = .allCorners, contentMode: UIViewContentMode = .scaleAspectFill, sizeToFit: CGSize = .zero) -> UIImage? {
        var usingSize = sizeToFit
        if usingSize == .zero {
            usingSize = self.size
        }
        let boundingRect = CGRect(x: 0, y: 0, width: usingSize.width, height: usingSize.height)
        let tempImageView = UIImageView(image: self)
        tempImageView.bounds = boundingRect
        return tempImageView.roundingImage(forRadius: radius, atCorners: corners, contentMode: contentMode, sizeToFit: sizeToFit)
    }
    
    /// 返回一张可拉伸的图片, 参数分别是图片宽度的一半和图片高度的一半
    var stretchable: UIImage {
        return self.stretchableImage(withLeftCapWidth: Int(self.size.width/2.0), topCapHeight: Int(self.size.height/2.0))
    }
    
    /// 防止头像旋转
    func fixRevolve() -> UIImage{
        if self.imageOrientation == .up{
            return self
        }
        
        var transform:CGAffineTransform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .down,.downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .left,.leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        case .right,.rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
        default:
            break
        }
        switch self.imageOrientation {
        case .upMirrored,.downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored,.rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        let ctx:CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                      bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                      space: self.cgImage!.colorSpace!,
                                      bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!
        ctx.concatenate(transform)
        switch self.imageOrientation {
        case .leftMirrored,.left,.rightMirrored,.right:
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        }
        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)
        return img
        
    }
}

