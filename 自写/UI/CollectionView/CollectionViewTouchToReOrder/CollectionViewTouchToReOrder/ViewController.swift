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
        gridViewDefaultFlowLayout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
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
            imageGridView.reloadData()
        }
    }
    
    var imageGridView: PAImageGridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        
        let hintLabel = UILabel()
        view.addSubview(hintLabel)
        hintLabel.text = "工作台模型👇👇👇"
        hintLabel.font = UIFont.boldSystemFont(ofSize: 28)
        let needsSize = hintLabel.sizeThatFits(CGSize.init(width: 10000, height: 10000))
        hintLabel.frame = CGRect.init(x: (view.frame.width - needsSize.width)/2, y: 140, width: needsSize.width, height: needsSize.height)
        
        let padding_15:CGFloat = 15
        let gridViewX       = padding_15 - PAImageGridView.defaultLayout().flow.minimumInteritemSpacing
        let gridViewWidth   = view.frame.width - 2 * gridViewX
        
        imageGridView = PAImageGridView(flowLayout: gridViewLayout, dataSource: [], style: .picker)
        view.addSubview(imageGridView)
        imageGridView.frame = CGRect(x: gridViewX, y: 200, width: gridViewWidth, height: gridViewLayout.itemSize.height * 4)
        
        imageGridView.backgroundColor = UIColor.white
        imageGridView.layer.shadowOffset = CGSize(width: 0.25, height: 0.25)
        imageGridView.layer.shadowColor = UIColor.black.cgColor
        imageGridView.layer.shadowOpacity = 0.6
        imageGridView.layer.shadowRadius = 2
        imageGridView.layer.shadowPath = UIBezierPath(rect: imageGridView.bounds).cgPath
        
        imageGridView.gridCornerRadius = 0
        imageGridView.numberOfImagesAllowed = 99
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
        imageGridView.itemDeleteButtonClicked = { (gridView, indexPath) in
            gridView.remove(imageAt: indexPath)
        }
        imageGridView.dataSourceDidRemoveAt = { [weak self] index in
            self?.selectedFullScreenImages.remove(at: index)
            self?.selectedThumbnails.remove(at: index)
        }
        imageGridView.dataSourceDidInsertAfterRemove = { [weak self] removedIndex, insertedIndex in
            guard let `self` = self else { return }
            var model = self.selectedThumbnails.remove(at: removedIndex)
            self.selectedThumbnails.insert(model, at: insertedIndex)
            model = self.selectedFullScreenImages.remove(at: removedIndex)
            self.selectedFullScreenImages.insert(model, at: insertedIndex)
        }
    }
}

