//: Playground - noun: a place where people can play

import UIKit

let str = "hello world"

//MARK:- 遍历
for char in str.characters {
    print(char)
}

//MARK: - 拼接

// 连接
let str1 = "I"
let str2 = "am"
let str3 = "Rick"
let myName = str1 + " " + str2 + " " + str3 + "."

// 和其他标识符间的拼接
let name = "Rick"
let age = 24
let height = 170
let personalInfo = "my name is \(name), age is \(age), height is \(height)"

// 格式拼接
let minute = 2
let second = 15
let time = String(format: "%02d:%02d", arguments: [minute, second])


//MARK: - 截取
let urlString = "www.baidu.com"
//let head = urlString.substringFromIndex(String.CharacterView)
// 上面的方法较为麻烦, 过来人建议先转为NSString
let head = (urlString as NSString).substringToIndex(3)
let middle = (urlString as NSString).substringWithRange(NSMakeRange(4, 5))
let tail = (urlString as NSString).substringFromIndex(10)

