//
//  PAPermanentTeethView.swift
//  TeethGraph
//
//  Created by luozhijun on 2017/9/12.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

/// 牙位视图
class PATeethView: UIView {
    fileprivate var bgView  = UIImageView()
    fileprivate var bgImage: UIImage!
    fileprivate var upperMandibleBtn: UIButton!
    fileprivate var fullSelectionBtn: UIButton!
    fileprivate var lowerMandibleBtn: UIButton!
    fileprivate var teethButtons     = [UIButton]()
    fileprivate var teethTitleLabels = [String: UILabel]()
    
    static let permanentTeethNumbers = [11, 12, 13, 14, 15, 16, 17, 18, 21, 22, 23, 24, 25, 26, 27, 28, 31, 32, 33, 34, 35, 36, 37, 38, 41, 42, 43, 44, 45, 46, 47, 48]
    static let deciduousTeethNumbers = [51, 52, 53, 54, 55, 61, 62, 63, 64, 65, 71, 72, 73, 74, 75, 81, 82, 83, 84, 85]
    
    enum PATeethViewType {
        case permanent
        case deciduous
    }
    
    fileprivate var type: PATeethViewType!
    fileprivate(set) var selectedTeethNumbers = [Int]()
    var preselectedTeethNumbers = [Int]()
    var allowsMultiSelecting = true
    var allowsArealSelecting = true
    
    init(frame: CGRect, type: PATeethViewType, preselectedTeethNumbers: [Int]) {
        super.init(frame: frame)
        self.type = type
        self.preselectedTeethNumbers = preselectedTeethNumbers
        self.selectedTeethNumbers = preselectedTeethNumbers
        if type == .permanent {
            bgImage = #imageLiteral(resourceName: "bg_teeth_permanent")
        } else {
            bgImage = #imageLiteral(resourceName: "bg_teeth_deciduous")
        }
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        guard type == .permanent else { return }
        teethButtons.forEach {
            $0.removeObserver(self, forKeyPath: "highlighted")
            $0.removeObserver(self, forKeyPath: "selected")
        }
    }
    
    private func setupSubviews() {
        // 相对于设计稿(基于375屏幕尺寸)的放大系数
        let screenScale = UIScreen.main.bounds.width/375
        
        addSubview(bgView)
        bgView.image = bgImage
        bgView.contentMode = .scaleToFill
        let bgViewHeight = frame.width * (bgImage.size.height/bgImage.size.width)
        bgView.frame = CGRect(x: 0, y: 0, width: frame.width, height: bgViewHeight)
        bgView.center = CGPoint(x: frame.width/2, y: frame.height/2)
        bgView.isUserInteractionEnabled = true
        
        upperMandibleBtn = circleButton(withTitle: "上颌", size: screenScale * 46, fontSize: 14)
        fullSelectionBtn = circleButton(withTitle: "全选", size: screenScale * 61, fontSize: 16)
        lowerMandibleBtn = circleButton(withTitle: "下颌", size: screenScale * 46, fontSize: 14)
        
        let verticalLineSegmentedViewHeight = screenScale * (type == .permanent ? 325 : 269)
        let verticalLineSegmentedViewWidth  = fullSelectionBtn.bounds.width
        let verticalLineSegmentedViewFrame  = CGRect(x: (frame.width - verticalLineSegmentedViewWidth)/2, y: (frame.height - verticalLineSegmentedViewHeight)/2, width: verticalLineSegmentedViewWidth, height: verticalLineSegmentedViewHeight)
        let verticalLineSegmentedView = PALineSegmentedView(frame: verticalLineSegmentedViewFrame, separatingViews: [upperMandibleBtn, fullSelectionBtn, lowerMandibleBtn], lineColor: fullSelectionBtn.backgroundColor!, layoutDirection: .vertical)
        addSubview(verticalLineSegmentedView)
        
        let leftHintLabel  = label(withText: "左")
        let rightHintLabel = label(withText: "右")
        let horizontalLineSegmentedViewWidth  = screenScale * 71
        let horizontalLineSegmentedViewHeight = leftHintLabel.bounds.size.height
        let leftLineSegmentedViewFrame = CGRect(x: (frame.width - fullSelectionBtn.bounds.width)/2  - horizontalLineSegmentedViewWidth, y: (frame.height - horizontalLineSegmentedViewHeight)/2, width: horizontalLineSegmentedViewWidth, height: horizontalLineSegmentedViewHeight)
        let leftLineSegmentedView = PALineSegmentedView(frame: leftLineSegmentedViewFrame, separatingViews: [leftHintLabel], lineColor: fullSelectionBtn.backgroundColor!, layoutDirection: .horizontal)
        addSubview(leftLineSegmentedView)
        
        let rightLineSegmentedViewFrame = CGRect(x: verticalLineSegmentedView.frame.maxX, y: leftLineSegmentedViewFrame.origin.y, width: horizontalLineSegmentedViewWidth, height: horizontalLineSegmentedViewHeight)
        let rightLineSegmentedView = PALineSegmentedView(frame: rightLineSegmentedViewFrame, separatingViews: [rightHintLabel], lineColor: fullSelectionBtn.backgroundColor!, layoutDirection: .horizontal)
        addSubview(rightLineSegmentedView)
    }
    
    private func circleButton(withTitle title: String, size: CGFloat, fontSize: CGFloat) -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.setTitle(title, for: .normal)
        let screenScale = UIScreen.main.bounds.width/375
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize * screenScale)
        button.bounds.size = CGSize(width: size, height: size)
        button.backgroundColor = UIColor(red: 246/255.0, green: 182/255.0, blue: 185/255.0, alpha: 1)
        button.layer.cornerRadius = size/2
        button.addTarget(self, action: #selector(selectButtonClicked), for: .touchUpInside)
        if !allowsMultiSelecting || !allowsArealSelecting {
            button.isEnabled = false
        }
        return button
    }
    
    private func label(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 246/255.0, green: 182/255.0, blue: 185/255.0, alpha: 1)
        label.sizeToFit()
        return label
    }
    
    fileprivate func teethButton(withTitle title: String?, bgImage: UIImage, selectedBgImage: UIImage, tag: Int) -> UIButton {
        let button = UIButton()
        button.setBackgroundImage(bgImage, for: .normal)
        button.setBackgroundImage(selectedBgImage, for: .selected)
        button.setBackgroundImage(selectedBgImage, for: .highlighted)
        let screenWidthScale = UIScreen.main.bounds.width/375
        if title?.isEmpty == false {
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor(red: 35/255.0, green: 35/255.0, blue: 35/255.0, alpha: 1), for: .normal)
            button.setTitleColor(UIColor.white, for: .highlighted)
            button.setTitleColor(UIColor.white, for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13 * screenWidthScale)
        }
        button.sizeToFit()
        button.bounds.size = CGSize(width: button.bounds.width * screenWidthScale, height: button.bounds.height * screenWidthScale)
        button.tag = tag
        button.addTarget(self, action: #selector(teethButtonClicked), for: .touchUpInside)
        if type == .permanent {
            button.addObserver(self, forKeyPath: "highlighted", options: [.new, .old], context: nil)
            button.addObserver(self, forKeyPath: "selected", options: [.new, .old], context: nil)
        }
        if preselectedTeethNumbers.contains(button.tag) {
            button.isEnabled = false
            button.alpha = 0.65
        }
        teethButtons.append(button)
        return button
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let btn = object as? UIButton , btn.isEnabled, (keyPath == "highlighted" || keyPath == "selected") else { return }
        let label = teethTitleLabels["\(btn.tag)"]
        if btn.isSelected || btn.isHighlighted {
            label?.textColor = UIColor.white
        } else {
            label?.textColor = UIColor(red: 35/255.0, green: 35/255.0, blue: 35/255.0, alpha: 1)
        }
    }
    
    fileprivate func teethNumberLabel(withNumber number: Int) -> UILabel {
        let label = UILabel()
        let screenScale = UIScreen.main.bounds.width/375
        label.font = UIFont.systemFont(ofSize: 13 * screenScale)
        // #353535
        label.textColor = UIColor(red: 35/255.0, green: 35/255.0, blue: 35/255.0, alpha: 1)
        label.text = "\(number)"
        label.sizeToFit()
        label.tag = number
        teethTitleLabels["\(number)"] = label
        return label
    }
    
    @objc private func selectButtonClicked(sender: UIButton) {
        upperMandibleBtn.isSelected = false
        fullSelectionBtn.isSelected = false
        lowerMandibleBtn.isSelected = false
        sender.isSelected = !sender.isSelected
        selectedTeethNumbers.removeAll()
        let usingNumbers = type == .permanent ? PATeethView.permanentTeethNumbers : PATeethView.deciduousTeethNumbers
        let upperTeethRange = type == .permanent ? 0...15 : 0...9
        let lowerTeethRange = type == .permanent ? 16...31 : 10...19
        var selectingButtonTags = [Int]()
        if sender == upperMandibleBtn {
            selectingButtonTags = Array(usingNumbers[upperTeethRange])
        } else if sender == fullSelectionBtn {
            selectingButtonTags = usingNumbers
        } else {
            selectingButtonTags = Array(usingNumbers[lowerTeethRange])
        }
        for button in teethButtons {
            if selectingButtonTags.contains(button.tag) {
                button.isSelected = true
                selectedTeethNumbers.append(button.tag)
            } else {
                button.isSelected = false
                if let index = selectedTeethNumbers.index(of: button.tag) {
                    selectedTeethNumbers.remove(at: index)
                }
            }
        }
        for index in preselectedTeethNumbers {
            if !selectedTeethNumbers.contains(index) {
                selectedTeethNumbers.append(index)
            }
        }
        selectedTeethNumbers.sort(by: < )
    }
    
    @objc fileprivate func teethButtonClicked(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            selectedTeethNumbers.append(sender.tag)
        } else if let index = selectedTeethNumbers.index(of: sender.tag) {
            selectedTeethNumbers.remove(at: index)
        }
    }
}

/// 恒牙位视图
class PAPermanentTeethView: PATeethView {
    required init(frame: CGRect, preselectedTeethNumbers: [Int]) {
        super.init(frame: frame, type: .permanent, preselectedTeethNumbers: preselectedTeethNumbers)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        // 相对于设计稿(基于375屏幕尺寸)的放大系数
        let screenScale = UIScreen.main.bounds.width/375
        let bgCenter = CGPoint(x: bgView.bounds.width/2, y: bgView.bounds.height/2)
        
        var images: [UIImage] = [#imageLiteral(resourceName: "ic_teeth_21"), #imageLiteral(resourceName: "ic_teeth_22"), #imageLiteral(resourceName: "ic_teeth_23"), #imageLiteral(resourceName: "ic_teeth_24"), #imageLiteral(resourceName: "ic_teeth_25"), #imageLiteral(resourceName: "ic_teeth_26"), #imageLiteral(resourceName: "ic_teeth_27"), #imageLiteral(resourceName: "ic_teeth_28")]
        var selectedImages: [UIImage] = [#imageLiteral(resourceName: "ic_teeth_21_sel"), #imageLiteral(resourceName: "ic_teeth_22_sel"), #imageLiteral(resourceName: "ic_teeth_23_sel"), #imageLiteral(resourceName: "ic_teeth_24_sel"), #imageLiteral(resourceName: "ic_teeth_25_sel"), #imageLiteral(resourceName: "ic_teeth_26_sel"), #imageLiteral(resourceName: "ic_teeth_27_sel"), #imageLiteral(resourceName: "ic_teeth_28_sel")]
        // 25 , 15
        let teeth11Center = CGPoint(x: 147 * screenScale + images[0].size.width/2, y: 37 * screenScale + images[0].size.height/2)
        let teeth12Center = CGPoint(x: 116 * screenScale + images[1].size.width/2, y: 50 * screenScale + images[1].size.height/2)
        let teeth13Center = CGPoint(x: 96.5 * screenScale + images[2].size.width/2, y: 75 * screenScale + images[2].size.height/2)
        let teeth14Center = CGPoint(x: 75 * screenScale + images[3].size.width/2, y: 99 * screenScale + images[3].size.height/2)
        let teeth15Center = CGPoint(x: 54 * screenScale + images[4].size.width/2, y: 126 * screenScale + images[4].size.height/2)
        let teeth16Center = CGPoint(x: 40.5 * screenScale + images[5].size.width/2, y: 156 * screenScale + images[5].size.height/2)
        let teeth17Center = CGPoint(x: 37 * screenScale + images[6].size.width/2, y: 195 * screenScale + images[6].size.height/2)
        let teeth18Center = CGPoint(x: 35 * screenScale + images[7].size.width/2, y: 232 * screenScale + images[7].size.height/2)
        
        // 不同屏幕下微调
        var horizontalFineAdjustment: CGFloat = 0
        var verticalFineAdjustment  : CGFloat = 0
        if screenScale < 1 {
            horizontalFineAdjustment = -2.5
            verticalFineAdjustment = -2
        } else if screenScale == 1 {
            horizontalFineAdjustment = 0.5
            verticalFineAdjustment = 0
        } else {
            horizontalFineAdjustment = 2.5
            verticalFineAdjustment = 0
        }
        
        var leftTopTeethCenters = [teeth11Center, teeth12Center, teeth13Center, teeth14Center, teeth15Center, teeth16Center, teeth17Center, teeth18Center]
        var rightTopTeethCenters = [CGPoint]()
        var rightBottomTeethCenters = [CGPoint]()
        var leftBottomTeethCenters = [CGPoint]()
        for index in 0..<leftTopTeethCenters.count {
            leftTopTeethCenters[index].x += horizontalFineAdjustment
            leftTopTeethCenters[index].y += verticalFineAdjustment
            
            let point = leftTopTeethCenters[index]
            
            let rightTopCenter = CGPoint(x: 2 * bgCenter.x - point.x, y: point.y)
            rightTopTeethCenters.append(rightTopCenter)
            
            let rightBottomCenter = CGPoint(x: rightTopCenter.x, y: 2 * bgCenter.y - point.y)
            rightBottomTeethCenters.append(rightBottomCenter)
            
            let leftBottomCenter = CGPoint(x: point.x, y: rightBottomCenter.y)
            leftBottomTeethCenters.append(leftBottomCenter)
        }
        leftBottomTeethCenters.reverse()
        rightBottomTeethCenters.reverse()
        
        var allTeetchCenters = [CGPoint]()
        allTeetchCenters.append(contentsOf: leftTopTeethCenters)
        allTeetchCenters.append(contentsOf: rightTopTeethCenters)
        allTeetchCenters.append(contentsOf: rightBottomTeethCenters)
        allTeetchCenters.append(contentsOf: leftBottomTeethCenters)
        
        let rightTopImages = images
        let rightTopSelectedImage = selectedImages
        let rightBottomImages = rightTopImages.reversed()
        let rightBottomSelectedImages = rightTopSelectedImage.reversed()
        let leftBottomImages = images.reversed()
        let leftBottomSelectedImages = selectedImages.reversed()
        
        images.append(contentsOf: rightTopImages)
        images.append(contentsOf: rightBottomImages)
        images.append(contentsOf: leftBottomImages)
        selectedImages.append(contentsOf: rightTopSelectedImage)
        selectedImages.append(contentsOf: rightBottomSelectedImages)
        selectedImages.append(contentsOf: leftBottomSelectedImages)
        
        for index in 0..<allTeetchCenters.count {
            let number = PATeethView.permanentTeethNumbers[index]
            let teethBtn = teethButton(withTitle: nil, bgImage: images[index], selectedBgImage: selectedImages[index], tag: number)
            bgView.addSubview(teethBtn)
            teethBtn.center = allTeetchCenters[index]
            
            // 为了翻转图片后不影响titleLabel, 这里不用button自带的titleLabel
            let titleLabel = teethNumberLabel(withNumber: number)
            bgView.addSubview(titleLabel)
            titleLabel.center = teethBtn.center
            
            // 翻转图片
            if number >= 11 && number <= 18 {
                teethBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            } else if number >= 31 && number <= 38 {
                teethBtn.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
            } else if number >= 41 && number <= 48 {
                teethBtn.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
            }
        }
    }
    
    override fileprivate func teethButtonClicked(sender: UIButton) {
        super.teethButtonClicked(sender: sender)
    }
}

/// 恒牙位视图
class PADeciduousTeethView: PATeethView {
    required init(frame: CGRect, preselectedTeethNumbers: [Int]) {
        super.init(frame: frame, type: .deciduous, preselectedTeethNumbers: preselectedTeethNumbers)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        // 相对于设计稿(基于375屏幕尺寸)的放大系数
        let screenScale = UIScreen.main.bounds.width/375
        let bgCenter = CGPoint(x: bgView.bounds.width/2, y: bgView.bounds.height/2)
        
        let images: [UIImage] = [#imageLiteral(resourceName: "ic_teeth_51"), #imageLiteral(resourceName: "ic_teeth_52"), #imageLiteral(resourceName: "ic_teeth_53"), #imageLiteral(resourceName: "ic_teeth_54"), #imageLiteral(resourceName: "ic_teeth_55"), #imageLiteral(resourceName: "ic_teeth_61"), #imageLiteral(resourceName: "ic_teeth_62"), #imageLiteral(resourceName: "ic_teeth_63"), #imageLiteral(resourceName: "ic_teeth_64"), #imageLiteral(resourceName: "ic_teeth_65"), #imageLiteral(resourceName: "ic_teeth_71"), #imageLiteral(resourceName: "ic_teeth_72"), #imageLiteral(resourceName: "ic_teeth_73"), #imageLiteral(resourceName: "ic_teeth_74"), #imageLiteral(resourceName: "ic_teeth_75"), #imageLiteral(resourceName: "ic_teeth_81"), #imageLiteral(resourceName: "ic_teeth_82"), #imageLiteral(resourceName: "ic_teeth_83"), #imageLiteral(resourceName: "ic_teeth_84"), #imageLiteral(resourceName: "ic_teeth_85")]
        let selectedImages: [UIImage] = [#imageLiteral(resourceName: "ic_teeth_51_sel"), #imageLiteral(resourceName: "ic_teeth_52_sel"), #imageLiteral(resourceName: "ic_teeth_53_sel"), #imageLiteral(resourceName: "ic_teeth_54_sel"), #imageLiteral(resourceName: "ic_teeth_55_sel"), #imageLiteral(resourceName: "ic_teeth_61_sel"), #imageLiteral(resourceName: "ic_teeth_62_sel"), #imageLiteral(resourceName: "ic_teeth_63_sel"), #imageLiteral(resourceName: "ic_teeth_64_sel"), #imageLiteral(resourceName: "ic_teeth_65_sel"), #imageLiteral(resourceName: "ic_teeth_71_sel"), #imageLiteral(resourceName: "ic_teeth_72_sel"), #imageLiteral(resourceName: "ic_teeth_73_sel"), #imageLiteral(resourceName: "ic_teeth_74_sel"), #imageLiteral(resourceName: "ic_teeth_75_sel"), #imageLiteral(resourceName: "ic_teeth_81_sel"), #imageLiteral(resourceName: "ic_teeth_82_sel"), #imageLiteral(resourceName: "ic_teeth_83_sel"), #imageLiteral(resourceName: "ic_teeth_84_sel"), #imageLiteral(resourceName: "ic_teeth_85_sel")]
        
        // 23, 20.5
        let teeth51Center = CGPoint(x: 139 * screenScale + images[0].size.width/2, y: 36 * screenScale + images[0].size.height/2)
        let teeth52Center = CGPoint(x: 100 * screenScale + images[1].size.width/2, y: 54 * screenScale + images[1].size.height/2)
        let teeth53Center = CGPoint(x: 79 * screenScale + images[2].size.width/2, y: 81 * screenScale + images[2].size.height/2)
        let teeth54Center = CGPoint(x: 50.5 * screenScale + images[3].size.width/2, y: 117 * screenScale + images[3].size.height/2)
        let teeth55Center = CGPoint(x: 37.5 * screenScale + images[4].size.width/2, y: 160.5 * screenScale + images[4].size.height/2)
        
        let images85_81: [UIImage] = [#imageLiteral(resourceName: "ic_teeth_85"), #imageLiteral(resourceName: "ic_teeth_84"), #imageLiteral(resourceName: "ic_teeth_83"), #imageLiteral(resourceName: "ic_teeth_82"), #imageLiteral(resourceName: "ic_teeth_81")]
        let teeth85Center = CGPoint(x: 44 * screenScale + images85_81[0].size.width/2, y: 265 * screenScale + images[0].size.height/2)
        let teeth84Center = CGPoint(x: 69 * screenScale + images85_81[1].size.width/2, y: 311 * screenScale + images[0].size.height/2)
        let teeth83Center = CGPoint(x: 94.5 * screenScale + images85_81[2].size.width/2, y: 343 * screenScale + images[0].size.height/2)
        let teeth82Center = CGPoint(x: 122 * screenScale + images85_81[3].size.width/2, y: 362 * screenScale + images[0].size.height/2)
        let teeth81Center = CGPoint(x: 153 * screenScale + images85_81[4].size.width/2, y: 373 * screenScale + images[0].size.height/2)
        
        // 不同屏幕下微调
        var horizontalFineAdjustment: CGFloat = 0
        var verticalFineAdjustment  : CGFloat = 0
        if screenScale < 1 {
            horizontalFineAdjustment = -2.5
            verticalFineAdjustment = -2
        } else if screenScale == 1 {
            horizontalFineAdjustment = 0.5
            verticalFineAdjustment = 0
        } else {
            horizontalFineAdjustment = 2.5
            verticalFineAdjustment = 0
        }
        
        var leftTopTeethCenters = [teeth51Center, teeth52Center, teeth53Center, teeth54Center, teeth55Center]
        var leftBottomTeethCenters = [teeth85Center, teeth84Center, teeth83Center, teeth82Center, teeth81Center]
        var rightTopTeethCenters = [CGPoint]()
        var rightBottomTeethCenters = [CGPoint]()
        for index in 0..<leftTopTeethCenters.count {
            leftTopTeethCenters[index].x += horizontalFineAdjustment
            leftTopTeethCenters[index].y += verticalFineAdjustment
            
            let letTopPoint = leftTopTeethCenters[index]
            let rightTopCenter = CGPoint(x: 2 * bgCenter.x - letTopPoint.x, y: letTopPoint.y)
            rightTopTeethCenters.append(rightTopCenter)
            
            leftBottomTeethCenters[index].x += horizontalFineAdjustment
            leftBottomTeethCenters[index].y += verticalFineAdjustment
            let leftBottomPoint = leftBottomTeethCenters[index]
            let rightBottomCenter = CGPoint(x: 2 * bgCenter.x - leftBottomPoint.x, y: leftBottomPoint.y)
            rightBottomTeethCenters.append(rightBottomCenter)
        }
        leftBottomTeethCenters.reverse()
        rightBottomTeethCenters.reverse()
        
        var allTeetchCenters = [CGPoint]()
        allTeetchCenters.append(contentsOf: leftTopTeethCenters)
        allTeetchCenters.append(contentsOf: rightTopTeethCenters)
        allTeetchCenters.append(contentsOf: rightBottomTeethCenters)
        allTeetchCenters.append(contentsOf: leftBottomTeethCenters)
        
        for index in 0..<allTeetchCenters.count {
            let number = PATeethView.deciduousTeethNumbers[index]
            let teethBtn = teethButton(withTitle: "\(number)", bgImage: images[index], selectedBgImage: selectedImages[index], tag: number)
            bgView.addSubview(teethBtn)
            teethBtn.center = allTeetchCenters[index]
            
            // 个别牙齿微调
            if number == 63 {
                teethBtn.center.y += 2.5 * screenScale
            } else if number == 74 {
                teethBtn.center.x += 3.5 * screenScale
                teethBtn.center.y -= 2 * screenScale
            } else if number == 75 {
                teethBtn.center.y -= 4 * screenScale
            } else if number == 83 {
                teethBtn.center.x += 2 * screenScale
                teethBtn.center.y -= 3.5 * screenScale
            }
        }
    }
    
    override fileprivate func teethButtonClicked(sender: UIButton) {
        super.teethButtonClicked(sender: sender)
    }
}
