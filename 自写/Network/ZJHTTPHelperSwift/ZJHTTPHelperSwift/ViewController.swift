//
//  ViewController.swift
//  ZJHTTPHelperSwift
//
//  Created by luozhijun on 2016/12/14.
//  Copyright © 2016年 RickLuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor(white: 0.75, alpha: 1)
        view.backgroundColor = .blue
        
        let containerView = UIView()
        let effectView = VisualEffectView(effect: UIBlurEffect(style: .light))
        containerView.addSubview(effectView)
        containerView.frame = CGRect(x: 100, y: 100, width: 200, height: 40)
        effectView.frame = CGRect(x: 0.5, y: 0.5, width: 199, height: 39)
        effectView.layer.cornerRadius = 5
        effectView.layer.masksToBounds = true
        effectView.colorTint = .green
        effectView.blurRadius = 10
//        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.7
        view.addSubview(containerView)
        
        let blurView = UIToolbar()
        blurView.frame = CGRect(x: 100, y: 200, width: 200, height: 40)
        blurView.layer.cornerRadius = 10
        blurView.layer.masksToBounds = true
//        blurView.layer.shadowOffset = CGSize(width: 1, height: 1)
//        blurView.layer.shadowColor = UIColor.black.cgColor
//        blurView.layer.shadowOpacity = 0.7
        view.addSubview(blurView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let appearance = HUDAppearance.default
        //appearance.fullScreenToCoverNavigationBar = true
        //HUDHelper.show(error: "操作成功", on: view)
//        let hud = HUDHelper.show(message: "哈哈啊哈哈哈哈")
//        hud.hide(animated: true, after: 3)
        HUDHelper.show(success: "操作成功")
    }
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


