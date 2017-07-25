//
//  HyperTextInputView.swift
//  MessageInputView
//
//  Created by luozhijun on 2017/6/20.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

//MARK: -
/** 点击加号按钮弹出的超文本输入视图 */
class HyperTextInputtingView: UICollectionView {
    
    static func defaultLayout(fittingWidth: CGFloat = UIScreen.main.bounds.width, fittingItemCount: Int = 0, numberOfItemsInOneLine: Int = 4, itemSize: CGSize = CGSize(width: 75, height: 75), linePadding: CGFloat = 15) -> (flow: UICollectionViewFlowLayout, suggestedHeight: CGFloat) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = linePadding
        flowLayout.itemSize           = itemSize
        var minimumInteritemSpacing: CGFloat = (fittingWidth - CGFloat(numberOfItemsInOneLine)*itemSize.width)/CGFloat(numberOfItemsInOneLine + 1)
        if minimumInteritemSpacing < 0 {
            minimumInteritemSpacing = 0
        }
        flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
        
        
        var suggestedHeight: CGFloat = linePadding*2 + itemSize.height
        if fittingItemCount > numberOfItemsInOneLine {
            let lines = (fittingItemCount - 1)/numberOfItemsInOneLine + 1
            suggestedHeight += CGFloat(lines-1) * (itemSize.height + linePadding)
        }
        return (flowLayout, suggestedHeight)
    }
    
    fileprivate var inputtingModels = [HyperTextInputtingModel]()
    fileprivate let bgView: UIToolbar = UIToolbar()
    
    var itemClicked: ((HyperTextInputtingModel, IndexPath) -> Swift.Void)?
    
    init(inputtingModels: [HyperTextInputtingModel], frame: CGRect, layout: UICollectionViewFlowLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.inputtingModels = inputtingModels
        contentInset    = UIEdgeInsets(top: layout.minimumLineSpacing, left: layout.minimumInteritemSpacing, bottom: layout.minimumLineSpacing, right: layout.minimumInteritemSpacing)
        backgroundColor = UIColor.clear
        backgroundView  = bgView
        
        register(HyperTextInputtingCell.self, forCellWithReuseIdentifier: HyperTextInputtingCell.reuseIdentifier)
        delegate        = self
        dataSource      = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HyperTextInputtingView : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inputtingModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HyperTextInputtingCell.reuseIdentifier, for: indexPath) as! HyperTextInputtingCell
        cell.model = inputtingModels[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemClicked?(inputtingModels[indexPath.item], indexPath)
    }
}

//MARK: - 
fileprivate class HyperTextInputtingCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "HyperTextInputtingCell"
    
    private var button    : UIButton = UIButton(type: .system)
    private var titleLabel: UILabel  = UILabel()
    
    var model: HyperTextInputtingModel? {
        didSet {
            button.setImage(model?.icon, for: .normal)
            titleLabel.text = model?.title
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(button)
        
        addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let titleLabelNeedsSize = titleLabel.sizeThatFits(CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        titleLabel.frame = CGRect(x: 0, y: frame.height - titleLabelNeedsSize.height, width: frame.width, height: titleLabelNeedsSize.height)
        
        button.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - titleLabelNeedsSize.height)
    }
}
