//
//  PAImagePickerGridView.swift
//  asdfaf
//
//  Created by luozhijun on 2017/2/20.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

/** 把选择好的图片展示为网格的视图, 在最后一张图片之后会有一个额外加号按钮 */
class PAImagePickerGridView: UIView {
    
    var numberOfImagesAllowed = 3
    var numberOfImagesInOneLine = 4
    
    fileprivate var gridCollectionView: UICollectionView!
    var dataSource = [UIImage]() {
        didSet {
            gridCollectionView.reloadData()
        }
    }
    
    var plusButtonDidClick: ((PAImagePickerGridView) -> Swift.Void)?
    var itemDeleteButtonClicked: ((PAImagePickerGridView, IndexPath) -> Swift.Void)?
    
    weak var alertControllerPresentedController: UIViewController?
    var alertControllerForDecidingAlbumOrCamera: UIAlertController {
        let albumAction = UIAlertAction(title: "手机相册", style: .default) { (_) in
            self.showAlumbAction?(self)
        }
        let cameraAction = UIAlertAction(title: "相机", style: .default) { (_) in
            self.showCameraAction?(self)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(albumAction)
        alertController.addAction(cancelAction)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertControllerPresentedController?.present(alertController, animated: true, completion: nil)
        return alertController
    }
    var showAlumbAction: ((PAImagePickerGridView) -> Swift.Void)?
    var showCameraAction: ((PAImagePickerGridView) -> Swift.Void)?
    
    fileprivate static var defaultFlowLayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 4
        flowLayout.minimumLineSpacing = 3
        let numberOfImagesInOneLine = (UIScreen.main.bounds.width == 320) ? 3 : 4
        let gridWidth = (UIScreen.main.bounds.width - CGFloat(numberOfImagesInOneLine + 1) * flowLayout.minimumInteritemSpacing)/CGFloat(numberOfImagesInOneLine)
        flowLayout.itemSize = CGSize(width: gridWidth, height: gridWidth)
        return flowLayout
    }
    
    required init(frame: CGRect, flowLayout: UICollectionViewFlowLayout = defaultFlowLayout, dataSource: [UIImage]) {
        super.init(frame: frame)
        self.dataSource = dataSource
        
        gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        gridCollectionView.backgroundColor = .white
        gridCollectionView.dataSource   = self
        gridCollectionView.delegate     = self
        gridCollectionView.contentInset = UIEdgeInsets(top: 0, left: flowLayout.minimumInteritemSpacing, bottom: 0, right: flowLayout.minimumInteritemSpacing)
        gridCollectionView.register(PAImagePickerCell.self, forCellWithReuseIdentifier: PAImagePickerCell.reuseIdentifier)
        gridCollectionView.register(PAImagePickerPlusCell.self, forCellWithReuseIdentifier: "plus")
        addSubview(gridCollectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gridCollectionView.frame = bounds
    }
    
    func append(image: UIImage) {
        dataSource.append(image)
    }
    
    func remove(imageAt indexPath: IndexPath) {
        dataSource.remove(at: indexPath.row)
    }
    
    func remove(image: UIImage) {
        
    }
}

extension PAImagePickerGridView : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataSource.count >= numberOfImagesAllowed {
            return dataSource.count
        } else {
            return dataSource.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < dataSource.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PAImagePickerCell.reuseIdentifier, for: indexPath) as! PAImagePickerCell
            cell.image = dataSource[indexPath.item]
            cell.closeButtonDidClick = { [weak self] _ in
                guard self != nil else { return }
                self?.itemDeleteButtonClicked?(self!, indexPath)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "plus", for: indexPath) as! PAImagePickerPlusCell
            cell.plusButtonDidClick = { [weak self] in
                guard self != nil else { return }
                _ = self?.alertControllerForDecidingAlbumOrCamera
                self?.plusButtonDidClick?(self!)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < dataSource.count {
            
        } else {
            
        }
    }
}

class PAImagePickerCell: UICollectionViewCell {
    
    static let reuseIdentifier = NSStringFromClass(PAImagePickerCell.self) as String
    
    fileprivate var imageView = UIImageView()
    fileprivate var closeButton = UIButton()
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    var closeButtonDidClick: ((PAImagePickerCell) -> Swift.Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        contentView.addSubview(closeButton)
        closeButton.setImage(UIImage(named: "EmoticonCloseButton"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        
        var closeButtonSize = CGSize(width: 16, height: 16)
        if let closeImage = closeButton.currentImage {
            closeButtonSize = closeImage.size
        }
        let closeButtonX = frame.width - closeButtonSize.width - 1
        let closeButtonY: CGFloat = 1
        closeButton.frame = CGRect(x: closeButtonX, y: closeButtonY, width: closeButtonSize.width, height: closeButtonSize.height)
    }
    
    @objc fileprivate func closeButtonClicked() {
        closeButtonDidClick?(self)
    }
}

class PAImagePickerPlusCell: UICollectionViewCell {
    fileprivate var plusButton = UIButton(type: .system)
    var plusButtonDidClick: (() -> Swift.Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(plusButton)
        plusButton.setBackgroundImage(UIImage(named: "AlbumAddBtnHL")?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusButton.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        plusButton.frame = contentView.bounds
        plusButton.imageView?.contentMode = .scaleAspectFit
    }
    
    @objc private func plusButtonClicked() {
        plusButtonDidClick?()
    }
}

