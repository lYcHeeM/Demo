//: Playground - noun: a place where people can play

import UIKit

// OC写法
//for (int i = 0; i < 10; i ++) {
//    NSLog(@"%d", i);
//}

// swift写法
// for之后的()可以省略
for var i = 0; i < 10; i += 1 {
    print(i)
}

// for in
for i in 0..<10 {
    print(i)
}
// Swift中如果一个标识符不需要被使用, 可使用_代替
for _ in 0...9 {
    print("hello")
}


