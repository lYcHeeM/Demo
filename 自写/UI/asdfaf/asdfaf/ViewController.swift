//
//  ViewController.swift
//  asdfaf
//
//  Created by luozhijun on 2017/1/12.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit
import QBImagePickerController
import AssetsLibrary
import Photos
import Aspects
import Accelerate

@discardableResult
func - <Element: Equatable>(left: inout [Element], right: [Element]) -> [Element] {
    if left.count > right.count {
        right.forEach {
            if let removingIndex = left.index(of: $0) {
                left.remove(at: removingIndex)
            }
        }
    }
    return left
}

extension Array where Element: Equatable {
    mutating func remove(element: Element) {
        if let removingIndex = index(of: element) {
            remove(at: removingIndex)
        }
    }
}

protocol  OptionalSting {}
extension String : OptionalSting {}
extension Optional where Wrapped: OptionalSting {
    /// 对可选类型的String(String?)安全解包
    var noneNull: String {
        if let value = self as? String {
            return value
        } else {
            return "默认字符串"
        }
    }
}

//MARK: - CGFloat
protocol OptionalCGFloat {}
extension CGFloat : OptionalCGFloat {}
extension Optional where Wrapped: OptionalCGFloat {
    var noneNull: CGFloat {
        if let value = self as? CGFloat {
            return value
        } else {
            return 0
        }
    }
}

extension String {
    func substring(to charIndex: UInt) -> String {
        return substring(to: index(startIndex, offsetBy: Int(charIndex)))
    }
    
    func substring(from charIndex: UInt) -> String {
        return substring(from: index(startIndex, offsetBy: Int(charIndex)))
    }
    
    func substring(in range: Range<UInt>) -> String {
        if Int(range.upperBound) > characters.count { return self }
        return substring(with: index(startIndex, offsetBy: Int(range.lowerBound))..<index(startIndex, offsetBy: Int(range.upperBound)))
    }
}

var bool = false

extension UIViewController {
    var setupSubviews: Void {
        print("----")
    }
}

class ViewController: UIViewController, QBImagePickerControllerDelegate {
    
    var textView: PAPlaceholderTextView!
    var selectedImages = [UIImage]()
    var selectedImageUrls = [Any]()
    var imagePickerGirdView: PAImagePickerGridView!
    var imagePickerController: QBImagePickerController! = QBImagePickerController()
    
    func test(pointer: UnsafePointer<Bool>) {
        print(pointer.pointee)
    }
    
    var void: Void {
        print("do something")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str1: String? = nil
        print(str1.noneNull)
        
        let str2: String? = "哈哈哈"
        print(str2.noneNull)
        
        struct Dog {
            var name: String?
        }
        
        str1?.characters.count
        
        var dog: Dog? = Dog()
        dog?.name = "aaa"
        let aaa = dog?.name
        print(aaa.noneNull)
        
        var testStr: String? = nil
        if testStr?.isEmpty == true {
            print(testStr?.isEmpty)
        }
        testStr = "aaa"
        if testStr?.isEmpty == false {
            print(testStr?.isEmpty)
        }
        
        print("------------")
        print(PAChainClinicCheckStatus.waitCheckState.rawValue)
        print(PAChainClinicCheckStatus.passState.rawValue)
        print(PAChainClinicCheckStatus.updateFailState.rawValue)
        
        print(PAClinicCheckStatus.waitPerfectFirstPassState.rawValue)
        print(PAClinicCheckStatus.waitPerfectNextPassState.rawValue)
        print(PAClinicCheckStatus.updateNextBackState.rawValue)
        
        print(PADoctorCheckStatus.firstBackState.rawValue)
        
        print(PADoctorIsView.offlineState.rawValue)
        print("------------")
        
        // 敲不出来, 编译错误
//        let str3 = "嘿嘿嘿"
//        str3.noneNull
        
//        let cgFloat: CGFloat? = 10
//        let cell = UITableViewCell()
//        let a = cell.accessoryView?.frame.width
//        print(cgFloat.noneNull)
//        print(a.noneNull)
//        
//        textView = PAPlaceholderTextView(placeholder: "拉当减肥了;安居房的撒浪费精力;按时间弗利萨按道理三级分类;啊大家", textContainer: nil)
//        view.addSubview(textView)
//        textView.backgroundColor = UIColor(white: 0, alpha: 0.1)
//        textView.frame = CGRect(x: 100, y: 10, width: 100, height: 100)
        
//        let segment = UISegmentedControl(items: ["初诊", "复诊"])
//        view.addSubview(segment)
//        segment.frame = CGRect(x: 100, y: 300, width: 110, height: 25)
//        segment.layer.cornerRadius = 10
//        segment.tintColor = UIColor.orange
//        segment.selectedSegmentIndex = 0
        
        imagePickerGirdView = PAImagePickerGridView(frame: CGRect(x: 0, y: 40, width: view.frame.width, height: 220), dataSource: [])
        view.addSubview(imagePickerGirdView)
        imagePickerGirdView.showAlumbAction = { [weak self] _ in
            self?.btn2Clicked()
        }
        imagePickerGirdView.alertControllerPresentedController = self
        imagePickerGirdView.itemDeleteButtonClicked = { [weak self] (view, indexPath) in
            if self == nil { return }
            view.remove(imageAt: indexPath)
            if view.dataSource.count == 0 {
                self?.imagePickerController = nil
            }
        }
        
        let btn1 = PAOffsetedSubviewButton(imageHeightRatio: 0.7, style: .imageTopTitleBottom)
        view.addSubview(btn1)
        btn1.setImage(UIImage(named: "icon_1")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn1.setTitle("哈哈哈", for: .normal)
        btn1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn1.setTitleColor(.black, for: .normal)
        btn1.frame = CGRect(x: 100, y: 520, width: 80, height: 80)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(drag))
        longPress.minimumPressDuration = 0.2
        let imageView = UIImageView(image: UIImage(named: "icon_1"))
        view.addSubview(imageView)
        imageView.isUserInteractionEnabled = true
        imageView.frame = CGRect(x: 100, y: 400, width: 80, height: 80)
        imageView.addGestureRecognizer(longPress)
        
        
        let btn2 = PAOffsetedSubviewButton(style: .imageRightTitleLeft)
        view.addSubview(btn2)
        btn2.setImage(UIImage(named: "ic_arrow_gray_down")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn2.setTitle("大水法啊", for: .normal)
//        btn2.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btn2.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btn2.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn2.setTitleColor(.gray, for: .normal)
        btn2.setTitleColor(.black, for: .highlighted)
        btn2.frame = CGRect(x: 200, y: 360, width: 120, height: 30)
        btn2.addTarget(self, action: #selector(btn2Clicked), for: .touchUpInside)
        
        var array1 = ["aaa", "bbb", "ccc"]
        let array2 = array1 - ["bbb"]
        array1.remove(element: "aaa")
        print("")
        
//        let cover = ZJCover()

        let wrappedBlock: @convention(block)(AspectInfo) -> Void = { (info) in
            if self.imagePickerController.selectedAssetURLs.count == 0 {
                self.qb_imagePickerController(self.imagePickerController, didSelectAssets: [])
            }
        }
        _ = try? QBAssetsViewController.aspect_hook(Selector(("done:")), with: .positionBefore, usingBlock: wrappedBlock)
        
//        try? QBAssetsViewController.aspect_hook(NSSelectorFromString("done:"), with: .positionBefore, usingBlock: {
//            if self.imagePickerController.selectedAssetURLs.count == 0 {
//                self.qb_imagePickerController(self.imagePickerController, didSelectAssets: [])
//            }
//        })
        
        let aaaa = "摇落深知宋玉悲，风流儒雅亦吾师。怅望千秋一洒泪，萧条异代不同时。"
        let bbbb = aaaa.substring(to: aaaa.index(aaaa.startIndex, offsetBy: 7))
        let cccc = aaaa.substring(to: 7)
        let dddd = aaaa.substring(in: 0..<7)
        let eeee = aaaa.substring(in: 0..<100)
        let ffff = aaaa.substring(from: 8)
        print("")
    }
    
    @objc func btn2Clicked() {
        if self.imagePickerController == nil {
            self.imagePickerController = QBImagePickerController()
        }
        imagePickerController.delegate = self
        imagePickerController.allowsMultipleSelection = true
        imagePickerController.minimumNumberOfSelection = 0
        imagePickerController.maximumNumberOfSelection = 3
        imagePickerController.showsNumberOfSelectedAssets = true

        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func drag(sender: UILongPressGestureRecognizer) {
        guard let view = sender.view else { return }
        let point = sender.location(in: self.view)
        if sender.state == .began {
            view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
            UIView.animate(withDuration: 0.2, animations: {
                view.center = point
                view.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
                view.layer.shadowOpacity = 0.3
                view.layer.shadowRadius = 3
            })
        } else if sender.state == .changed {
            view.center = point
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.2, animations: {
                view.layer.shadowOffset = CGSize(width: 0, height: -3)
                view.layer.shadowOpacity = 0
            })
        }
    }
    
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didSelectAssets assets: [Any]!) {
        guard let assets = assets as? [ALAsset] else { return }
        var images = [UIImage]()
        for asset in assets {
            images.append(UIImage(cgImage: asset.thumbnail().takeUnretainedValue()))
            if let url = asset.value(forProperty: ALAssetPropertyAssetURL) {
                selectedImageUrls.append(url)
            }
        }
        let aaa = images
        imagePickerGirdView.dataSource = images
        print(imagePickerController.selectedAssetURLs)
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        print(imagePickerController.selectedAssetURLs)
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        textView.placeholder = "但是发发地方的"
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { 
//            self.textView.placeholder = nil
//        }
//        
//        let sheet = UIActionSheet(title: nil, delegate: nil, cancelButtonTitle: "哈哈哈哈", destructiveButtonTitle: "哈哈哈哈")
//        sheet.show(in: view)
//    }
}
















// Constrained extension must be declared on the unspecialized generic type 'Optional' with constraints specified by a 'where' clause
