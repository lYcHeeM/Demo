//
//  Person.swift
//  02-类对象集合
//
//  Created by luozhijun on 15/10/15.
//  Copyright © 2015年 luozhijun. All rights reserved.
//

import Foundation

func input() -> String {
    let keyboard = NSFileHandle.fileHandleWithStandardInput()
    let inputData = keyboard.availableData
    let rawString = NSString(data: inputData, encoding:NSUTF8StringEncoding)
    if let string = rawString {
        return string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    } else {
        return "Invalid input"
    }
}

// class declaration
class Person {
    
    var firstName = ""
    var lastName = ""
    var age = 0
   
    func changeFirstName(newFirstName:String) {
        firstName = newFirstName
    }
    
    func enterInfo() {
        print("Input the first name:")
        firstName = input()
        
        print("Input the last name")
        lastName = input()
        
        print("How old is \(firstName) \(lastName)")
        let userInput = Int(input())
        if let inputNumber = userInput {
            age = inputNumber
        }
    }
    
    func printInfo() {
        print("\(firstName) \(lastName) is \(age) years old.")
    }
}
