//
//  main.swift
//  UnderstandAtomic
//
//  Created by luozhijun on 2018/3/27.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

import Foundation

print("Hello, World!")

let queue1 = DispatchQueue(label: "atomic_test_queue", qos: .default, attributes: .concurrent)
let queue2 = DispatchQueue(label: "nonatomic_test_queue", qos: .default, attributes: .concurrent)

let person = Person()
person.atomaticName = "Rick"
DispatchQueue.global().async {
    let _ = person.atomaticName
}
for _ in 0..<5 {
    queue1.async {
        person.atomaticName = "Rick_set"
    }
}



//person.nonatomicName = "nonatomicName"
//DispatchQueue.global().async {
//    let _ = person.nonatomicName
//}
//for _ in 0..<5 {
//    queue1.async {
//        person.nonatomicName = "nonatomicName_set"
//    }
//}

let runloop = RunLoop.current
runloop.add(NSMachPort(), forMode: RunLoopMode.defaultRunLoopMode)
runloop.run()

debugLog("end\n")
