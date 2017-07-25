//: Playground - noun: a place where people can play

import UIKit

var a = 10

// OC写法
//wihile (a) {
//
//}

// swift

// 1> while后的括号可省略
// 2> 与if一样, while后的判断条件必须为Bool类型, 不支持非0即真

while a > 0 {
    print(a)
    a -= 1
}

// do while --> repeat while
repeat {
    a += 1
    print(a)
} while a > 10