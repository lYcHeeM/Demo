//
//  PAPhotoPickerThumbnailController.swift
//  tempaaa
//
//  Created by luozhijun on 2017/8/7.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit
import Photos

class PAPhotoPickerThumbnailController: UIViewController {

    var assets = [PAAssetModel]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var isSelectionFull: Bool = false {
        didSet {
            for asset in self.assets {
                if !asset.isSelected {
                    if asset.canSelect == !isSelectionFull {
                        return
                    } else {
                        asset.canSelect = !isSelectionFull
                    }
                }
            }
            collectionView.reloadData()
        }
    }
    
    fileprivate var collectionView   : UICollectionView!
    fileprivate let bottomBarHeight  : CGFloat = 44
    fileprivate var doneButton       : UIButton!
    fileprivate var originalSizeCheck: UIButton!
    fileprivate var previewButton    : UIButton!
    fileprivate var maxSelectionAllowed = 9
    fileprivate var selectedAssetsPointer  : UnsafeMutablePointer<[PAAssetModel]>!
    fileprivate var sumOfImageSizePointer  : UnsafeMutablePointer<Int>!
    fileprivate var isOriginalPointer      : UnsafeMutablePointer<Bool>!
    fileprivate var isSelectionsFullPointer: UnsafeMutablePointer<Bool>!
    
    fileprivate var previewingLocatedIndexPath: IndexPath?
    
    required init(assets: [PAAssetModel], maxSelectionAllowed: Int = 9, selectedAssetsPointer: UnsafeMutablePointer<[PAAssetModel]>, sumOfImageSizePointer: UnsafeMutablePointer<Int>, isOriginalPointer: UnsafeMutablePointer<Bool>, isSelectionsFullPointer: UnsafeMutablePointer<Bool>) {
        super.init(nibName: nil, bundle: nil)
        self.assets                  = assets
        self.maxSelectionAllowed     = maxSelectionAllowed
        self.selectedAssetsPointer   = selectedAssetsPointer
        self.sumOfImageSizePointer   = sumOfImageSizePointer
        self.isOriginalPointer       = isOriginalPointer
        self.isSelectionsFullPointer = isSelectionsFullPointer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        acquireConfiguration()
    }
    
    private func acquireConfiguration() {
        guard let naviVC = navigationController as? PAPhotoPickerController else { return }
        maxSelectionAllowed = naviVC.configuration.maxSelectionAllowed
        originalSizeCheck.isHidden = !naviVC.configuration.allowsSelectOriginalAsset
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        originalSizeCheck.isSelected = isOriginalPointer.pointee
        refreshBottomBar()
    }

    fileprivate func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_leftButton").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back))
        let cancel = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(dismissNav))
        navigationItem.rightBarButtonItems = [cancel]
        
        let doneButtonWidth : CGFloat = 62
        let vPadding        : CGFloat = 8
        let hPadding        : CGFloat = 12
        let doneButtonHeight: CGFloat = bottomBarHeight - 2 * vPadding
        
        let flowLayout = UICollectionViewFlowLayout()
        let itemCountInOneLine = 4
        flowLayout.minimumInteritemSpacing = 3
        flowLayout.minimumLineSpacing = 3
        let itemSize = (view.frame.width - CGFloat(itemCountInOneLine - 1) * flowLayout.minimumInteritemSpacing) / CGFloat(itemCountInOneLine)
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.contentInset.bottom += bottomBarHeight
        collectionView.backgroundColor = view.backgroundColor
        collectionView.register(PAPhotoPickerThumbnailCell.self, forCellWithReuseIdentifier: PAPhotoPickerThumbnailCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.scrollToItem(at: IndexPath(item: assets.count - 1, section: 0), at: .bottom, animated: false)
        collectionView.contentOffset.y += UIScreen.navigationHeight
        view.addSubview(collectionView)
        
        let bottomBar = UIToolbar()
        view.addSubview(bottomBar)
        bottomBar.frame = CGRect(x: 0, y: view.frame.height - bottomBarHeight - UIScreen.tabbarSafeBottomMargin, width: view.frame.width, height: bottomBarHeight)
        if UIDevice.isIPHONE_X {
            let bottomAreaBgView = UIToolbar()
            // 去除toolBar顶部的分割线
            bottomAreaBgView.clipsToBounds = true
            view.addSubview(bottomAreaBgView)
            bottomAreaBgView.frame = CGRect(x: 0, y: bottomBar.frame.maxY, width: view.frame.width, height: UIScreen.tabbarSafeBottomMargin)
        }
        
        doneButton = UIButton()
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        let bgImage = UIImage(color: UIColor.paOrange)?.stretchable
        let disableImage = UIImage(color: UIColor.gray)?.stretchable
        doneButton.setBackgroundImage(bgImage, for: .normal)
        doneButton.setBackgroundImage(disableImage, for: .disabled)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.frame.size = CGSize(width: doneButtonWidth, height: doneButtonHeight)
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius  = 3
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        let doneItem = UIBarButtonItem(customView: doneButton)
        
        originalSizeCheck = UIButton()
        originalSizeCheck.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        originalSizeCheck.setTitle(" 原图 ", for: .normal)
        originalSizeCheck.setTitleColor(UIColor.lightGray, for: .normal)
        originalSizeCheck.setTitleColor(UIColor.paOrange, for: .selected)
        originalSizeCheck.setImage(#imageLiteral(resourceName: "btn_unselected_round"), for: .normal)
        originalSizeCheck.setImage(#imageLiteral(resourceName: "btn_selected_round"), for: .selected)
        originalSizeCheck.setImage(#imageLiteral(resourceName: "btn_unselected_round"), for: .disabled)
        originalSizeCheck.sizeToFit()
        originalSizeCheck.addTarget(self, action: #selector(originalSizeChecked), for: .touchUpInside)
        let sizeCheckItem = UIBarButtonItem(customView: originalSizeCheck)
        
        previewButton = UIButton(type: .system)
        previewButton.tintColor = .paOrange
        previewButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        previewButton.setTitle("预览", for: .normal)
        previewButton.sizeToFit()
        previewButton.frame = CGRect(x: hPadding, y: (bottomBar.frame.height - previewButton.bounds.height)/2, width: previewButton.bounds.width, height: previewButton.bounds.height)
        previewButton.addTarget(self, action: #selector(previewButtonClicked), for: .touchUpInside)
        let previewItem = UIBarButtonItem(customView: previewButton)
        
        // Tag 给toolBar设置item, 避免直接把子视图加在toolBar上, iOS 11 便会出问题, 但如果设置item的话, Apple会保证Api的toolBar本地的api的有效性.
        let flexibleItem1  = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexibleItem2  = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let leftSpaceItem  = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let rightSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpaceItem.width  = -5
        rightSpaceItem.width = -5
        bottomBar.items = [leftSpaceItem, previewItem, flexibleItem1, sizeCheckItem, flexibleItem2, doneItem, rightSpaceItem]
        
        if #available(iOS 9.0, *) {
            registerForPreviewing(with: self, sourceView: collectionView)
        }
    }
    
    @objc private func back() {
        guard let naviVc = navigationController as? PAPhotoPickerController else { return }
        naviVc.selections = selectedAssetsPointer.pointee.map({ (model) -> PHAsset in
            return model.phAsset
        })
        naviVc.selectionsFinished?(naviVc.selections)
        naviVc.popViewController(animated: true)
    }
    
    @objc private func dismissNav() {
        PAPhotoPickerHelper.resumeNaviBarStyle()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneButtonClicked() {
        PAPhotoPickerHelper.resumeNaviBarStyle()
        guard let naviVc = navigationController as? PAPhotoPickerController else { return }
        naviVc.selections = selectedAssetsPointer.pointee.map({ (model) -> PHAsset in
            return model.phAsset
        })
        let hud = PAMBManager.sharedInstance.showLoadingInView(view: view, labelText: "请稍后...")
        var size = naviVc.configuration.imageSizeOnCompletion
        if isOriginalPointer.pointee == true {
            size = PHImageManagerMaximumSize
        }
        PAPhotoPickerHelper.images(for: naviVc.selections, size: size, resizeMode: .fast, deliveryMode: .opportunistic) { (images) in
            hud.hide(false)
            naviVc.willDismissWhenDoneBtnClicked?(images, naviVc.selections)
            naviVc.dismiss(animated: true) {
                naviVc.didDismissWhenDoneBtnClicked?(images, naviVc.selections)
            }
        }
    }
    
    @objc private func originalSizeChecked() {
        originalSizeCheck.isSelected = !originalSizeCheck.isSelected
        isOriginalPointer.pointee = originalSizeCheck.isSelected
        refreshBottomBar()
    }
    
    fileprivate func refreshBottomBar() {
        let count = selectedAssetsPointer.pointee.count
        doneButton.isEnabled    = count > 0
        previewButton.isEnabled = count > 0
        if count > 0 {
            doneButton.setTitle("完成(\(count))", for: .normal)
        } else {
            doneButton.setTitle("完成", for: .normal)
        }
        if sumOfImageSizePointer.pointee > 0, originalSizeCheck.isSelected {
            self.originalSizeCheck.setTitle(" 原图 \(sumOfImageSizePointer.pointee.bytesSize)", for: .normal)
        } else {
            self.originalSizeCheck.setTitle(" 原图 ", for: .normal)
        }
        self.originalSizeCheck.sizeToFit()
        self.originalSizeCheck.center = CGPoint(x: self.view.frame.width/2, y: self.bottomBarHeight/2)
    }
    
    @objc private func previewButtonClicked() {
        guard let asset = selectedAssetsPointer.pointee.first else { return }
        imageButtonClicked(asset: asset)
    }
}

extension PAPhotoPickerThumbnailController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PAPhotoPickerThumbnailCell.reuseIdentifier, for: indexPath) as! PAPhotoPickerThumbnailCell
        cell.asset = assets[indexPath.item]
        if let naviVc = self.navigationController as? PAPhotoPickerController {
            cell.showsSelectedOrder = naviVc.configuration.showsSelectedOrder
        }
        weak var weakInstance = cell
        cell.selectButtonClicked = { [weak self] asset in
            guard let asset = asset, let `self` = self, let cell = weakInstance else { return }
            self.selectButtonClicked(on: cell, asset: asset)
        }
        cell.imageButtonClicked = { [weak self] asset in
            guard let asset = asset, let `self` = self else { return }
            self.imageButtonClicked(asset: asset)
        }
        return cell
    }
    
    fileprivate func selectButtonClicked(on cell: PAPhotoPickerThumbnailCell, asset: PAAssetModel) {
        var selectionChanged         = false
        var selectionsJustUnFull     = false
        var selectionDeletedAtMiddle = false
        if !asset.isSelected {
            if self.selectedAssetsPointer.pointee.count < self.maxSelectionAllowed {
                asset.isSelected = true
                if !self.selectedAssetsPointer.pointee.contains(asset) { // 防止重复添加
                    self.selectedAssetsPointer.pointee.append(asset)
                    asset.selectedOrder = self.selectedAssetsPointer.pointee.count
                    PAPhotoPickerHelper.imageSize(of: [asset.phAsset], synchronous: true, completion: { (size) in
                        self.sumOfImageSizePointer.pointee += size
                    })
                    selectionChanged = true
                    if self.selectedAssetsPointer.pointee.count >= self.maxSelectionAllowed {
                        self.isSelectionsFullPointer.pointee = true
                        for asset in self.assets {
                            if !asset.isSelected {
                                asset.canSelect = false
                            }
                        }
                        collectionView.reloadData()
                        // 使reloadData同步完成
                        collectionView.layoutIfNeeded()
                    } else {
                        cell.refreshButton(with: asset, animated: true)
                    }
                }
                asset.selectAniamted = false
            } else {
                let alert = UIAlertController(title: nil, message: "您本次最多只能选择\(self.maxSelectionAllowed)张照片", preferredStyle: .alert)
                let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            asset.isSelected = false
            if var index = self.selectedAssetsPointer.pointee.index(of: asset) {
                self.selectedAssetsPointer.pointee.remove(at: index)
                if self.selectedAssetsPointer.pointee.count == self.maxSelectionAllowed - 1 {
                    selectionsJustUnFull = true
                    self.isSelectionsFullPointer.pointee = false
                }
                if index < self.selectedAssetsPointer.pointee.count {
                    selectionDeletedAtMiddle = true
                    let startIndex = index
                    for _ in startIndex..<self.selectedAssetsPointer.pointee.count {
                        self.selectedAssetsPointer.pointee[index].selectedOrder = index + 1
                        index += 1
                    }
                }
                PAPhotoPickerHelper.imageSize(of: [asset.phAsset], synchronous: true, completion: { (size) in
                    self.sumOfImageSizePointer.pointee -= size
                    if self.sumOfImageSizePointer.pointee <= 0 {
                        self.sumOfImageSizePointer.pointee = 0
                    }
                })
                cell.refreshButton(with: asset)
                selectionChanged = true
            }
            asset.selectAniamted = true
        }
        
        guard selectionChanged else { return }
        self.refreshBottomBar()
        guard let naviVc = self.navigationController as? PAPhotoPickerController else { return }
        naviVc.selections = self.selectedAssetsPointer.pointee.map({ (model) -> PHAsset in
            return model.phAsset
        })
        naviVc.selectionsChanged?(naviVc.selections)
        
        if selectionDeletedAtMiddle {
            collectionView.reloadData()
        }
        
        if selectionsJustUnFull {
            for asset in self.assets {
                asset.canSelect = true
            }
            collectionView.reloadData()
        }
    }
    
    fileprivate func imageButtonClicked(asset: PAAssetModel, showBrowserAnimated: Bool = true) {
        var imageWrappers  = [PAImageWrapper]()
        var needsPageIndex = false
        var initialIndex   = 0
        if self.selectedAssetsPointer.pointee.contains(asset) {
            for asset in selectedAssetsPointer.pointee {
                let wrapper = PAImageWrapper(highQualityImageUrl: nil, asset: asset.phAsset, shouldDownloadImage: false, placeholderImage: asset.cachedImage, imageContainer: nil)
                imageWrappers.append(wrapper)
            }
            initialIndex = asset.selectedOrder - 1
            needsPageIndex = true
        } else {
            let wrapper = PAImageWrapper(highQualityImageUrl: nil, asset: asset.phAsset, shouldDownloadImage: false, placeholderImage: asset.cachedImage, imageContainer: nil)
            imageWrappers = [wrapper]
        }
        let browser = PAImageBrowser(imageWrappers: imageWrappers, initialIndex: initialIndex)
        browser.needsSaveButton = false
        browser.needsPageIndex  = needsPageIndex
        browser.show(inView: navigationController?.view, animated: showBrowserAnimated, enlargingAnimated: showBrowserAnimated)
    }
}

@available(iOS 9.0, *)
extension PAPhotoPickerThumbnailController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let point = previewingContext.sourceView.convert(location, to: collectionView)
        guard
            let indexPath   = collectionView.indexPathForItem(at: point),
            let cell        = collectionView.cellForItem(at: indexPath) as? PAPhotoPickerThumbnailCell,
            let asset       = cell.asset
            else { return nil }
        previewingLocatedIndexPath = indexPath
        var placeholder: UIImage? = nil
        PAPhotoPickerHelper.image(for: asset.phAsset, synchronous: true, size: CGSize(width: 200, height: 200), resizeMode: .fast, completion: { (image, info) in
            placeholder = image
        })
        previewingContext.sourceRect = cell.frame
        let wrapper = PAImageWrapper(highQualityImageUrl: nil, asset: asset.phAsset, shouldDownloadImage: false, placeholderImage: placeholder, imageContainer: nil)
        let target = PAImageBrowserPreviewingController(imageWrapper: wrapper)
        target.preferredContentSize = target.supposedContentSize(with: placeholder)
        target.needsSaveAction = false
        target.needsCopyAction = false
        return target
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        guard
            let indexPath   = previewingLocatedIndexPath,
            let cell        = collectionView.cellForItem(at: indexPath) as? PAPhotoPickerThumbnailCell,
            let asset       = cell.asset
            else { return }
        imageButtonClicked(asset: asset, showBrowserAnimated: false)
    }
}

class PAPhotoPickerThumbnailCell: UICollectionViewCell {
    static let reuseIdentifier = "PAPhotoPickerThumbnailCell"
    fileprivate var imageButton  = UIButton()
    fileprivate var selectButton = PAPohtoPickerSelectButton()
    fileprivate var assetId: String!
    fileprivate var imageRequestId: PHImageRequestID?
    
    var showsSelectedOrder : Bool = true
    var imageButtonClicked : ((PAAssetModel?) -> Void)?
    var selectButtonClicked: ((PAAssetModel?) -> Void)?
    
    var asset: PAAssetModel? {
        didSet {
            guard let asset = asset else { return }
            assetId = asset.phAsset.localIdentifier
            var imageSize = imageButton.bounds.size
            if imageSize.width < PAPhotoPickerConfiguration.thumbnialImageSize.width {
                imageSize = PAPhotoPickerConfiguration.thumbnialImageSize
            }
            if asset.cachedImage == nil {
                if let imageRequestId = imageRequestId, imageRequestId != PHInvalidImageRequestID {
                    PHImageManager.default().cancelImageRequest(imageRequestId)
                }
                imageRequestId = PAPhotoPickerHelper.image(for: asset.phAsset, size: imageSize, resizeMode: .exact) { (image, _) in
                    guard self.assetId == asset.phAsset.localIdentifier else { return }
                    self.imageButton.setImage(image, for: .normal)
                    asset.cachedImage = image
                }
            } else {
                imageButton.setImage(asset.cachedImage, for: .normal)
            }
            refreshButton(with: asset, animated: asset.selectAniamted)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageButton)
        imageButton.clipsToBounds = true
        imageButton.imageView?.contentMode = .scaleAspectFill
        imageButton.addTarget(self, action: #selector(imageButtonDidClick), for: .touchUpInside)
        
        addSubview(selectButton)
        selectButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        selectButton.setBackgroundImage(#imageLiteral(resourceName: "btn_unselected"), for: .normal)
        selectButton.setBackgroundImage(#imageLiteral(resourceName: "btn_selected"), for: .selected)
        selectButton.sizeToFit()
        selectButton.addTarget(self, action: #selector(selectButtonDidClick), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshButton(with asset: PAAssetModel, animated: Bool = true) {
        selectButton.isSelected = asset.isSelected
        if showsSelectedOrder {
            if asset.selectedOrder > 0 {
                selectButton.setBackgroundImage(#imageLiteral(resourceName: "btn_order"), for: .selected)
                selectButton.setTitle("\(asset.selectedOrder)", for: .selected)
            } else {
                selectButton.setBackgroundImage(#imageLiteral(resourceName: "btn_unselected"), for: .normal)
                selectButton.setBackgroundImage(#imageLiteral(resourceName: "btn_selected"), for: .selected)
            }
        } else {
            selectButton.setBackgroundImage(#imageLiteral(resourceName: "btn_unselected"), for: .normal)
            selectButton.setBackgroundImage(#imageLiteral(resourceName: "btn_selected"), for: .selected)
        }
        // Tag: 实践发现给大量button(似乎是15个以上)的enabled置为false, 会有很大的图形性能损耗, 首先从刷新colletionView开始直到对应button的外观变为enabled为false的外观, 大概用了1秒; 其次, 滑动collectionView会有很大的帧率丢失, 从之前的60帧变为35帧左右.
//        imageButton.isEnabled = asset.canSelect
        // 故改为控制isUserInteractionEnabled和alpha.
        if asset.canSelect {
            imageButton.alpha = 1
        } else {
            imageButton.alpha = 0.5
        }
        if asset.isSelected, animated {
            selectionAnimation(layer: selectButton.layer)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageButton.frame = bounds
        let padding: CGFloat = 3
        let buttonSize: CGFloat = 22
        selectButton.frame = CGRect(x: frame.width - buttonSize - padding, y: frame.height - buttonSize - padding, width: buttonSize, height: buttonSize)
    }
    
    @objc private func selectButtonDidClick() {
        selectButtonClicked?(asset)
    }
    
    @objc private func imageButtonDidClick() {
        imageButtonClicked?(asset)
    }
    
    func selectionAnimation(layer:CALayer) {
        UIView.animate(withDuration: 0.15, delay: 0, options: [.beginFromCurrentState,.curveEaseInOut], animations: {
            layer.setValue(0.5, forKeyPath: "transform.scale")
        }) { _ in
            UIView.animate(withDuration: 0.15, delay: 0, options: [.beginFromCurrentState,.curveEaseInOut], animations: {
                layer.setValue(1.15, forKeyPath: "transform.scale")
            }, completion: { _ in
                UIView.animate(withDuration: 0.1, delay: 0, options: [.beginFromCurrentState,.curveEaseInOut], animations: {
                    layer.setValue(1, forKeyPath: "transform.scale")
                }, completion: nil)
            })
        }
    }
}

class PAPohtoPickerSelectButton: UIButton {
    /// 扩大点击区域
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let coefficient: CGFloat = 1.9
        let enlargedBounds = CGRect(x: -bounds.width * (coefficient - 1), y: -bounds.height * (coefficient - 1), width: bounds.width * coefficient, height: bounds.height * coefficient)
        return enlargedBounds.contains(point)
    }
}


