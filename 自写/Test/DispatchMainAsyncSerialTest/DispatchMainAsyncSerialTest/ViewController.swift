//
//  ViewController.swift
//  DispatchMainAsyncSerialTest
//
//  Created by luozhijun on 2017/7/26.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var counter = 0
    var maxTime = 30
    var lock = NSLock()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// 情景1, 虽然queue是并行队列, 但在执行一个action(比如下面的printNum函数)前, 切换到串行主队列, 即使是非原子操作, 也能保证安全的执行顺序
    @IBAction func action1(_ sender: Any) {
        counter = 0
        let queue = DispatchQueue(label: "test1", qos: .default, attributes: .concurrent)
        var order = 0
        for _ in 0..<maxTime {
            let randomInterval = arc4random() % 5
            queue.async {
                order += 1
                var usingOrder = order
                sleep(randomInterval)
                DispatchQueue.main.async {
                    self.printNum(order: &usingOrder)
                }
            }
        }
    }
    
    /// 情景2, 由于queue是并行队列, 非原子操作的执行顺序将乱套
    @IBAction func action2(_ sender: Any) {
        counter = 0
        let queue = DispatchQueue(label: "test2", qos: .default, attributes: .concurrent)
        for _ in 0..<maxTime {
            let randomInterval = arc4random() % 5
            queue.async {
                sleep(randomInterval)
//                self.printNum()
            }
        }
    }
    
    /// 情景3, 加上线程锁后, 非原子操作变成了原子操作, 结果和情景1一致.
    @IBAction func action3(_ sender: Any) {
        counter = 0
        let queue = DispatchQueue(label: "test3", qos: .default, attributes: .concurrent)
        for _ in 0..<maxTime {
            let randomInterval = arc4random() % 5
            queue.async {
                sleep(randomInterval)
                self.printNumAsyncSafely()
            }
        }
    }
    
    func printNum(order: inout Int) {
        counter += 1
        for i in 1...3 {
            print(i)
        }
        print("----counter: \(order)----")
    }
    
    func printNumAsyncSafely(order: Int = 0) {
        lock.lock()
        counter += 1
        for i in 1...10 {
            print(i)
        }
        print("----counter: \(order)----")
        lock.unlock()
    }
}

