//: Playground - noun: a place where people can play

import UIKit

// 元组也是用于应用一组数据
// 一般用于包装函数返回值

let tuple = ("Faker", "The shy", 123)
tuple.0
tuple.1

// 最常用方式
let tuple1 = (name: "Faker", age: 17)
tuple1.name
tuple1.age

let (name, age) = ("Faker", 17)
name
age
