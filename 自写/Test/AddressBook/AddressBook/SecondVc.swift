//
//  ViewController.swift
//  AddressBook
//
//  Created by luozhijun on 2018/1/18.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

import UIKit

class SecondVc: UIViewController {
    
    var vcScrollView: UIScrollView!
    var names = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let padding_1: CGFloat = 72;
        let padding_2: CGFloat = 20;
        let textIndent: CGFloat = 9;
        
        let fixedNames = ["      石冠男", "翟剑毅", "杨知颖", "宁宁", "钟佳伟", "高思", "徐子浩", "王欣"]
        var allNames = fixedNames;
        allNames.append(contentsOf: names)
        allNames.removeLast()
        if let index = allNames.index(of: "徐晋如老师") {
            allNames.remove(at: index)
            print(index)
        }
        if let index = allNames.index(of: "蒋易思") {
            allNames.remove(at: index)
            print(index)
        }
        allNames.append(contentsOf: [])
        
        let emojiNames = ["香港代购小喵🐱", "Professor Herb🚶🏻‍♀️", "凌海超🌈", "淼淼💋", "不会说话的嘴🤕", "天亮灬说再见🌝", "江湖归白发🌵", "All right🌀"]
        for index in 0..<emojiNames.count {
            let insertingIndex = ((index + 1) * (8 * (index + 1))) % allNames.count
            if insertingIndex < allNames.count {
                allNames.insert(emojiNames[index], at: insertingIndex)
            }
        }
        
        let path2 = Bundle.main.path(forResource: "names2.txt", ofType: nil)!
        if let content = try? NSString(contentsOfFile: path2, encoding: String.Encoding.utf8.rawValue) {
            let names = content.components(separatedBy: " ")
            allNames.insert(contentsOf: names, at: allNames.count/3)
            print(allNames.count)
        }
        
        let path = Bundle.main.path(forResource: "names.txt", ofType: nil)!
        if let content = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) {
            let names = content.components(separatedBy: " ")
            allNames.append(contentsOf: names)
            print(allNames.count)
        }
        
        
        
        let attrString = NSMutableAttributedString()
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 1.5
        var index = 0;
        for item in allNames {
            attrString.append(NSAttributedString(string: item, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor(withRGBValue: 0x5b6a92, alpha: 1), NSAttributedStringKey.paragraphStyle: paraStyle]))
            if index < allNames.count {
                attrString.append(NSAttributedString(string: ", ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: paraStyle]))
            }
            index += 1
        }
        
        navigationController?.setNavigationBarHidden(true, animated: true);
    
        let scrollView = UIScrollView()
        view.addSubview(scrollView);
        scrollView.frame = view.bounds;
        scrollView.contentSize = CGSize(width: 0, height: 4500);
        
        let bgView = UIView()
        scrollView.addSubview(bgView);
        bgView.backgroundColor = UIColor(R: 243, G: 243, B: 245);
        
        let label = UILabel()
        bgView.addSubview(label)
        label.numberOfLines = 0
        label.attributedText = attrString
        label.frame = CGRect(x: textIndent, y: 0, width: view.frame.width - padding_1 - padding_2 - 2*textIndent, height: 0)
        let needsSize = label.sizeThatFits(CGSize(width: label.frame.width, height: 9999999))
        label.frame.size.height = needsSize.height
        
        bgView.frame = CGRect(x: padding_1, y: 0, width: label.frame.width + 2 * textIndent, height: label.frame.height)
        
        vcScrollView = scrollView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension UIColor {
    convenience init(R: Int, G: Int, B: Int, A: Float = 1.0) {
        self.init(red:   CGFloat(Float(R) / 255.0),
                  green: CGFloat(Float(G) / 255.0),
                  blue:  CGFloat(Float(B) / 255.0),
                  alpha: CGFloat(A))
    }
    
    convenience init(withRGBValue rgbValue: Int, alpha: Float = 1.0) {
        let r = ((rgbValue & 0xFF0000) >> 16)
        let g = ((rgbValue & 0x00FF00) >> 8)
        let b =  (rgbValue & 0x0000FF)
        self.init(R: r,
                  G: g,
                  B: b,
                  A: alpha)
    }
}


