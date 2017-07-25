//
//  main.swift
//  Tddd
//
//  Created by luozhijun on 15/10/13.
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

func randomIntBetween(low:Int, high:Int) -> Int
{
    let range = high - low + 1
    return Int(arc4random()) % range + low - 1
}

let answer = randomIntBetween(0, high: 100)

var turn = 1

while(true) {
    
    print("Guess: #\(turn) Enter a number between 1 and 100.")
    
    let input1 = input()
    
    let inputNumber = Int(input1)
    
    if let guess = inputNumber {
        if (guess > answer) {
            print("Lower!")
        } else if(guess < answer) {
            print("Higher!")
        } else {
            print("Correct! The answer was \(answer).")
            break
        }
    } else {
        print("Invalid input!")
        continue
    }
    turn += 1
}

print("It took you \(turn) tries")
