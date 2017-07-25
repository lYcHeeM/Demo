//
//  main.swift
//  03_String
//
//  Created by luozhijun on 16/3/23.
//  Copyright © 2016年 Fujica. All rights reserved.
//

import Foundation

print("Hello, World!")

// 字符串是value类型, 使用时编译器会拷贝一份新值

// 连接字符串
var mutableString = "0123456789\(1)"
//mutableString.appendContentsOf("23")
mutableString += "23"
mutableString.append(Character("#"))

// 打印每个字符
for char in mutableString.characters {
    print(char)
}
print()

// 用仅含单个字符的字符串初始化一个Character类型的变量
var exclamationMark: Character = "!"
print(exclamationMark)

// 字符串初始化
    // empty string
let emptyString1 = ""
let emptyString2 = String()
var nilString: String?
print(emptyString1)
print(emptyString2)
print(nilString)

    // 以字符数组初始化
let catCharacters: [Character] = ["C", "a", "t", "🐱"];
var catString = String(catCharacters)
print(catString)

let pi = 3.14
let stringInterprolation = "Pi is \(pi), at the left of the decimal is \(Int(pi))"
print(stringInterprolation)



