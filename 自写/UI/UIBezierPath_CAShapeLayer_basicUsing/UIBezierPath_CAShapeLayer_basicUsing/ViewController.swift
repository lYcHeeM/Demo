//
//  ViewController.swift
//  UIBezierPath_CAShapeLayer_basicUsing
//
//  Created by luozhijun on 16/8/11.
//  Copyright © 2016年 LeoMaster. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var usage_1_superView : UIView!
    var usage_2_superView : UIView!
    var show_usage_1_button : UIButton!
    var show_usage_2_button : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usage_1_superView = UIView.init(frame: view.bounds)
        usage_2_superView = UIView.init(frame: view.bounds)
        
        let buttonSize = CGSizeMake(100, 50)
        
        show_usage_1_button = UIButton.init(type: .System)
        show_usage_1_button.frame = CGRectMake(10, 100, buttonSize.width, buttonSize.height)
        show_usage_1_button.addTarget(self, action: #selector(show_usage_1), forControlEvents: .TouchUpInside)
        show_usage_1_button.setTitle("usage 1", forState: .Normal)
        view.addSubview(show_usage_1_button)
        
        show_usage_2_button = UIButton.init(type: .System)
        show_usage_2_button.frame = CGRectMake(show_usage_1_button.frame.minX, show_usage_1_button.frame.maxX + 20, buttonSize.width, buttonSize.height)
        show_usage_2_button.addTarget(self, action: #selector(show_usage_2), forControlEvents: .TouchUpInside)
        show_usage_2_button.setTitle("usage 2", forState: .Normal)
        view.addSubview(show_usage_2_button)
    }
    
    func show_usage_2() {
        usage_1_superView.removeFromSuperview()
        view.insertSubview(usage_2_superView, belowSubview: show_usage_1_button)
        
        self.usage_2_1()
        self.usage_2_2()
        self.usage_2_3()
    }
    
    func show_usage_1() {
        usage_2_superView.removeFromSuperview()
        view.insertSubview(usage_1_superView, belowSubview: show_usage_1_button)
        
        struct tempStaticOnceToken {
            static var onceToken = dispatch_once_t()
        }
        var layer : CAShapeLayer = CAShapeLayer()
        dispatch_once(&tempStaticOnceToken.onceToken) {
            self.usage_1_1()
            self.usage_1_2()
            self.usage_1_3()
            self.usage_1_4()
            self.usage_1_5()
            layer = self.usage_1_6()
        }
        if layer.superlayer == nil {
            usage_1_superView.layer.addSublayer(layer)
        }
        
    }
    
    //MARK: - usage_2 animations
    /**
     animation with "strokeStart"
     */
    func usage_2_1() {
        let layer = self.usage_1_6()
        layer.removeFromSuperlayer()
        
        layer.strokeEnd = 0.0
        
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 2.0
        layer.addAnimation(animation, forKey: "")
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((animation.duration + 0.01) * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            layer.removeFromSuperlayer()
        }
        
        usage_2_superView.layer.addSublayer(layer)
    }
    
    /**
     animation with both "strokeStart" and "strokeEnd"
     */
    func usage_2_2() {
        let layer = self.usage_1_6()
        layer.removeFromSuperlayer()
        
        layer.frame.origin.y -= 50
        
        layer.strokeStart = 0.5
        layer.strokeEnd = 0.5
        
        let animation1 = CABasicAnimation.init(keyPath: "strokeStart")
        animation1.fromValue = 0.5
        animation1.toValue = 0.0
        animation1.duration = 2
        layer.addAnimation(animation1, forKey: "")
        
        let animation2 = CABasicAnimation.init(keyPath: "strokeEnd")
        animation2.fromValue = 0.5
        animation2.toValue = 1.0
        animation2.duration = animation1.duration
        layer.addAnimation(animation2, forKey: "")
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((animation1.duration + 0.01) * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            layer.removeFromSuperlayer()
        }
        
        usage_2_superView.layer.addSublayer(layer)
    }
    
    /**
     animaton with lineWidth
     */
    func usage_2_3() {
        let layer = self.usage_1_6()
        layer.removeFromSuperlayer()
        
        layer.frame.origin.y -= 2 * 50
        
        layer.strokeEnd = 0.0
        
        // 从结果看,这样似乎不行
//        UIView.animateWithDuration(2.0, animations: {
//            layer.strokeEnd = 1.0
//            layer.lineWidth = 8.0
//            }) { (finished) in
//                if finished {
//                    layer.removeFromSuperlayer()
//                }
//        }
        
        let animation = CABasicAnimation.init(keyPath: "lineWidth")
        animation.fromValue = 0.5
        animation.toValue = layer.lineWidth + 5.0
        animation.duration = 2.0
        layer.addAnimation(animation, forKey: "")
        
        let animation1 = CABasicAnimation.init(keyPath: "strokeEnd")
        animation1.fromValue = 0.0
        animation1.toValue = 1.0
        animation1.duration = animation.duration
        layer.addAnimation(animation1, forKey: "")

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((animation.duration + 0.01) * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            layer.removeFromSuperlayer()
        }
        
        usage_2_superView.layer.addSublayer(layer)
    }
    //MARK: end
    
    //MARK: - usage_1 simple graphs
    func usage_1_1() {
        let layer = CAShapeLayer()
        layer.frame = CGRectMake(100, 10, 200, 100)
        layer.backgroundColor = UIColor.redColor().CGColor
        usage_1_superView.layer.addSublayer(layer)
    }
    
    func usage_1_2() {
        let layer = CAShapeLayer()
        let path = UIBezierPath.init(rect: CGRectMake(100, 120, 200, 100))
        layer.path = path.CGPath
        // default is blackColor
        layer.fillColor = UIColor.blueColor().CGColor
        layer.strokeColor = UIColor.redColor().CGColor
        layer.lineWidth = 5.0
        usage_1_superView.layer.addSublayer(layer)
    }
    
    func usage_1_3() {
        let layer = CAShapeLayer()
        let path = UIBezierPath.init(roundedRect: CGRectMake(100, 230, 200, 100), cornerRadius: 50)
        layer.path = path.CGPath
        layer.strokeColor = UIColor.blackColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        usage_1_superView.layer.addSublayer(layer)
    }
    
    func usage_1_4() {
        let layer = CAShapeLayer()
        let rect = CGRectMake(150, 340, 100, 100)
        let rectCenter = CGPointMake(rect.minX + rect.width/2.0, rect.minY + rect.height/2.0)
        let path = UIBezierPath.init(arcCenter: rectCenter, radius: rect.width/2.0, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: true)
        layer.path = path.CGPath
        layer.strokeColor = UIColor.blackColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        usage_1_superView.layer.addSublayer(layer)
    }
    
    func usage_1_5() {
        let layer = CAShapeLayer()
        let startPoint = CGPointMake(100, 450)
        let endPoint = CGPointMake(startPoint.x + 200, startPoint.y);
        let controlPoint = CGPointMake(startPoint.x + (endPoint.x - startPoint.x)/2.0, startPoint.y + 50)
        let path = UIBezierPath()
        path.moveToPoint(startPoint)
        path.addQuadCurveToPoint(endPoint, controlPoint: controlPoint)
        layer.path = path.CGPath
        layer.strokeColor = UIColor.purpleColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        layer.lineWidth = 5.0
        layer.lineCap = kCALineCapRound
        usage_1_superView.layer.addSublayer(layer)
    }
    
    func usage_1_6() -> CAShapeLayer {
        let layer = CAShapeLayer()
        let startPoint = CGPointMake(100, 560)
        let endPoint = CGPointMake(startPoint.x + 200, startPoint.y)
        let controlPoint1 = CGPointMake(startPoint.x  + (endPoint.x - startPoint.x)/4.0, startPoint.y + 80);
        let controlPoint2 = CGPointMake(endPoint.x - (endPoint.x - startPoint.x)/4.0, startPoint.y - 80)
        let path = UIBezierPath()
        path.moveToPoint(startPoint)
        path.addCurveToPoint(endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        layer.path = path.CGPath
        layer.strokeColor = UIColor.blackColor().CGColor
        layer.lineWidth = 3.0
        layer.lineCap = kCALineCapButt
        layer.fillColor = UIColor.clearColor().CGColor
        usage_1_superView.layer.addSublayer(layer)
        return layer
    }
    //MARK: end
    
}

