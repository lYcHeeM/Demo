//
//  ViewController.swift
//  MessageInputView
//
//  Created by luozhijun on 2017/6/20.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var inputView1: MessageInputView!
    var view1: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 44)
        tableView.backgroundColor = UIColor.orange
        tableView.delegate   = self
        tableView.dataSource = self
        
        
        let frame = CGRect(x: 0, y: view.frame.height - 44, width: view.frame.width, height: 44)
        inputView1 = MessageInputView(style: .style1, frame: frame)
        view.addSubview(inputView1)
        inputView1.frameAffectingView = tableView
    }
    
    func test1() {
        let btn1 = UIButton(type: .contactAdd)
        view.addSubview(btn1)
        btn1.frame = CGRect(x: 100, y: 100, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(action1), for: .touchUpInside)
        
        let btn2 = UIButton(type: .contactAdd)
        view.addSubview(btn2)
        btn2.frame = CGRect(x: 150, y: 100, width: 30, height: 30)
        btn2.addTarget(self, action: #selector(action2), for: .touchUpInside)
        
        view1 = UIView()
        view1.backgroundColor = UIColor.black
        self.view.addSubview(view1)
        view1.frame = CGRect(x: 120, y: 300, width: 100, height: 200)
//        setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 1), forView: view1)
//        view1.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
    }
    
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
    @objc func action1() {
        let deltaHeight = 30 - self.inputView1.frame.size.height
        UIView.animate(withDuration: 1) { 
            self.inputView1.frame.size.height = 30
            self.inputView1.frame.origin.y   -= deltaHeight
        }
    }
    
    @objc func action2() {
        let deltaHeight = 30 - self.view1.frame.size.height
        UIView.animate(withDuration: 1) {
            self.view1.frame.size.height = 30
            self.view1.frame.origin.y   -= deltaHeight
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) { 
            self.view1.frame.size.height = 200
            self.view1.frame.origin.y   += deltaHeight
        }
    }
    
    func test() {
        let rightImageView = UIImageView(frame: CGRect(x: 220, y: 100, width: 90, height: 160))
        rightImageView.image = UIImage(named: "messageView_more")
        let button = UIButton()
        button.backgroundColor = UIColor.red
        
        button.frame = CGRect(x: 20, y: 110, width: 40, height: 40)
        rightImageView.addSubview(button)
        view.addSubview(rightImageView)
        
        let rotationAnim4 = CABasicAnimation(keyPath: "position.y")
        rotationAnim4.fromValue = 100
        rotationAnim4.toValue = 100 + rightImageView.bounds.height / 4
        rotationAnim4.isRemovedOnCompletion = false
        
        
        let rotationAnim5 = CABasicAnimation(keyPath: "bounds")
        rotationAnim5.fromValue = rightImageView.bounds
        rotationAnim5.toValue = CGRect(x: rightImageView.bounds.origin.x, y: rightImageView.bounds.origin.y, width: rightImageView.bounds.width, height: rightImageView.bounds.height / 2)
        rotationAnim5.isRemovedOnCompletion = false
        
        
        let group = CAAnimationGroup()
        group.animations = [rotationAnim4,rotationAnim5]
        group.duration = 2.0
        rightImageView.layer.add(group, forKey: nil)
    }
    
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
           cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "test - \(indexPath.row)"
        return cell!
    }
}
