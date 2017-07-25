//
//  PATablePickerView.swift
//  wanjia2B
//
//  Created by luozhijun on 2017/2/16.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit

/** 表格选择视图 */
class PATablePickerView: PAPopupContainerView {
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource      = self
        tableView.delegate        = self
        tableView.backgroundColor = .clear
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.reuseIdentifier)
        return tableView
    }()
    
    var dataSource = [SettingCheckmarkItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var allowMultipleSelection = false
    var selectedItems = [SettingCheckmarkItem]()
    
    var didSelectItemAction: ((SettingCheckmarkItem) -> Swift.Void)?
    
    required init(contentHeight: CGFloat = PAPopupContainerView.defaultContentHeight, title: String? = nil, dataSource: [SettingCheckmarkItem]) {
        super.init(contentHeight: contentHeight, title: title)
        self.dataSource = dataSource
        contentView.addSubview(tableView)
    }
    
    override var frame: CGRect {
        didSet {
            tableView.frame = contentView.bounds
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(contentHeight: CGFloat, title: String?) {
        fatalError("init(contentHeight:title:) has not been implemented")
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate
extension PATablePickerView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier) as! SettingCell
        dataSource[indexPath.row].indexPath = indexPath
        cell.item = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        guard item.enable else { return }
        if !allowMultipleSelection {
            dataSource.forEach {
                $0.isChecked = false
                selectedItems.remove(element: $0)
            }
        }
        let selectingItem = dataSource[indexPath.row]
        selectingItem.isChecked = !selectingItem.isChecked
        if selectingItem.isChecked && !selectedItems.contains(selectingItem) {
            selectedItems.append(selectingItem)
        } else if !selectingItem.isChecked && selectedItems.contains(selectingItem) {
            selectedItems.remove(element: selectingItem)
        }
        didSelectItemAction?(selectingItem)
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
