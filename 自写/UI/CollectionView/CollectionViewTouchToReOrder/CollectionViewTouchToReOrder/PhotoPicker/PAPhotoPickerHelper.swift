//
//  PAPhotoPickerModel.swift
//  tempaaa
//
//  Created by luozhijun on 2017/8/7.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit
import Photos

class PANavigationBarStyle {
    var tintColor: UIColor?
    var barTintColor: UIColor?
    var barStyle = UIBarStyle.default
    var titleAttributes: [String: Any]?
    var normalItemTitleAttributes: [String: Any]?
    var highlightedTitleAttributes: [String: Any]?
}

class PAAssetModel: Equatable {
    var phAsset       : PHAsset!
    var cachedImage   : UIImage?
    var isSelected    : Bool = false
    var selectAniamted: Bool = true
    var selectedOrder : Int  = 0
    var canSelect     : Bool = true
    
    static func ==(lhs: PAAssetModel, rhs: PAAssetModel) -> Bool {
        if lhs.phAsset == nil, rhs.phAsset == nil { return true }
        guard lhs.phAsset != nil, rhs.phAsset != nil else { return false }
        return lhs.phAsset!.localIdentifier == rhs.phAsset!.localIdentifier
    }
}

class PAAlbumModel {
    var title = ""
    var count = 0
    var isCameraRoll = false
    var result: PHFetchResult<PHAsset>?
    var firstAsset: PHAsset? {
        didSet {
            guard let firstAsset = firstAsset else { return }
            PAPhotoPickerHelper.image(for: firstAsset, synchronous: true, size: PAPhotoPickerConfiguration.thumbnialImageSize) { (image, _) in
                self.cover = image
            }
        }
    }
    var cover: UIImage?
    var assets = [PAAssetModel]()
}

class PAPhotoPickerConfiguration {
    static var thumbnialImageSize = CGSize(width: 240, height: 240)
    static var `default` : PAPhotoPickerConfiguration {
        return PAPhotoPickerConfiguration()
    }
    var maxSelectionAllowed      : Int  = 9
    var assetsSortAscending      : Bool = true
    var showsSelectedOrder       : Bool = true
    var allowsVideo              : Bool = true
    var allowsImage              : Bool = true
    var allowsSelectOriginalAsset: Bool = true
    /// fullScreenSize by default
    var imageSizeOnCompletion    : CGSize = CGSize(width: UIScreen.main.bounds.width * UIScreen.main.scale, height: UIScreen.main.bounds.width * UIScreen.main.scale)
}

class PAPhotoPickerHelper {
    fileprivate static var originalNaviBarAppearance = PANavigationBarStyle()
    
    /// 如果要获取原图, size参数传PHImageManagerMaximumSize即可.
    class func images(for assets: [PHAsset], size: CGSize, resizeMode: PHImageRequestOptionsResizeMode = .none, deliveryMode: PHImageRequestOptionsDeliveryMode = .highQualityFormat, completion: @escaping ([UIImage]) -> Void) {
        var result = [UIImage]()
        DispatchQueue.global().async {
            for asset in assets {
                self.image(for: asset, synchronous: true, size: size, resizeMode: resizeMode, deliveryMode: deliveryMode, completion: { (image, _) in
                    if let image = image {
                        result.append(image)
                    }
                })
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    @discardableResult
    class func originalImage(for asset: PHAsset, completion: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) -> PHImageRequestID {
        return image(for: asset, size: PHImageManagerMaximumSize, resizeMode: .exact, completion: completion)
    }
    
    @discardableResult
    class func image(for asset: PHAsset, synchronous: Bool = false, size: CGSize, resizeMode: PHImageRequestOptionsResizeMode = .none, contentMode: PHImageContentMode = .aspectFill, deliveryMode: PHImageRequestOptionsDeliveryMode = .highQualityFormat, progress: PHAssetImageProgressHandler? = nil, completion: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) -> PHImageRequestID {
        let options = PHImageRequestOptions()
        options.resizeMode             = resizeMode
        options.isSynchronous          = synchronous
        options.isNetworkAccessAllowed = true
        options.progressHandler        = progress
        options.deliveryMode           = deliveryMode
        
        let requestDegradedImage = {
            options.deliveryMode = .fastFormat
            options.resizeMode = .fast
            PHCachingImageManager.default().requestImage(for: asset, targetSize: PAPhotoPickerConfiguration.thumbnialImageSize, contentMode: contentMode, options: options, resultHandler: { (image, info) in
                completion(image, info)
            })
        }
        
        var metCompletion = false
        var defaultCompletionCalled = false
        if synchronous {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                guard metCompletion == false else { return }
                defaultCompletionCalled = true
                requestDegradedImage()
            }
        }
        
        return PHCachingImageManager.default().requestImage(for: asset, targetSize: size, contentMode: contentMode, options: options) { image, info in
            guard defaultCompletionCalled == false else { return }
            metCompletion = true
            if image == nil {
                requestDegradedImage()
            }
            
            guard let _ = info?[PHImageErrorKey] as? NSError, let isIniCloud = info?[PHImageResultIsInCloudKey] as? Bool, isIniCloud else {
                completion(image, info)
                return
            }
            
            let fullScreenSize = UIScreen.main.bounds.size.width * UIScreen.main.scale
            PHCachingImageManager.default().requestImage(for: asset, targetSize: CGSize(width: fullScreenSize, height: fullScreenSize), contentMode: contentMode, options: options, resultHandler: completion)
        }
    }
    
    class func imageSize(of assets: [PHAsset], synchronous: Bool, completion: @escaping (Int) -> Void) {
        let options = PHImageRequestOptions()
        options.isSynchronous = synchronous
        var size  = 0
        var index = 0
        for asset in assets {
            PHCachingImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (data, dataUTI, orientation, info) in
                index += 1
                size  += data?.count ?? 0
                if index >= assets.count {
                    completion(size)
                }
            })
        }
    }
    
    class func queryAlbumList(cameraRollOnly: Bool = false, ascending: Bool = true, allowsImage: Bool = true, allowsVideo: Bool = true, completion: @escaping ([PAAlbumModel]) -> Swift.Void) {
        if !allowsImage && !allowsVideo { completion([]) }
        
        DispatchQueue.global().async {
            let options = PHFetchOptions()
            if !allowsImage {
                options.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
            }
            if !allowsVideo {
                options.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
            }
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: ascending)]
            
            let cameraRoll   = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
            let smartAlbums  = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
            let streamAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumMyPhotoStream, options: nil)
            let userAlbums   = PHAssetCollection.fetchTopLevelUserCollections(with: nil)
            let sharedAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumCloudShared, options: nil)
            var albums = [smartAlbums, streamAlbums, userAlbums, sharedAlbums]
            if cameraRollOnly {
                albums = [cameraRoll]
            }
            
            var albumModels = [PAAlbumModel]()
            for item in albums {
                guard let result = item as? PHFetchResult<PHAssetCollection> else { continue }
                result.enumerateObjects({ (collection, index, _) in
                    if !collection.isKind(of: PHAssetCollection.self) { return }
                    // 过滤"最新删除"
                    if collection.assetCollectionSubtype.rawValue >= 214 { return }
                    
                    let assetResult = PHAsset.fetchAssets(in: collection, options: options)
                    guard assetResult.count > 0 else { return }
                    
                    let model = albumModel(with: collection.localizedTitle, ascending: ascending, assetResult: assetResult, allowsImage: allowsImage, allowsVideo: allowsVideo)
                    if collection.assetCollectionSubtype == .smartAlbumUserLibrary {
                        model.isCameraRoll = true
                        albumModels.insert(model, at: 0)
                    } else {
                        albumModels.append(model)
                    }
                })
            }
            
            DispatchQueue.main.async {
                completion(albumModels)
            }
        }
    }
    
    private class func albumModel(with title: String?, ascending: Bool = false, assetResult: PHFetchResult<PHAsset>, allowsImage: Bool = true, allowsVideo: Bool = false) -> PAAlbumModel {
        let model    = PAAlbumModel()
        model.title  = title ?? ""
        model.count  = assetResult.count
        model.result = assetResult
        if ascending {
            model.firstAsset = assetResult.lastObject
        } else {
            model.firstAsset = assetResult.firstObject
        }
        
        var assets   = [PAAssetModel]()
        let maxCount = 99999
        var counter  = 0
        assetResult.enumerateObjects({ (asset, index, stop) in
            if asset.mediaType == .image && !allowsImage { return }
            if asset.mediaType == .video && !allowsVideo { return }
            
            if counter > maxCount {
                stop.pointee = true
            }
            let assetModel = PAAssetModel()
            assetModel.phAsset = asset
            assets.append(assetModel)
            counter += 1
        })
        model.assets = assets
        return model
    }

    static func adjustNaviBarStyle() {
        let style       = UINavigationBar.appearance()
        originalNaviBarAppearance.tintColor    = style.tintColor
        originalNaviBarAppearance.barTintColor = style.barTintColor
        originalNaviBarAppearance.barStyle     = style.barStyle
        originalNaviBarAppearance.titleAttributes = style.titleTextAttributes
        originalNaviBarAppearance.normalItemTitleAttributes = UIBarButtonItem.appearance().titleTextAttributes(for: .normal)
        originalNaviBarAppearance.highlightedTitleAttributes = UIBarButtonItem.appearance().titleTextAttributes(for: .highlighted)
        
        style.barTintColor = nil
        style.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)]
    }
    
    static func resumeNaviBarStyle() {
        let style = UINavigationBar.appearance()
        style.barTintColor = originalNaviBarAppearance.barTintColor
        style.titleTextAttributes = originalNaviBarAppearance.titleAttributes
    }
}

public extension Int {
    var bytesSize: String {
        let mbAmount   = Double(1024 * 1024)
        let doubleSelf = Double(self)
        if doubleSelf > 0.1 * mbAmount {
            return String(format: "%.1fM", doubleSelf/mbAmount)
        } else if doubleSelf >= 1024 {
            return String(format: "%.0fK", doubleSelf/1024)
        } else {
            return "\(self)B"
        }
    }
}


