//
//  ViewController2.swift
//  TestSafeArea
//
//  Created by luozhijun on 2017/10/10.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    var subview1 = UIView()
    var subview2 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "title"
        
        subview1.backgroundColor = UIColor.blue
        view.addSubview(subview1)
        subview1.frame = view.bounds

        subview2.backgroundColor = UIColor.red
        subview2.alpha = 0.5
        subview2.frame = CGRect(x: 10, y: 60, width: 300, height: 400)
        view.addSubview(subview2)
        
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        if #available(iOS 11, *) {
            let searchVc = UISearchController(searchResultsController: nil)
            searchVc.isActive = true
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.searchController = searchVc
            navigationItem.hidesSearchBarWhenScrolling = true
            
        }
        
        if #available(iOS 11, *) {
            print(view.safeAreaInsets)
            print("======")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11, *) {
            print(view.safeAreaInsets)
            print(subview1.safeAreaInsets)
            // subview2的safeAreaInsets只是它被其他诸如bars的view盖住的部分
            print(subview2.safeAreaInsets)
        }
    }

}
