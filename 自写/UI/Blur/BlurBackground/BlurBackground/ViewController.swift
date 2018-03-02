//
//  ViewController.swift
//  BlurBackground
//
//  Created by luozhijun on 2017/12/14.
//  Copyright © 2017年 luozhijun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgImg = UIImageView(image: #imageLiteral(resourceName: "bg"))
        view.addSubview(bgImg)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addBlurredBg()
    }
    
    func addBlurredBg() {
        if let screenShot = UIApplication.shared.keyWindow?.screenshot() {
            let blurredImage = screenShot.applyBlur(withRadius: 5, blurType: BOXFILTER, tintColor: UIColor.black.withAlphaComponent(0.2), saturationDeltaFactor: 1.8, maskImage: nil)
            let imageView = UIImageView(image: blurredImage)
            view.addSubview(imageView)
        }
    }
    
    func webViewBlurBgText() {
        let webView = UIWebView()
        view.addSubview(webView)
        webView.frame = view.bounds
        let url = URL(string: "http://www.wodexiangce.cn/photo_technology.faces")!
        let req = URLRequest(url: url)
        webView.delegate = self
        webView.loadRequest(req)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        addBlurredBg()
    }
}


