//
//  KVOController.swift
//  ObjectiveCRutimeDemo
//
//  Created by luozhijun on 2017/3/17.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

class KVOController: UIViewController {

    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextChanged), name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    func textFieldTextChanged() {
        textField.text = textField.text
    }
    
    @IBAction func observe(_ sender: Any) {
        textField.zj_addObserver(self, forKeyPath: "text") { (observer, keyPath, oldValue, newValue) in
            print("oldValue: \(oldValue), newValue: \(newValue)")
        }
        print(textField.classForCoder)
        print(textField.superclass!)
    }
    
    @IBAction func cancelObservation(_ sender: Any) {
        textField.zj_removeObserver(self, forKeyPath: "text")
    }
}
