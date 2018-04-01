//
//  ViewController.swift
//  SwfitReactDemo
//
//  Created by luozhijun on 2018/4/1.
//  Copyright © 2018年 Rick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var observerbleBag = [Observable<String?>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let observable = Observable<Int>()
        observable.subscribe { (signal) in
            switch signal {
            case .normal(let value):
                print(value)
            case .error:
                break
            }
        }
        observable.onNext(.normal(1))
        observable.onNext(.normal(2))
        
        let tf = UITextField()
        view.addSubview(tf)
        tf.frame = CGRect.init(x: 20, y: 200, width: 200, height: 44)
        tf.borderStyle = .line
        let observable1 = tf.asObservable
        observable1.subscribe { (signal) in
            switch signal {
            case .normal(let value):
                print(value)
            case .error:
                break
            }
        }
        observerbleBag.append(observable1)
        
        tf.text = "123"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            tf.text = "456"
        }
    }
}


/// 对信号的抽象，每一个信号都有下面两种类型.
/// next表示正常类型，error表示错误类型
enum Signal<ValueType> {
    case normal(ValueType)
    case error(Error)
}

/// 对所有可观察的实体(随着时间可变的东西，比如数据流、事件流)的抽象
class Observable<ValueType> {
    typealias Subscriber = (Signal<ValueType>) -> Void
    fileprivate var subscribers = [Subscriber]()
    var keyValueObservers = [KeyValueObserver<ValueType>]()
    
    func onNext(_ signal: Signal<ValueType>) {
        for subscriber in subscribers {
            subscriber(signal)
        }
    }
    
    func subscribe(_ callBack: @escaping Subscriber) {
        subscribers.append(callBack)
    }
    
    deinit {
        print("--Observable deinit")
    }
}

/// 自定义观察者
class KeyValueObserver<ValueType>: NSObject {
    private let observedObj: NSObject
    private let keyPath: String
    private let valueChanged: (String, ValueType, ValueType) -> Void
    
    init(observedObj: NSObject, keyPath: String, valueChanged: @escaping (String, ValueType, ValueType) -> Void) {
        self.observedObj = observedObj
        self.keyPath = keyPath
        self.valueChanged = valueChanged
        super.init()
        observedObj.addObserver(self, forKeyPath: keyPath, options: [.old, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath, let oldValue = change?[.oldKey] as? ValueType, let newValue = change?[.newKey] as? ValueType else { return }
        valueChanged(keyPath, oldValue, newValue)
    }
    
    deinit {
        observedObj.removeObserver(self, forKeyPath: keyPath)
    }
}


extension UITextField: UITextFieldDelegate {
    
    private struct Key {
        static var asObservable: Int = 1
    }
    
    var asObservable: Observable<String?> {
        var value = objc_getAssociatedObject(self, &Key.asObservable) as? Observable<String?>
        if value == nil {
            value = Observable<String?>()
            objc_setAssociatedObject(self, &Key.asObservable, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            // Tag: TODO: 一个很重要的问题是在何时移除监听
            NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: Notification.Name.UITextFieldTextDidChange, object: self)
            
            let kvo = KeyValueObserver<String?>.init(observedObj: self, keyPath: #keyPath(text)) { (keyPath, oldValue, newValue) in
                value?.onNext(.normal(newValue))
            }
            // 为了持有kvo对象
            value?.keyValueObservers.append(kvo)
        }
        return value!
    }
    
    @objc private func textDidChange() {
        asObservable.onNext(.normal(text))
    }
}

