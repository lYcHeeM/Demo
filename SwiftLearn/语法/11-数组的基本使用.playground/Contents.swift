//: Playground - noun: a place where people can play

import UIKit

//MARK: - 1.创建

// 1.不可变数组
let array = ["Faker", "The shy", "lYcHeeM"]
let array1 : Array<String> = ["Madlife", "Shy"]
let array2 : [String] = ["Piglet", "Doublelift"]
let array3 : [AnyObject] = ["Froggen", 123]
// AnyObject和NSObject的一点区别
// 指定类型一般用AnyObject, 创建时一般用NSObject
// 虽然也可以 let array4 : [NSObject], 但是一般不这么写

// 2.可变数组
var arrayM = [String]()
var arrayM1 = Array<String>()
var arrayM2 = ["Norlan", "Cob"]


//MARK: - 2.可变数组基本操作

// 1.增
arrayM2.append("Christerfer")

// 2.删
arrayM2.removeAtIndex(0)
arrayM2

// 3.查
arrayM2[0]

// 4.改
arrayM2[0] = "Annie"
arrayM2


//MARK: - 3.遍历

for i in 0..<array.count {
    print(array[i])
}

for item in array {
    print(item)
}

// 局部遍历
for i in 0..<2 {
    print(array[i])
}
for item in array[0..<2] {
    print(item)
}

//MARK: - 4.合并
// 只能在相同类型的数组之间使用"+"操作符合并
let array_1 = ["aaa", "bbb"]
let array_2 = ["ccc"]
let array_3 = array_1 + array_2

// 报错
// option+鼠标左键发现, array_4是[NSObject]类型, 而array_5是[String]类型
var array_4 = ["ddd", 111]
let array_5 = ["eee", "fff"]
//let array_6 = array_4 + array_5

// 其他方法合并
for item in array_5 {
    array_4.append(item)
}
array_4

