//
//  MyPickerView.swift
//  PickerViewPopOnCell
//
//  Created by luozhijun on 2017/8/24.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

class PAAgePickerView: UIPickerView {
    
    fileprivate var dataModels  = [[String]]()
    fileprivate var topLine     = UIView()
    fileprivate var _selectedAge   = 18
    fileprivate var _selectedMonth = 6
    
    var selectedAge: Int {
        return _selectedAge
    }
    var selectedMonth: Int {
        return _selectedMonth
    }
    var selectedAgeString: String {
        return "\(_selectedAge)岁\(_selectedMonth)月"
    }
    
    var didSelectRow: ((Int, Int, String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.backgroundColor = UIColor(white: 0, alpha: 0.03).cgColor
        delegate = self
        dataSource = self
        
        var ageStrings = [String]()
        for index in 0...120 {
            ageStrings.append("\(index)")
        }
        
        var monthStrings = [String]()
        for index in 0...12 {
            monthStrings.append("\(index)")
        }
        
        dataModels.append(ageStrings)
        dataModels.append(["岁"])
        dataModels.append(monthStrings)
        dataModels.append(["月"])
        
        addSubview(topLine)
        topLine.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        topLine.layer.shadowColor     = UIColor.black.cgColor
        topLine.layer.shadowRadius    = 3
        topLine.layer.shadowOpacity   = 1
        topLine.layer.shadowOffset    = CGSize(width: 0, height: 1)
        
        selectRow(18, inComponent: 0, animated: false)
        selectRow(6 , inComponent: 2, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topLine.frame = CGRect(x: 0, y: 0, width: frame.width, height: 1/UIScreen.main.scale)
    }
}

extension PAAgePickerView: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataModels.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataModels[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataModels[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard component == 0 || component == 2 else { return }
        if component == 0, let age = Int(dataModels[component][row]) {
            _selectedAge = age
        }
        if component == 2, let month = Int(dataModels[component][row]) {
            _selectedMonth = month
        }
        didSelectRow?(_selectedAge, _selectedMonth, selectedAgeString)
    }
}
