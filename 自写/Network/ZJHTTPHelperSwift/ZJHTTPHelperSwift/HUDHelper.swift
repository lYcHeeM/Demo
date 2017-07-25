//
//  HUDHelper.swift
//  ZJHTTPHelperSwift
//
//  Created by luozhijun on 2016/12/14.
//  Copyright © 2016年 RickLuo. All rights reserved.
//

import UIKit

public protocol AbstractHUD {
    static func instance(with text: String, image: String?, superview: UIView?, appearance: HUDAppearance) -> AbstractHUD
    func set(appearance: HUDAppearance)
    func show(animated: Bool)
    func hide(animated: Bool, after delay: TimeInterval)
}

public extension AbstractHUD {
    var appearance: HUDAppearance { return HUDAppearance() }
}

open class HUDAppearance {
    public enum HUDMode: Int {
        init(progressHUDMode: ZJProgressHUDMode) {
            switch progressHUDMode {
            case .indeterminate:
                self = .indeterminate
            case .indeterminateCancelButton:
                self = .indeterminateCancelButton
            case .customView:
                self = .customView
            default:
                self = .indeterminate
            }
        }
        
        case indeterminate             = 0
        case indeterminateCancelButton = 1
        case customView                = 5
        case textOnly                  = 6
    }
    
    public enum HUDMargin: CGFloat {
        case indeterminate = 8
        case successError = 10
        case textOnly = 15
        case other
    }
    
    public enum HUDDismissDelay: TimeInterval {
        #if DEBUG
        case `default` = 1.5
        #else
        case `default` = 1.2
        #endif
        case successError = 1.8
    }
    
    static let `default` = HUDAppearance()
    static let successError: HUDAppearance = {
        struct Temp {
            static let appearance  = HUDAppearance()
        }
        Temp.appearance.minimumSize  = hudMinimumSize_successOrError_vertically()
        Temp.appearance.margin       = .successError
        Temp.appearance.dismissDelay = .successError

        return Temp.appearance
    }()
    
    open var title: String?
    open var detailText: String?
    open var image: UIImage?
    open var showAnimated                   = true
    open var hideAnimated                   = true
    open var dismissDelay: HUDDismissDelay  = .default
    open var dimBackground                  = false
    open var fullScreenToCoverNavigationBar = false
    open var horizontallyLayout             = false
    open var customView: UIView?
    
    open var minimumSize            = hudMinimumSize_bouthTextAndIndicator_vertically()
    open var margin: HUDMargin      = .indeterminate;
    open var cornerRadius: CGFloat  = 6
    open var opacity: CGFloat       = 0.65
    open var shadowColor: CGColor   = UIColor.black.cgColor
    open var shadowOpacity: Float   = 0.4
    open var shadowOffset           = CGSize(width: 0, height: 0.5)
    open var shadowRadius: CGFloat  = 2.0
    
    open var mode: HUDMode = .indeterminate {
        didSet {
            switch mode {
            case .indeterminate, .indeterminateCancelButton, .customView:
                margin = .indeterminate
            case .textOnly:
                margin = .textOnly
            }
        }
    }
    
    open var titleColor: UIColor = .white
    open var detailTitleColor: UIColor = .white
    open var hudBackgroundColor: UIColor? = nil
}

@objc(ZJHUDHelper) open class HUDHelper: NSObject {
    
    //MARK: - Core func
    /**
     创建一个遵循AbstractHUD协议的HUD并显示到'view'之上, HUD蒙版的宽高将和'view'保持一致. Create a HUD which has confirmed 'AbstractHUD' protocol, and show it on 'view'. The size of HUD will be the same with its superview.
     
     - parameter view:       如果为nil, 则显示在keyWindow上. HUD superview, if nil, HUD will be added on 'keyWindow'.
     - parameter appearance: HUD的外观配置. Model with which HUD appearance will be configured.
     */
    @discardableResult
    open class func show(text: String, image: String, on view: UIView?, with appearance: HUDAppearance) -> AbstractHUD {
        let hud = ZJProgressHUD.instance(with: text, image: image, superview: view, appearance: appearance) as! ZJProgressHUD
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { hud.animationType = .zoomOut }
        
        hud.show(animated: appearance.showAnimated)
        hud.hide(animated: appearance.hideAnimated, after: appearance.dismissDelay.rawValue)
        
        return hud
    }
    
    /**
     创建一个遵循AbstractHUD协议的HUD并显示到'view'之上, HUD的样式为文字+indicator, HUD蒙版的宽高将和'view'保持一致. Create a HUD which has confirmed 'AbstractHUD' protocol, and show it on 'view'. Note the style of this HUD is text with indicator, usually using when loading something. The size of HUD will be the same with its superview.
     
     - parameter view:        如果为nil, 则显示在keyWindow上. HUD superview, if nil, HUD will be added on 'keyWindow'.
     - parameter appearance:  HUD的外观配置. Model with which HUD appearance will be configured.
     - parameter cancelation: HUD上的取消按钮触发时的回调. Action which will be called when cancel button clicked.
     */
    @discardableResult
    open class func show(message: String, on view: UIView? = nil, with appearance: HUDAppearance = .default, cancelation: ((AbstractHUD) -> Void)? = nil) -> AbstractHUD {
        appearance.horizontallyLayout = true
        let hud = ZJProgressHUD.instance(with: message, image: nil, superview: view, appearance: appearance) as! ZJProgressHUD
        hud.cancelButtonTouchedUpInside = cancelation
        hud.show(animated: appearance.showAnimated)
        
        return hud
    }
    
    //MARK: - Success Error Hint
    @discardableResult
    open class func show(success: String, on view: UIView? = nil, with appearance: HUDAppearance = .successError) -> AbstractHUD {
        return show(text: success, image: "success", on: view, with: appearance)
    }
    
    @discardableResult
    open class func show(error: String, on view: UIView? = nil, with appearance: HUDAppearance = .successError) -> AbstractHUD {
        return show(text: error, image: "error", on: view, with: appearance)
    }
    
    //MARK: - Set HUD
    //open class func set(hud: AbstractHUD, image: String)
}

extension ZJProgressHUD: AbstractHUD {
    @discardableResult
    public static func instance(with text: String, image: String?, superview: UIView?, appearance: HUDAppearance) -> AbstractHUD {
        var superview = superview
        if superview == nil {
            superview = UIApplication.shared.keyWindow
        }
        appearance.title = text
        if let imageName = image {
            appearance.image = UIImage(named: "ZJMBProgressHUD.bundle/\(imageName)")
        }
        let hud = ZJProgressHUD(addedTo: superview) as ZJProgressHUD
        hud.set(appearance: appearance)
        NotificationCenter.default.post(name: NSNotification.Name.ZJHUDDidAddToSuperView, object: self)
        
        return hud
    }
    
    public func show(animated: Bool) {
        show(animated)
    }
    
    public func hide(animated: Bool, after delay: TimeInterval) {
        hide(animated, afterDelay: delay)
    }
    
    public func set(appearance: HUDAppearance) {
        labelText                      = appearance.title
        detailsLabelText               = appearance.detailText
        if let image = appearance.image {
            appearance.customView = UIImageView(image: image)
            appearance.mode = .customView
        }
        dimBackground                  = appearance.dimBackground
        fullScreenToCoverNavigationBar = appearance.fullScreenToCoverNavigationBar
        horizontallyLayout             = appearance.horizontallyLayout
        customView                     = appearance.customView
        
        minSize             = appearance.minimumSize
        margin              = appearance.margin.rawValue
        cornerRadius        = appearance.cornerRadius
        opacity             = appearance.opacity
        layer.shadowColor   = appearance.shadowColor
        layer.shadowOpacity = appearance.shadowOpacity
        layer.shadowOffset  = appearance.shadowOffset
        layer.shadowRadius  = appearance.shadowRadius
        
        mode = ZJProgressHUDMode(rawValue: appearance.mode.rawValue) ?? .indeterminate
        
        labelColor                     = appearance.titleColor
        detailsLabelColor              = appearance.detailTitleColor
        color                          = appearance.hudBackgroundColor
    }
    
    var appearance: HUDAppearance {
        let appearance = HUDAppearance()
        appearance.title                          = labelText
        appearance.detailText                     = detailsLabelText
        if let imageView = customView as? UIImageView {
            appearance.image = imageView.image
        }
        appearance.dimBackground                  = dimBackground
        appearance.fullScreenToCoverNavigationBar = fullScreenToCoverNavigationBar
        appearance.horizontallyLayout             = horizontallyLayout
        appearance.customView                     = customView
        
        appearance.minimumSize   = minSize
        appearance.margin        = HUDAppearance.HUDMargin(rawValue: margin) ?? .indeterminate
        appearance.cornerRadius  = cornerRadius
        appearance.opacity       = opacity
        appearance.shadowColor   = layer.shadowColor ?? UIColor.black.cgColor
        appearance.shadowOpacity = layer.shadowOpacity
        appearance.shadowOffset  = layer.shadowOffset
        appearance.shadowRadius  = layer.shadowRadius
        
        appearance.mode = HUDAppearance.HUDMode(progressHUDMode: mode)
        
        appearance.titleColor                     = labelColor ?? .white
        appearance.detailTitleColor               = detailsLabelColor ?? .white
        appearance.hudBackgroundColor             = color ?? .black
        
        return appearance
    }
}
