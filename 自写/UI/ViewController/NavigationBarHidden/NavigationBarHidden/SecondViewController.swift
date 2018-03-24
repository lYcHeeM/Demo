//
//  SecondViewController.swift
//  NavigationBarHidden
//
//  Created by luozhijun on 2017/12/14.
//  Copyright © 2017年 luozhijun. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    var isIPHONE_X: Bool {
        return UIScreen.instancesRespond(to: #selector(getter: UIDynamicItem.bounds)) ? CGSize(width: 375, height: 812).equalTo(UIScreen.main.bounds.size) : false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Second"
        view.backgroundColor = UIColor.purple
        
        let navigationHeight: CGFloat = 44 + UIApplication.shared.statusBarFrame.size.height
        
        let fakeNavibar = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        fakeNavibar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: navigationHeight)
        view.addSubview(fakeNavibar)
        
        let titleLable = UILabel()
        titleLable.font = UIFont.boldSystemFont(ofSize: 17)
        titleLable.text = self.title
        titleLable.sizeToFit()
        titleLable.frame.origin = CGPoint.init(x: (view.frame.width - titleLable.frame.width)/2, y: (44 - titleLable.frame.height)/2 + UIApplication.shared.statusBarFrame.size.height)
        fakeNavibar.contentView.addSubview(titleLable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
