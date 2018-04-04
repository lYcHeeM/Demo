//
//  Person.swift
//  UnderstandAtomic
//
//  Created by luozhijun on 2018/3/27.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

import Dispatch
import Foundation

class Person {
    
    var atomaticName: String? {
        set {
            debugLogSync("setter in")
            waitingThreadCount += 1
            semaphore?.wait()
            __atomaticName = newValue
            debugLogSync("setter out")
        } get {
            semaphore = DispatchSemaphore(value: 0)
            var temp = __atomaticName
            debugLogSync("--getter in: name->\(temp!)")
            sleep(1)
            temp = __atomaticName
            debugLogSync("--wake up: name->\(temp!)")
            for _ in 0..<waitingThreadCount {
                semaphore!.signal()
            }
            semaphore = nil
            debugLogSync("++getter will out")
            return temp
        }
    }
    
    var nonatomicName: String? {
        set {
            __nonatomicName = newValue
        } get {
            var temp = __nonatomicName
            debugLogSync("--getter in: name->\(temp!)")
            sleep(1)
            temp = __nonatomicName
            debugLogSync("--wake up: name->\(temp!)")
            debugLogSync("++getter will out")
            return temp
        }
    }
    
    private var semaphore: DispatchSemaphore?
    private var waitingThreadCount: Int = 0
    
    private var __atomaticName : String?
    private var __nonatomicName: String?
}
