//
//  SecondViewController.swift
//  ProtectNavigationPanGesture
//
//  Created by luozhijun on 2018/2/27.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = MyWebView()
        let req = URLRequest(url: URL(string: "http://caai.cn/index.php?s=/Home/Article/detail/id/469.html&from=timeline&isappinstalled=0")!)
        webView.loadRequest(req)
        view.addSubview(webView)
        webView.frame = view.bounds
        
//        if let panGes = firstPanGesOfView(view: navigationController!.view) {
//            for subView in webView.subviews {
//                if let panGes2 = firstPanGesOfView(view: subView) {
//                    panGes2.require(toFail: panGes)
//                }
//            }
//        }
    }
    
    
    func firstPanGesOfView(view: UIView) -> UIPanGestureRecognizer? {
        guard let ges = view.gestureRecognizers else { return nil }
        for g in ges {
            if let g = g as? UIPanGestureRecognizer {
                return g
            }
        }
        return nil
    }
}


class MyWebView: UIWebView {
    
}
