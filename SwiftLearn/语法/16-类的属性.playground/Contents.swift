//: Playground - noun: a place where people can play

import UIKit

// swift中有3种类型的属性
// 最常见的存储属性
// 计算属性
// 类属性 static

class Student: NSObject {
    // 普通的存储属性
    var name: String?
    var age: Int = 0
    var mathScore: Double = 0.0
    var gymScore: Double = 0.0
    
    // 以前的做法, 如果为了封装计算平均成绩的代码, 会使用对象方法
    func getAverageScore() -> Double {
        return (mathScore + gymScore) * 0.5
    }
    
    // 而Swift中倾向于使用叫做"计算属性"的东西
    // 通过其他方式间接得到的属性称为计算属性
    // 有个问题, 计算属性是否支持OC混编
    var averageScore: Double {
        return (mathScore + gymScore) * 0.5
    }
    
    // 类属性
    // 通过类名直接访问
    static var courseCount: Int = 0
}

let stu = Student()
stu.mathScore = 88
stu.gymScore = 77.5
stu.getAverageScore()
stu.averageScore

Student.courseCount = 2
print(Student.courseCount)

