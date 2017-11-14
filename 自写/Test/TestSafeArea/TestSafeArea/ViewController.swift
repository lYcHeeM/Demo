//
//  ViewController.swift
//  TestSafeArea
//
//  Created by luozhijun on 2017/10/10.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "111", style: .plain, target: self, action: #selector(itemClicked))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.purple
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
            // 发现additionalSafeAreaInsets不接受负值, 但contentInset可接受.
//            additionalSafeAreaInsets = UIEdgeInsets(top: 100, left: 0, bottom: 44, right: 0)
//            tableView.contentInset.top = 100
//            tableView.contentInset.bottom = 44
        } else {
//            tableView.contentInset.top = 100
//            tableView.contentInset.bottom = 44
        }
        printInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printInfo()
//        tableView.contentInset.top += 60
//        tableView.contentOffset.y = -tableView.contentInset.top
//        printInfo()
        // 增加顶部滚动区域且令scrollView马上滑动相应距离的方法
        if #available(iOS 11.0, *) {
            additionalSafeAreaInsets.top += 60
        } else {
            tableView.contentInset.top += 60
            tableView.contentOffset.y = -tableView.contentInset.top
        }
    }
    
    func printInfo() {
        if #available(iOS 11, *) {
            print(tableView.safeAreaInsets)
            print(tableView.adjustedContentInset)
        }
        print(tableView.contentInset)
        print(tableView.contentOffset)
        print("------")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "哈哈"
        return cell
    }
    
    @objc func itemClicked() {
        navigationController?.pushViewController(ViewController2(), animated: true)
    }
}

