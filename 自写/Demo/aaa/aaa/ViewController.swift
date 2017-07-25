//
//  ViewController.swift
//  aaa
//
//  Created by luozhijun on 2017/6/7.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightView: UIImageView? = UIImageView()
        let leftView : UIImageView? = UIImageView()
        
        // 编译时间 > 300ms
        let size1 = CGSize(width: view.frame.size.width + (rightView?.bounds.width ?? 0) + (leftView?.bounds.width ?? 0) + 22, height: view.bounds.height)
        
        // 编译时间: 32.4ms
        var padding: CGFloat = 22
        if let rightView = rightView {
            padding += rightView.bounds.width
        }
        
        if let leftView = leftView {
            padding += leftView.bounds.width
        }
        let size2 = CGSize(width: view.frame.size.width + padding, height: view.bounds.height)
        
        
        print(size1, size2)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboradWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func viewTapped() {
        view.endEditing(true)
    }

    func keyboardWillShow(sender: Notification) {
        print(sender.userInfo)
        var keyboardHeight: CGFloat = 260
        var animationDuration: TimeInterval = 0.25
        if let keyboardFrame = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = keyboardFrame.height
        }
        if let ad = sender.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
            animationDuration = ad
        }
        var animationCurve: Int = 0
        if let ac = sender.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Int {
            animationCurve = ac
        }
        UIView.animate(withDuration: animationDuration, delay: 0, options: UIViewAnimationOptions(rawValue: UInt(animationCurve << 16)), animations: {
            self.textView?.frame.size.height -= keyboardHeight
        }, completion: nil)
    }
    
    func keyboradWillHide(sender: Notification) {
        print(sender.userInfo)
        var keyboardHeight: CGFloat = 260
        var animationDuration: TimeInterval = 0.25
        if let keyboardFrame = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = keyboardFrame.height
        }
        if let ad = sender.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
            animationDuration = ad
        }
        var animationCurve: Int = 0
        if let ac = sender.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Int {
            animationCurve = ac
        }
        UIView.animate(withDuration: animationDuration, delay: 0, options: UIViewAnimationOptions(rawValue: UInt(animationCurve << 16)), animations: {
            self.textView?.frame.size.height += keyboardHeight
        }, completion: nil)
    }
}

