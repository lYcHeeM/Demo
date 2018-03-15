//
//  PAImageGridView.swift
//  asdfaf
//
//  Created by luozhijun on 2017/2/20.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage

/** 混合型图片模型, 主要考虑到, 一张图片既可由url指代, 也可直接由矩阵向量描述 */
class PACompoundImage: Equatable {
    var image           : UIImage?
    var fullScreenImage : UIImage?
    var urlString       : String?
    var imgInfo         : String?
    var isHidden        = false
    
    class func instances(with images: [UIImage?]) -> [PACompoundImage] {
        var result = [PACompoundImage]()
        for image in images {
            let item = PACompoundImage()
            item.image = image
            result.append(item)
        }
        return result
    }
    
    class func instances(with urlStrings: [String?]) -> [PACompoundImage] {
        var result = [PACompoundImage]()
        for urlString in urlStrings {
            let item = PACompoundImage()
            item.urlString = urlString
            result.append(item)
        }
        return result
    }
    
    static func == (lhs: PACompoundImage, rhs: PACompoundImage) -> Bool {
        return lhs.image == rhs.image && lhs.urlString == rhs.urlString
    }
}

/** 把选择好的图片展示为网格的视图, 在最后一张图片之后会有一个额外加号按钮 */
class PAImageGridView: UIView, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    enum Style: Int {
        case picker
        case custom
    }
    private(set) var style: Style
    
    var numberOfImagesAllowed     = 4
    var numberOfImagesInOneLine   = 4
    var gridCornerRadius: CGFloat = 2.0
    var needsAddButton = true
    var needsCloseButton = true
    var needsImgInfoLabel = false
    
    fileprivate var gridCollectionView: UICollectionView!
    var dataSource = [PACompoundImage]() {
        didSet {
            gridCollectionView.reloadData()
        }
    }
    
    private var longPressedCell: PAImageGridCell!
    private var copyedLongPressedCell: PAImageGridCell!
    private var longPressedCellOriginalFrame: CGRect = .zero
    private var indexPathOfLongPressedCell: IndexPath!
    private var isLastItemMovingFinished = true
    
    var itemClicked            : ((PAImageGridView, IndexPath, [PAImageGridCell]) -> Swift.Void)?
    var plusButtonDidClick     : ((PAImageGridView)            -> Swift.Void)?
    var itemDeleteButtonClicked: ((PAImageGridView, IndexPath) -> Swift.Void)?
    
    weak var alertControllerPresentedController: UIViewController?
    var alertControllerForDecidingAlbumOrCamera: UIAlertController {
        self.alertControllerPresentedController?.view.endEditing(true)
        let albumAction = UIAlertAction(title: "手机相册", style: .default) { (_) in
            self.showAlumbAction?(self)
        }
        
        let cameraAction = UIAlertAction(title: "相机", style: .default) { (_) in
            let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            if authStatus == .denied || authStatus == .restricted {
                print("AVCapture authorization failed!")
            } else {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                self.alertControllerPresentedController?.present(imagePicker, animated: true, completion: nil)
            }
        }
        var actions = [albumAction]
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actions.append(cameraAction)
        }
        let alertVc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVc.addAction(albumAction)
        alertVc.addAction(cameraAction)
        alertControllerPresentedController?.present(alertVc, animated: true, completion: nil)
        return alertVc
    }
    var showAlumbAction          : ((PAImageGridView)          -> Swift.Void)?
    var cameraImageSelectedAction: ((PAImageGridView, UIImage) -> Swift.Void)?
    
    static func defaultLayout(fittingWidth: CGFloat = UIScreen.main.bounds.width, fittingImageCount: Int = 0, minimumInteritemSpacing: CGFloat = 8, minimumLineSpacing: CGFloat = 8, numberOfImagesInOneLine: Int = 4) -> (flow: UICollectionViewFlowLayout, heightToShowAllImages: CGFloat) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
        flowLayout.minimumLineSpacing      = minimumLineSpacing
        let numberOfImagesInOneLine        = numberOfImagesInOneLine
        let gridWidth                      = (fittingWidth - CGFloat(numberOfImagesInOneLine + 1) * flowLayout.minimumInteritemSpacing)/CGFloat(numberOfImagesInOneLine)
        flowLayout.itemSize                = CGSize(width: gridWidth, height: gridWidth)
        
        var needHeight: CGFloat = gridWidth
        if fittingImageCount > numberOfImagesInOneLine {
            let lines = (fittingImageCount - 1) / numberOfImagesInOneLine + 1
            needHeight = CGFloat(lines) * gridWidth + CGFloat(lines - 1) * flowLayout.minimumLineSpacing
        }
        return (flowLayout, needHeight)
    }
    
    required init(frame: CGRect = .zero, flowLayout: UICollectionViewFlowLayout = PAImageGridView.defaultLayout().flow, dataSource: [PACompoundImage], style: Style) {
        self.style = style
        if style == .picker {
            needsAddButton = true
            needsCloseButton = true
            needsImgInfoLabel = false
        }
        super.init(frame: frame)
        self.dataSource = dataSource
        
        gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        gridCollectionView.backgroundColor = .white
        gridCollectionView.dataSource      = self
        gridCollectionView.delegate        = self
        gridCollectionView.contentInset    = UIEdgeInsets(top: 0, left: flowLayout.minimumInteritemSpacing, bottom: 0, right: flowLayout.minimumInteritemSpacing)
        gridCollectionView.register(PAImageGridCell.self, forCellWithReuseIdentifier: PAImageGridCell.reuseIdentifier)
        gridCollectionView.register(PAImageGridPlusCell.self, forCellWithReuseIdentifier: "plus")
        addSubview(gridCollectionView)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(gridCollectionViewLongPressed))
        longPressGesture.minimumPressDuration = 0.35
        gridCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gridCollectionView.frame = bounds
    }
    
    func append(image: PACompoundImage) {
        dataSource.append(image)
    }
    
    func remove(imageAt indexPath: IndexPath) {
        gridCollectionView.deselectItem(at: indexPath, animated: true)
        dataSource.remove(at: indexPath.item)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let imageData = UIImageJPEGRepresentation(originalImage, 0.6) {
                if let compressedImage = UIImage(data: imageData) {
                    cameraImageSelectedAction?(self, compressedImage)
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    /// 长按某个cell后重排序
    @objc private func gridCollectionViewLongPressed(sender: UIGestureRecognizer) {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        let point = sender.location(in: gridCollectionView)
        switch sender.state {
        case .began:
            guard let indexPath = gridCollectionView.indexPathForItem(at: point) else { return }
            guard let longPressedCell = gridCollectionView.cellForItem(at: indexPath) as? PAImageGridCell else { return }
            
            // 拷贝一个cell，用于显示到窗口
            copyedLongPressedCell = PAImageGridCell(frame: longPressedCell.frame)
            copyedLongPressedCell.supposedItemSize = longPressedCell.bounds.size
            copyedLongPressedCell.imageModel = longPressedCell.imageModel
            
            // 隐藏当前cell，注意到cell重用机制，需要用数据控制
            longPressedCell.imageModel?.isHidden = true
            longPressedCell.isHidden = true
            self.longPressedCell = longPressedCell
            
            self.indexPathOfLongPressedCell = indexPath
            self.longPressedCellOriginalFrame = longPressedCell.frame
            
            // 把当前长按的cell的frame映射到window
            let newFrame = gridCollectionView.convert(longPressedCell.frame, to: keyWindow)
            keyWindow.addSubview(copyedLongPressedCell)
            copyedLongPressedCell.frame = newFrame
            
            // 动画显示拷贝的view：中心位置移动到触摸处；加透明度和阴影；稍微放大。
            let pointInWindow = gridCollectionView.convert(point, to: keyWindow)
            UIView.animate(withDuration: 0.25, animations: {
                self.copyedLongPressedCell.center = pointInWindow
                
                self.copyedLongPressedCell.alpha = 0.7
                self.copyedLongPressedCell.layer.shadowOffset = CGSize(width: 0.25, height: 0.25)
                self.copyedLongPressedCell.layer.shadowColor = UIColor.black.cgColor
                self.copyedLongPressedCell.layer.shadowOpacity = 0.6
                self.copyedLongPressedCell.layer.shadowRadius = 2
                self.copyedLongPressedCell.layer.shadowPath = UIBezierPath(rect: longPressedCell.bounds).cgPath
                
                self.copyedLongPressedCell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            })
        case .changed:
            copyedLongPressedCell.center = gridCollectionView.convert(point, to: keyWindow)
            
            // 当拖动拷贝的cell快要达到collectionView边界时，尝试上下滚动collectionView
            var targetContentOffsetY: CGFloat = -1
            let stepLength: CGFloat = 30
            let value = gridCollectionView.contentSize.height - gridCollectionView.bounds.height
            if point.y - gridCollectionView.contentOffset.y + copyedLongPressedCell.frame.height/2 >= gridCollectionView.bounds.height, value > 0, gridCollectionView.contentOffset.y < value {
                targetContentOffsetY = gridCollectionView.contentOffset.y + stepLength
                if targetContentOffsetY > value { targetContentOffsetY = value }
            } else if point.y - copyedLongPressedCell.frame.height/2 <= gridCollectionView.contentOffset.y, value > 0, gridCollectionView.contentOffset.y > 0 {
                targetContentOffsetY = gridCollectionView.contentOffset.y - stepLength
                if targetContentOffsetY < 0 { targetContentOffsetY = 0 }
            }
            if targetContentOffsetY != -1 {
                gridCollectionView.setContentOffset(CGPoint.init(x: gridCollectionView.contentOffset.x, y: targetContentOffsetY), animated: true)
            }
            
            for cell in gridCollectionView.visibleCells {
                guard let indexPath = gridCollectionView.indexPath(for: cell), indexPath != indexPathOfLongPressedCell else { continue }
                guard let cell = gridCollectionView.cellForItem(at: indexPath), !(cell is PAImageGridPlusCell) else { continue }
                // 计算两个cell之间的距离根号((x2 - x1)^2 + (y2 - y1)^2)，简单起见，此处姑且认为，
                // 如果此距离小于cell宽度的一半，则交换cell的位置
                let centerInCollectionView = keyWindow.convert(copyedLongPressedCell.center, to: gridCollectionView)
                let spaceX = fabs(cell.center.x - centerInCollectionView.x)
                let spaceY = fabs(cell.center.y - centerInCollectionView.y)
                let distanceBetweenTwoCells = sqrt(pow(spaceX, 2) + pow(spaceY, 2))
                if distanceBetweenTwoCells < cell.frame.width/2, isLastItemMovingFinished {
                    // 版本1 不可行，因为并不是简单的交换元素操作
//                    dataSource.exchange(elementAt: self.indexPathOfLongPressedCell.row, withElementAt: indexPath.row)
                    // 版本2 可行
//                    let model = dataSource[indexPathOfLongPressedCell.row]
//                    if indexPath.row > indexPathOfLongPressedCell.row {
//                        for index in indexPathOfLongPressedCell.row..<indexPath.row {
//                            dataSource[index] = dataSource[index + 1]
//                        }
//                    } else {
//                        var index = indexPathOfLongPressedCell.row
//                        for _ in indexPath.row..<indexPathOfLongPressedCell.row {
//                            dataSource[index] = dataSource[index - 1]
//                            index -= 1
//                        }
//                    }
//                    dataSource.replace(elementAt: indexPath.row, with: model)
                    
                    // 版本3 最简洁
//                    let model = dataSource.remove(at: indexPathOfLongPressedCell.row)
//                    dataSource.insert(model, at: indexPath.row)
                    
                    // 为了防止在上次moveItem的动画未完成前再次触发moveItem动画，
                    // 否则，实践发现会出现动画错乱
                    isLastItemMovingFinished = false
                    gridCollectionView.performBatchUpdates({
                        // 版本3 最简洁，注意到remove一个元素后，后面元素的填补操作API内部已经做了
                        let model = dataSource.remove(at: indexPathOfLongPressedCell.row)
                        dataSource.insert(model, at: indexPath.row)
                        
                        // moveItem函数会触发数据源方法，所以一定要先修改数据源
                        gridCollectionView.moveItem(at: indexPathOfLongPressedCell, to: indexPath)
                    }, completion: { (_) in
                        self.isLastItemMovingFinished = true
                    })
                    // 这句代码不能放在上面的completion回调中执行，因为考虑到用户拖动一个cell后，
                    // 插入到某个位置后马上就放手了，moveItem的动画还没来得及执行玩，手势就已经变为
                    // 了ended状态，结果就是ended case中的代码用到的`indexPathOfLongPressedCell`
                    // 是非预期的（即错误的）。
                    indexPathOfLongPressedCell = indexPath
                }
            }
        case .ended:
            // 结束动画期间，为安全起见，把collectionView设为不可接受事件
            gridCollectionView.isUserInteractionEnabled = false
            // 获取当前手势钉住的拷贝的cell所对应的collectionView上的cell，即被隐藏的cell。
            guard let cell = gridCollectionView.cellForItem(at: indexPathOfLongPressedCell) as? PAImageGridCell else { return }
            // 把这个cell的中心位置映射到窗口，用动画把显示在窗口上的cell回到这个中心位置；
            // 动画结束后移除这个cell，并恢复显示被隐藏的cell。
            let center = gridCollectionView.convert(cell.center, to: keyWindow)
            UIView.animate(withDuration: 0.25, animations: {
                self.copyedLongPressedCell.center = center
                self.copyedLongPressedCell.transform = .identity
                self.copyedLongPressedCell.alpha = 1
            }, completion: { (_) in
                self.copyedLongPressedCell.removeFromSuperview()
                cell.imageModel?.isHidden = false
                cell.isHidden = false
                self.gridCollectionView.isUserInteractionEnabled = true
                // 清除数据
                self.indexPathOfLongPressedCell = nil
                self.copyedLongPressedCell = nil
            })
        default:
            return
        }
    }
}

extension PAImageGridView : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataSource.count < numberOfImagesAllowed, needsAddButton {
            return dataSource.count + 1
        } else {
            return dataSource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < dataSource.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PAImageGridCell.reuseIdentifier, for: indexPath) as! PAImageGridCell
            let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            cell.needsCloseButton = needsCloseButton
            cell.needsInfoLabel = needsImgInfoLabel
            cell.supposedItemSize = flowLayout.itemSize
            cell.imageCornerRadius = gridCornerRadius
            cell.imageModel = dataSource[indexPath.item]
            cell.imageViewDidClick = { [weak self] _ in
                guard self != nil else { return }
                var visibleCells = [PAImageGridCell]()
                for cell in self!.gridCollectionView.visibleCells {
                    if let cell = cell as? PAImageGridCell {
                        visibleCells.append(cell)
                    }
                }
                visibleCells.sort(by: { (obj1, obj2) -> Bool in
                    if let path1 = self!.gridCollectionView.indexPath(for: obj1), let path2 = self!.gridCollectionView.indexPath(for: obj2) {
                        return path1 < path2
                    } else {
                        return true
                    }
                })
                self?.itemClicked?(self!, indexPath, visibleCells)
            }
            cell.closeButtonDidClick = { [weak self] _ in
                guard self != nil else { return }
                self?.itemDeleteButtonClicked?(self!, indexPath)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "plus", for: indexPath) as! PAImageGridPlusCell
            cell.plusButtonDidClick = { [weak self] in
                guard self != nil else { return }
                _ = self?.alertControllerForDecidingAlbumOrCamera
                self?.plusButtonDidClick?(self!)
            }
            return cell
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row < dataSource.count {
//            itemClicked?(self, indexPath)
//        } else {
//
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if indexPath.row < dataSource.count {
            return true
        } else {
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataSource.exchange(elementAt: sourceIndexPath.item, withElementAt: destinationIndexPath.item)
    }
}

class PAImageGridCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PAImageGridCell"
    
    fileprivate var imageView = UIImageView()
    fileprivate var closeButton = UIButton()
    fileprivate var infoLabel  = UILabel()
    var needsCloseButton = true {
        didSet {
            closeButton.isHidden = !needsCloseButton
        }
    }
    var needsInfoLabel = false {
        didSet {
            infoLabel.isHidden = !needsInfoLabel
        }
    }
    
    var imageContainer: UIImageView {
        return imageView
    }
    
    var supposedItemSize : CGSize = .zero
    var imageCornerRadius: CGFloat = 2.0
    
    var imageModel: PACompoundImage? {
        didSet {
            if let url = URL(string: (imageModel?.urlString).noneNull) {
                imageView.setShowActivityIndicator(true)
                imageView.setIndicatorStyle(.gray)
                imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "whiteplaceholder"), options: [.retryFailed, .avoidAutoSetImage]) { [weak self] (image, error, cacheType, url) in
                    if self != nil, error == nil, image != nil {
                        self?.imageView.image = image
                        self?.imageView.roundingImage(forRadius: self!.imageCornerRadius, sizeToFit: self!.supposedItemSize)
                    }
                }
            } else {
                imageView.image = imageModel?.image
                imageView.roundingImage(forRadius: imageCornerRadius, sizeToFit: supposedItemSize)
            }
            infoLabel.text = imageModel?.imgInfo
            isHidden = imageModel?.isHidden ?? false
        }
    }
    var imageViewDidClick  : ((PAImageGridCell) -> Swift.Void)?
    var closeButtonDidClick: ((PAImageGridCell) -> Swift.Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped)))
        
        contentView.addSubview(closeButton)
        closeButton.setImage(UIImage(named: "ic_shanchu"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        
        contentView.addSubview(infoLabel)
        infoLabel.font = UIFont.systemFont(ofSize: 10)
        infoLabel.textColor = UIColor.white
        infoLabel.textAlignment = .center
        infoLabel.backgroundColor = UIColor(white: 0, alpha: 0.5)
        infoLabel.text = "  "
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        
        var closeButtonSize = CGSize(width: 16, height: 16)
        if let closeImage   = closeButton.currentImage {
            closeButtonSize = closeImage.size
        }
        let closeButtonX = frame.width - closeButtonSize.width - 1.5
        let closeButtonY: CGFloat = 1
        closeButton.frame = CGRect(x: closeButtonX, y: closeButtonY, width: closeButtonSize.width, height: closeButtonSize.height)
        
        let infoLabelNeedsHeight = infoLabel.sizeThatFits(CGSize(width: frame.width, height: frame.height)).height
        infoLabel.frame = CGRect(x: 0, y: frame.height - infoLabelNeedsHeight, width: frame.width, height: infoLabelNeedsHeight)
    }
    
    @objc fileprivate func closeButtonClicked() {
        closeButtonDidClick?(self)
    }
    
    @objc private func imageViewTapped() {
        imageViewDidClick?(self)
    }
}

class PAImageGridPlusCell: UICollectionViewCell {
    fileprivate var plusButton = UIButton(type: .system)
    var plusButtonDidClick: (() -> Swift.Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(plusButton)
        plusButton.setBackgroundImage(UIImage(named: "tianjiazhaopian")?.withRenderingMode(.alwaysOriginal), for: .normal)
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

// MARK: - String
public protocol  OptionalString {}
extension String : OptionalString {}
public extension Optional where Wrapped: OptionalString {
    /// 对可选类型的String(String?)安全解包
    public var noneNull: String {
        if let value = self as? String {
            return value
        } else {
            return ""
        }
    }
}
    
extension Array {
    public mutating func exchange(elementAt sourceIndex: Int, withElementAt targetIndex: Int) {
        if sourceIndex == targetIndex { return }
        let targetElement = self[targetIndex]
        let sourceElement = remove(at: sourceIndex)
        insert(targetElement, at: sourceIndex)
        remove(at: targetIndex)
        insert(sourceElement, at: targetIndex)
    }
    
    public mutating func replace(elementAt index: Int, with element: Element) {
        remove(at: index)
        insert(element, at: index)
    }
}
