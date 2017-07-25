//
//  main.swift
//  02-类对象集合
//
//  Created by luozhijun on 15/10/15.
//  Copyright © 2015年 luozhijun. All rights reserved.
//

import Foundation

//
// --basic using of class Person
//var newPerson = Person()
//
//newPerson.firstName = "Zhijun"
//newPerson.lastName = "Luo"
//newPerson.age = 24
//newPerson.printInfo()
//
//newPerson.changeFirstName("Lee")
//newPerson.printInfo()
//
//newPerson.enterInfo()
//newPerson.printInfo()

//
// --with roop and Array
var response:String
var people:[Person] = []

repeat {
    var aPerson = Person()
    aPerson.enterInfo()
    aPerson.printInfo()

    people.append(aPerson)
    print("Number of people in the database:\(people.count)")
    print("Do you want to enter another person's info?(y/n)")
    response = input()
    
} while (response == "y")

for onePerson in people {
    onePerson.printInfo()
}
