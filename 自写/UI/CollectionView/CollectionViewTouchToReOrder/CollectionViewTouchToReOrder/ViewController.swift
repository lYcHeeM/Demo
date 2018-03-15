//
//  ViewController.swift
//  CollectionViewTouchToReOrder
//
//  Created by luozhijun on 2018/3/14.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var gridViewLayout: UICollectionViewFlowLayout {
        let padding_15: CGFloat       = 15
        var gridViewDefaultFlowLayout = PAImageGridView.defaultLayout().flow
        let gridViewX                 = padding_15 - gridViewDefaultFlowLayout.minimumInteritemSpacing
        let gridViewWidth             = view.frame.width - 2 * gridViewX
        gridViewDefaultFlowLayout     = PAImageGridView.defaultLayout(fittingWidth: gridViewWidth).flow
        return gridViewDefaultFlowLayout
    }
    var selectedFullScreenImages = [UIImage]()
    var selectedThumbnails = [UIImage]() {
        didSet {
            var imagesModels = [PACompoundImage]()
            for image in selectedThumbnails {
                let compoundImage = PACompoundImage()
                compoundImage.image = image
                imagesModels.append(compoundImage)
            }
            imageGridView.dataSource = imagesModels
        }
    }
    
    var imageGridView: PAImageGridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        
        let padding_15:CGFloat = 15
        let gridViewX       = padding_15 - PAImageGridView.defaultLayout().flow.minimumInteritemSpacing
        let gridViewWidth   = view.frame.width - 2 * gridViewX
        
        imageGridView = PAImageGridView(flowLayout: gridViewLayout, dataSource: [], style: .picker)
        view.addSubview(imageGridView)
        imageGridView.backgroundColor = UIColor.white
        imageGridView.frame = CGRect(x: gridViewX, y: 200, width: gridViewWidth, height: gridViewLayout.itemSize.height * 3)
        imageGridView.numberOfImagesAllowed = 40
        imageGridView.alertControllerPresentedController = self
        imageGridView.itemClicked = { [weak self] (gridView, indexPath, visiableCells) in
        }
        imageGridView.showAlumbAction = { [weak self] _ in
            guard let `self` = self else { return }
            let config = ZJPhotoPickerConfiguration.default
            config.maxSelectionAllowed = 40
            config.allowsSelectOriginalAsset = true
            let picker = ZJPhotoPickerController(configuration: config)
            picker.presented(from: self, animated: true, completion: nil, imageQueryFinished: nil)
            picker.willDismissWhenDoneBtnClicked = { [weak self] images, assets in
                guard let `self` = self else { return }
                self.selectedFullScreenImages.append(contentsOf: images)
                ZJPhotoPickerHelper.images(for: assets, size: CGSize(width: 200, height: 200), completion: { (thumbnails) in
                    self.selectedThumbnails.append(contentsOf: thumbnails)
                })
            }
        }
        imageGridView.cameraImageSelectedAction = { [weak self] (_, compressdCameraImage) in
            self?.selectedFullScreenImages.append(compressdCameraImage)
            self?.selectedThumbnails.append(compressdCameraImage)
        }
        imageGridView.itemDeleteButtonClicked = { [weak self] (gridView, indexPath) in
            gridView.remove(imageAt: indexPath)
            self?.selectedFullScreenImages.remove(at: indexPath.row)
            self?.selectedThumbnails.remove(at: indexPath.row)
        }
    }
}

