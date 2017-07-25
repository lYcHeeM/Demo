//
//  main.swift
//  GCD_ConcurrentQueue
//
//  Created by luozhijun on 2016/10/17.
//  Copyright © 2016年 RickLuo. All rights reserved.
//

import Foundation
import Dispatch

print("Hello, World!")

func printNum() {
    for i in 0..<10 {
        print(i)
    }
}

let queue = DispatchQueue(label: "test", qos: .default, attributes: .concurrent)

for _ in 0..<5 {
    queue.async {
        printNum()
    }
}

dispatchMain()

