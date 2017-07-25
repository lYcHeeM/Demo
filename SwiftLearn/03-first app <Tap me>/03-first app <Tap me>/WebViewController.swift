//
//  WebViewController.swift
//  03-first app <Tap me>
//
//  Created by luozhijun on 15/10/15.
//  Copyright © 2015年 luozhijun. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    weak var _webView:UIWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let webView = UIWebView(frame: self.view.bounds)
        webView.delegate = self
        webView.scalesPageToFit = true
        self.view.addSubview(webView)
        _webView = webView
        
        let urlString = "https://test2-www.stg.1qianbao.com:7443/api/newAuth?response_type=code&client_id=900000009498&redirect_uri=http://success&version=1.0&requestMsg=Wi7MUd650sGIHdh1/vCcky21qhE/k/V9fZi3nX0TZYGRl0qW52//ni33VvJbKjB3WOLZ1Csq+S+DL7B5iKWjfqU1uXvCLyu3ACA2J01oSjLZZdR0Q8ghReqKtOs6UmKbwC2uM0i8zO3/ofg+cmkWLebuKGSj7VMbtStawfmy9CpocGcHJQHCFIkc86+RxafzffD3x8jIK/Lr9r+Pk2r3xeTmCAZBnW/k4TzcjMG89lbpdNkmdSqXgSmld+acBoEk/3Tx9at48z3MiFGnNwc/RGuRaoayeC0lGKMvlHjGgrHX5freO6ttKNV4jsX8p90Qhxb5ZuGHyZoaefnS/07HAw=="
        let request = NSURLRequest(URL: NSURL(string: urlString)!)
        _webView.loadRequest(request)
    }
}
