//
//  PAPhotoPickerController.swift
//  tempaaa
//
//  Created by luozhijun on 2017/8/7.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit
import Photos

class PAPhotoPickerController: UINavigationController {
    var albumModels = [PAAlbumModel]() {
        didSet {
            albumListController.albumModels = albumModels
            albumListController.tableView.reloadData()
        }
    }
    fileprivate var albumListController: PAPhotoPickerAlbumListController!
    
    var selections = [PHAsset]()
    var configuration: PAPhotoPickerConfiguration!
    
    var selectionsChanged            : (([PHAsset]) -> Void)? = nil
    var selectionsFinished           : (([PHAsset]) -> Void)? = nil
    var willDismissWhenDoneBtnClicked: (([UIImage], [PHAsset]) -> Void)? = nil
    var didDismissWhenDoneBtnClicked : (([UIImage], [PHAsset]) -> Void)? = nil
    
    public required init(albumModels: [PAAlbumModel] = [], configuration: PAPhotoPickerConfiguration = PAPhotoPickerConfiguration.default) {
        let rootVc = PAPhotoPickerAlbumListController(albumModels: albumModels)
        super.init(nibName: nil, bundle: nil)
        self.pushViewController(rootVc, animated: false)
        self.albumListController = rootVc
        self.albumModels         = albumModels
        self.configuration       = configuration
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PAPhotoPickerHelper.adjustNaviBarStyle()
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 因弹出picker时只查询了"所有照片", 须查询其他相册
        // queryingRemainingAlbums
        let hud = PAMBManager.sharedInstance.showLoadingInView(view: albumListController.view, labelText: "请稍后...")
        PAPhotoPickerHelper.queryAlbumList(cameraRollOnly: false, ascending: self.configuration.assetsSortAscending, allowsImage: self.configuration.allowsImage, allowsVideo: self.configuration.allowsVideo) { (albumModels) in
            hud.hide(true)
            self.albumModels = albumModels
        }
    }
    
    func pushToCameraRollThumbnailController(animated: Bool) {
        var cameraRollIndex = 0
        for album in albumModels {
            if album.isCameraRoll { break }
            cameraRollIndex += 1
        }
        albumListController.pushingAnimated = animated
        albumListController.tableView(albumListController.tableView, didSelectRowAt: IndexPath(row: cameraRollIndex, section: 0))
    }
    
    func presented(from controller: UIViewController, animated: Bool, completion: (() -> Void)?, imageQueryFinished: (([PAAlbumModel]) -> Void)?) {
        controller.present(self, animated: animated, completion: completion)
        let pushingAction = {
            let hud = PAMBManager.sharedInstance.showLoadingInView(view: self.view, labelText: "请稍后...")
            PAPhotoPickerHelper.queryAlbumList(cameraRollOnly: true, ascending: self.configuration.assetsSortAscending, allowsImage: self.configuration.allowsImage, allowsVideo: self.configuration.allowsVideo) { (albumModels) in
                hud.hide(false)
                imageQueryFinished?(albumModels)
                self.albumModels = albumModels
                self.pushToCameraRollThumbnailController(animated: false)
            }
        }
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                guard status == .authorized else { return }
                DispatchQueue.main.async {
                    pushingAction()
                }
            })
        } else if status == .restricted || status == .denied {
            setupAuthorizationFailedUI()
        } else {
            pushingAction()
        }
    }
    
    private func setupAuthorizationFailedUI() {
        let hintLabel = UILabel()
        view.addSubview(hintLabel)
        hintLabel.text = "\"\(PAUtil.appName)\"没有权限访问您的照片或视频\n在\"设置-隐私-图片\"中开启后即可查看"
        hintLabel.font = UIFont.systemFont(ofSize: 15)
        hintLabel.textColor = UIColor.gray
        hintLabel.numberOfLines = 0
        hintLabel.textAlignment = .center
        let maxSize = CGSize(width: view.frame.width - 50, height: CGFloat.greatestFiniteMagnitude)
        let hintLabelNeedSize = hintLabel.sizeThatFits(maxSize)
        hintLabel.frame = CGRect(x: (view.frame.width - hintLabelNeedSize.width)/2, y: 120 + 64, width: hintLabelNeedSize.width, height: hintLabelNeedSize.height)
        
        let button = UIButton(type: .system)
        view.addSubview(button)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitle("前往设置", for: .normal)
        button.tintColor = UIColor.paOrange
        button.addTarget(self, action: #selector(goPreferenceUrl), for: .touchUpInside)
        button.sizeToFit()
        button.center.x = hintLabel.center.x
        button.frame.origin.y = hintLabel.frame.maxY + 1
    }
    
    @objc private func goPreferenceUrl() {
        if let url = URL(string: UIApplicationOpenSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
}

class PAPhotoPickerAlbumListController: UITableViewController {
    fileprivate var albumModels          = [PAAlbumModel]()
    fileprivate var thumbnialControllers = [PAPhotoPickerThumbnailController]()
    fileprivate var selectedAssets       = [PAAssetModel]()
    fileprivate var sumOfImageSize       = 0
    fileprivate var isOriginal           = false
    fileprivate var isSelectionsFull     = false
    fileprivate var pushingAnimated      = true
    
    required init(albumModels: [PAAlbumModel]) {
        super.init(style: .plain)
        self.albumModels = albumModels
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "照片"
        tableView.tableFooterView = UIView()
        tableView.layoutMargins = .zero
        tableView.separatorInset = .zero
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(dismissNav))
    }
    
    @objc private func dismissNav() {
        PAPhotoPickerHelper.resumeNaviBarStyle()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PAPhotoPickerAlbumInfoCell! = tableView.dequeueReusableCell(withIdentifier: "cell") as? PAPhotoPickerAlbumInfoCell
        if cell == nil {
            cell = PAPhotoPickerAlbumInfoCell(style: .default, reuseIdentifier: "cell", fixedImageSize: CGSize(width: 60, height: 60))
            cell.accessoryView = UIImageView(image: #imageLiteral(resourceName: "pa_rightArrow"))
        }
        let album = albumModels[indexPath.row]
        cell.imageView?.image = album.cover
        
        let attrTitle = NSMutableAttributedString(string: album.title, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)])
        attrTitle.append(NSAttributedString(string: "（\(album.count)）", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.lightGray]))
        cell.textLabel?.attributedText = attrTitle
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 + 2*(1/UIScreen.main.scale)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hud = PAMBManager.sharedInstance.showLoadingInView(view: view, labelText: "请稍后...")
        let assets = self.albumModels[indexPath.row].assets
        
        if assets.count >= 2000 {
            DispatchQueue.global().async {
                self.sameAssetsManipulation(assets)
                DispatchQueue.main.async {
                    self.pushing(with: indexPath, assets: assets, hiding: hud, title: self.albumModels[indexPath.row].title)
                }
            }
        } else {
            sameAssetsManipulation(assets)
            pushing(with: indexPath, assets: assets, hiding: hud, title: albumModels[indexPath.row].title)
        }
    }
    
    private func sameAssetsManipulation(_ assets: [PAAssetModel]) {
        for asset in assets {
            asset.isSelected = false
        }
        for selection in self.selectedAssets {
            selection.isSelected = true
        }
        for asset in assets {
            for selection in self.selectedAssets {
                if asset == selection {
                    asset.isSelected = true
                    asset.selectedOrder = selection.selectedOrder
                }
            }
        }
    }
    
    private func pushing(with indexPath: IndexPath, assets: [PAAssetModel], hiding hud: MBProgressHUD?, title: String) {
        var thumbnailVc: PAPhotoPickerThumbnailController!
        if self.thumbnialControllers.count > indexPath.row {
            thumbnailVc = self.thumbnialControllers[indexPath.row]
            thumbnailVc.assets = assets
            thumbnailVc.isSelectionFull = isSelectionsFull
            thumbnailVc.title = title
        } else {
            thumbnailVc = PAPhotoPickerThumbnailController(assets: self.albumModels[indexPath.row].assets, selectedAssetsPointer: &self.selectedAssets, sumOfImageSizePointer: &self.sumOfImageSize, isOriginalPointer: &isOriginal, isSelectionsFullPointer: &isSelectionsFull)
            self.thumbnialControllers.append(thumbnailVc)
            thumbnailVc.title = title
        }
        hud?.hide(false)
        self.navigationController?.pushViewController(thumbnailVc, animated: pushingAnimated)
        pushingAnimated = true
    }
}

class PAPhotoPickerAlbumInfoCell: UITableViewCell {
    private var fixedImageSize: CGSize = .zero
    
    required init(style: UITableViewCellStyle, reuseIdentifier: String?, fixedImageSize: CGSize) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.fixedImageSize      = fixedImageSize
        imageView?.contentMode   = .scaleAspectFill
        imageView?.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageView = imageView, let image = imageView.image, image.size.width > 0.5 else { return }
        imageView.frame.size = fixedImageSize
        imageView.frame.origin.y = (frame.height - imageView.frame.height)/2
        textLabel?.frame.origin.x = imageView.frame.maxX + 15
        if separatorInset.left != imageView.frame.origin.x {
            separatorInset = UIEdgeInsets(top: 0, left: imageView.frame.origin.x, bottom: 0, right: 0)
        }
    }
}

