//
//  MethodExchangeController.swift
//  ObjectiveCRutimeDemo
//
//  Created by luozhijun on 2017/3/17.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

class MethodExchangeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tv = UITextView()
        tv.backgroundColor = UIColor.lightGray
        view.addSubview(tv)
        tv.frame = CGRect(x: 100, y: 160, width: 300, height: 60)
        
        let tf = UITextField()
        tf.backgroundColor = UIColor.lightGray
        view.addSubview(tf)
        tf.frame = CGRect(x: 100, y: 230, width: 300, height: 60)
        
        let sb = UISearchBar()
        sb.backgroundColor = UIColor.lightGray
        view.addSubview(sb)
        sb.frame = CGRect(x: 100, y: 300, width: 300, height: 60)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("----viewWillAppear")
    }
}

//MARK: - Swizzle ViewWillAppear
extension MethodExchangeController {
    override open class func initialize() {
        // `===` 类型相同且值相同为真, 且只有在类型相同之后才会比较值是否相同
        guard self === MethodExchangeController.self else {
            return
        }
        DispatchQueue.once(token: "MethodExchangeController") {
            let originalSEL = #selector(MethodExchangeController.viewWillAppear)
            let swizzledSEL = #selector(MethodExchangeController.swizzledViewWillAppear)

            let originalMethod = class_getInstanceMethod(self, originalSEL)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSEL)

            //let didAddMethod = class_addMethod(self, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))

            //if didAddMethod {
                //class_replaceMethod(self, swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            //} else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            //}
        }
    }

    private dynamic func swizzledViewWillAppear(animated: Bool) {
        self.swizzledViewWillAppear(animated: animated)
        print("----swizzledViewWillAppear")
    }
}

/// 虽然copy\paste函数是定义在UIControl的, 但实践发现直接hook UIControl的这些函数无效, 所以区在具体的子类hook, 但这样会有很多冗余代码
extension UITextField {
    private dynamic func swizzledCopy(sender: AnyObject) {
        self.swizzledCopy(sender: sender)
        print("\(NSStringFromClass(self.classForCoder))----swizzledCopy")
    }
    
    override open class func initialize() {
        // `===` 类型相同且值相同为真, 且只有在类型相同之后才会比较值是否相同
        guard self === UITextField.self else {
            return
        }
        DispatchQueue.once(token: "UITextField__swizzled") {
            let originalSEL1 = #selector(UITextField.copy(_:))
            let swizzledSEL1 = #selector(UITextField.swizzledCopy)
            
            let originalMethod1 = class_getInstanceMethod(self, originalSEL1)
            let swizzledMethod1 = class_getInstanceMethod(self, swizzledSEL1)
            
            //let didAddMethod = class_addMethod(self, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            //if didAddMethod {
            //class_replaceMethod(self, swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            //} else {
            method_exchangeImplementations(originalMethod1, swizzledMethod1)
            //}
            
            
            let originalSEL2 = #selector(UITextField.paste(_:))
            let swizzledSEL2 = #selector(UITextField.swizzledPaste)
            
            let originalMethod2 = class_getInstanceMethod(self, originalSEL2)
            let swizzledMethod2 = class_getInstanceMethod(self, swizzledSEL2)
            
            method_exchangeImplementations(originalMethod2, swizzledMethod2)
        }
    }
    
    private dynamic func swizzledPaste(sender: AnyObject) {
        self.swizzledPaste(sender: sender)
        print("\(NSStringFromClass(self.classForCoder))----swizzledPaste")
    }
}

extension UITextView {
    private dynamic func swizzledCopy(sender: AnyObject) {
        self.swizzledCopy(sender: sender)
        print("\(NSStringFromClass(self.classForCoder))----swizzledCopy")
    }
    
    override open class func initialize() {
        // `===` 类型相同且值相同为真, 且只有在类型相同之后才会比较值是否相同
        guard self === UITextView.self else {
            return
        }
        DispatchQueue.once(token: "UITextView__swizzled") {
            let originalSEL1 = #selector(UITextView.copy(_:))
            let swizzledSEL1 = #selector(UITextView.swizzledCopy)
            
            let originalMethod1 = class_getInstanceMethod(self, originalSEL1)
            let swizzledMethod1 = class_getInstanceMethod(self, swizzledSEL1)
            
            //let didAddMethod = class_addMethod(self, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            //if didAddMethod {
            //class_replaceMethod(self, swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            //} else {
            method_exchangeImplementations(originalMethod1, swizzledMethod1)
            //}
            
            
            let originalSEL2 = #selector(UITextView.paste(_:))
            let swizzledSEL2 = #selector(UITextView.swizzledPaste)
            
            let originalMethod2 = class_getInstanceMethod(self, originalSEL2)
            let swizzledMethod2 = class_getInstanceMethod(self, swizzledSEL2)
            
            method_exchangeImplementations(originalMethod2, swizzledMethod2)
        }
    }
    
    private dynamic func swizzledPaste(sender: AnyObject) {
        self.swizzledPaste(sender: sender)
        print("\(NSStringFromClass(self.classForCoder))----swizzledPaste")
    }
}

extension UISearchBar {
    private dynamic func swizzledCopy(sender: AnyObject) {
        self.swizzledCopy(sender: sender)
        print("\(NSStringFromClass(self.classForCoder))----swizzledCopy")
    }
    
    override open class func initialize() {
        // `===` 类型相同且值相同为真, 且只有在类型相同之后才会比较值是否相同
        guard self === UISearchBar.self else {
            return
        }
        DispatchQueue.once(token: "UISearchBar__swizzled") {
            let originalSEL1 = #selector(UISearchBar.copy(_:))
            let swizzledSEL1 = #selector(UISearchBar.swizzledCopy)
            
            let originalMethod1 = class_getInstanceMethod(self, originalSEL1)
            let swizzledMethod1 = class_getInstanceMethod(self, swizzledSEL1)
            
            //let didAddMethod = class_addMethod(self, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            //if didAddMethod {
            //class_replaceMethod(self, swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            //} else {
            method_exchangeImplementations(originalMethod1, swizzledMethod1)
            //}
            
            
            let originalSEL2 = #selector(UISearchBar.paste(_:))
            let swizzledSEL2 = #selector(UISearchBar.swizzledPaste)
            
            let originalMethod2 = class_getInstanceMethod(self, originalSEL2)
            let swizzledMethod2 = class_getInstanceMethod(self, swizzledSEL2)
            
            method_exchangeImplementations(originalMethod2, swizzledMethod2)
        }
    }
    
    private dynamic func swizzledPaste(sender: AnyObject) {
        self.swizzledPaste(sender: sender)
        print("\(NSStringFromClass(self.classForCoder))----swizzledPaste")
    }
}

//MARK: - DispatchQueue
extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    class func once(token: String, execute work: @convention(block) () -> Swift.Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        work()
    }
}
