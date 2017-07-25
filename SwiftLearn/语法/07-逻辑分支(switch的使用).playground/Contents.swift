//: Playground - noun: a place where people can play

import UIKit

// 1.switch的基本用法
// 0: 男, 1: 女
let sex = 0

// 1> switch后面的()可以省略
// 2> case后的break也可以省略

switch sex {
    case 0:
        print("男")
        //fallthrough
    case 1:
        print("女")
    default:
        print("未知")
}

// 基本用法的补充
// 1> 如果想case穿透,可用fallthrough
// 2> case支持多个条件

switch sex {
case 0, 1:
    print("正常人")
default:
    print("未知")
}


//MARK: - 特殊用法

//可判断浮点型
let a = 3.15
switch a {
case 3.14:
    print("π")
default:
    print("非π")
}

//可判断字符串
let m = 20
let n = 30
let operation = "*"
var result = 0
switch operation {
case "+":
    result = m + n
case "-":
    result = m - n
case "*":
    result = m * n
case "/":
    result = m / n
default:
    print("非法操作符")
}

//可判断区间
let score = 69
switch score {
case 0..<59:
    print("不及格")
case 60..<70:
    print("C")
case 70..<90:
    print("B")
case 90...100:
    print("A")
default:
    print("输入错误")
}
