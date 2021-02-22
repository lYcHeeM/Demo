//
//  ViewController.swift
//  PopPickerView
//
//  Created by luozhijun on 2017/8/24.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var openControl = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
    var pickerViewSize: CGSize {
        return CGSize(width: self.view.frame.width, height: 216)
    }
    var pickerView = PAAgePickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.tag = 111
        let tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyCell.self, forCellReuseIdentifier: "cell")
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openControl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "哈哈哈aaa"
        let isOpen = openControl[indexPath.row]
        if isOpen {
            cell.contentView.addSubview(pickerView)
            pickerView.frame = CGRect(x: 0, y: 44, width: view.frame.width, height: 216)
            pickerView.isHidden = false
        } else {
            cell.viewWithTag(pickerView.tag)?.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isOpen = openControl[indexPath.row]
        if isOpen {
            return 44 + pickerViewSize.height
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in 0..<openControl.count {
            if index != indexPath.row {
                openControl[index] = false
            }
        }
        let isOpen = openControl[indexPath.row]
        openControl[indexPath.row] = !isOpen
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

class MyCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.1)
        selectedBackgroundView = view
        backgroundView = UIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let textLabel = textLabel else { return }
        let labelNeedsSize = textLabel.sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        textLabel.frame = CGRect(x: textLabel.frame.origin.x, y: (44 - labelNeedsSize.height)/2, width: labelNeedsSize.width, height: labelNeedsSize.height)
        guard let view = selectedBackgroundView else { return }
        view.frame = CGRect(x: 0, y: 0, width: frame.width, height: 44)
    }
}


