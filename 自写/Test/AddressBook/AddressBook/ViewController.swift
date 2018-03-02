//
//  ViewController.swift
//  AddressBook
//
//  Created by luozhijun on 2018/1/18.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UITableViewController {
    
    var names = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "next", style: .plain, target: self, action: #selector(nextVc))
        
        getContatList()
        
        //1.获取授权状态
        let status = CNContactStore.authorizationStatus(for: .contacts)
        //2.判断授权状态，如果未授权，发起授权请求
        if status == .notDetermined {
            let contactStore = CNContactStore()
            contactStore.requestAccess(for: .contacts, completionHandler: { (isRight: Bool, nil) in
                if isRight {
                    print("授权成功")
                    //遍历联系人列表
                    self.getContatList()
                } else {
                    print("用户未授权")
                }
            })
        }
    }
    /*
     *调用时间：
     *作用：遍历通讯录
     */
    private func getContatList() {
        //判断是否有权读取通讯录
        let status = CNContactStore.authorizationStatus(for: .contacts)
        guard status == .authorized else {
            return
        }
        //1.创建通讯录对象
        let store = CNContactStore()
        //2.定义要获取的属性键值
        let key = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey]
        //3.获取请求对象
        let request = CNContactFetchRequest(keysToFetch: key as [CNKeyDescriptor])
        //4.遍历所有联系人
        do {
            try store.enumerateContacts(with: request, usingBlock: { (contact: CNContact, stop: UnsafeMutablePointer<ObjCBool>) in
                //4.1获取姓名
                let lastName = contact.familyName
                let firstName = contact.givenName
                let fullName = "\(lastName)\(firstName)"
                print("姓名：\(fullName)")
                self.names.append(fullName)
                //4.2获取电话号码
                let phoneNumbers = contact.phoneNumbers
                for phoneNumber in phoneNumbers {
//                    print(phoneNumber.label?.characters ?? "")
                    print(phoneNumber.value.stringValue)
                }
            })
        } catch {
            print("读取通讯录出错")
        }
    }
    
    @objc func nextVc() {
        let nextVc = SecondVc()
        nextVc.names = names
        navigationController?.pushViewController(nextVc, animated: true)
    }
}

