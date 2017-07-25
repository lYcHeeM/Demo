//: Playground - noun: a place where people can play

import UIKit

// swift中的类允许没有父类
class Person {
    var name: String?
    // 等价于 var name: String? = nil
}

class Student: NSObject {
    var age: Int = 0
    var name: String?
    
    // swift中重写父类方法需要标明override
    // 重写这个方法即可避免set...undefinedkey错误
    override func setValuesForKeysWithDictionary(keyedValues: [String : AnyObject]) {}
}

// 和OC一样, 只要继承NSObject, 对属性的赋值可以用点语法, 也可用KVC

let stu = Student()
stu.age = 18
stu.name = "Lychee"

// 继承NSObject的好处, 可以使用KVC
let stu1 = Student()
stu1.setValuesForKeysWithDictionary(["age": 20, "name": "Faker", "height": 1.65])


