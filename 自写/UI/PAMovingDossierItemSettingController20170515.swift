//
//  PAMovingDossierItemSettingController1.swift
//  wanjia2B
//
//  Created by luozhijun on 2017/2/14.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit
import QBImagePickerController
import AspectsV1_4_2

/** 移动病历模块, 编辑\设置 某项内容 界面 */
class PAMovingDossierItemSettingController1: PABaseViewController {
    
    //MARK: - Properties
    fileprivate let languageTitles = ["普通话", "英语", "粤语"]
    fileprivate lazy var languageCheckItems: [SettingCheckmarkItem] = {
        var languageCheckItems = [SettingCheckmarkItem]()
        var index = 0
        self.languageTitles.forEach {
            let item = SettingCheckmarkItem(title: $0)
            item.backgroundColor = UIColor.clear
            item.enable = false
            if index > 0 {
                item.isUserInteractionEnabled = false
            }
            languageCheckItems.append(item)
            index += 1
        }
        languageCheckItems[0].isChecked = true
        return languageCheckItems
    }()
    fileprivate var inputBgView = UIView()
    fileprivate var imagePickerGridView: PAImagePickerGridView!
    fileprivate var imagePickerController: QBImagePickerController! = nil
    fileprivate var confirmButton: UIButton!
    
    fileprivate weak var qbAssetsVc: UIViewController?
    
    var selectedThumbnails = [UIImage]() {
        didSet {
            imagePickerGridView.dataSource = selectedThumbnails
        }
    }
    var selectedFullScreenImages = [UIImage]()
    var selectedImageUrls = [Any]()
    
    var textView: PAPlaceholderTextView!
    
    var finishedEditingAction: ((String?, [UIImage]) -> Swift.Void)?
    var httpTasks = [URLSessionTask]()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // 进入文本输入后第一次判定麦克风权限
        _ = PASpeechRecognizeManager.checkMicPhoneIsOpen()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(confirmButtonClicked))
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//    }
    
    deinit {
        httpTasks.forEach { $0.cancel() }
        deinitLog(self)
    }
}

//MARK: - Setup UI
extension PAMovingDossierItemSettingController1 {
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.paLightGrayColor()
        
        setupTextAndVoiceInputView()
//        setupPhotoSelectingView()
        setupConfirmButton()
    }
    
    fileprivate func setupTextAndVoiceInputView() {
        let padding_15: CGFloat     = 15
        let textViewHeight: CGFloat = 150
        let buttonHeight: CGFloat   = 28
        let bgViewHeight = padding_15 + textViewHeight + padding_15 + buttonHeight + padding_15
        
        view.addSubview(inputBgView)
        inputBgView.backgroundColor = .white
        inputBgView.frame = CGRect(x: 0, y: 64 + padding_15, width: view.frame.width, height: bgViewHeight)
        
        let topSeparator = UIImageView()
        inputBgView.addSubview(topSeparator)
        topSeparator.frame = CGRect(x: 0, y: 0, width: inputBgView.frame.width, height: PADeviceSize.separatorSize)
        topSeparator.layer.backgroundColor = UIColor.paDividingColor().cgColor
        
        textView = PAPlaceholderTextView(placeholder: "输入内容不得超过1000个字符")
        inputBgView.addSubview(textView)
        textView.frame = CGRect(x: padding_15, y: topSeparator.frame.maxY + padding_15, width: inputBgView.frame.width - 2*padding_15, height: textViewHeight)
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = view.backgroundColor
        textView.layer.cornerRadius = 4
        textView.delegate = self
        
        let voiceInputBtn = UIButton(type: .system)
        inputBgView.addSubview(voiceInputBtn)
        voiceInputBtn.setImage(UIImage(named: "ic_huatong")?.withRenderingMode(.alwaysOriginal), for: .normal)
        voiceInputBtn.setTitle(" 语音输入", for: .normal)
        voiceInputBtn.setTitleColor(UIColor.paGrayColor(), for: .normal)
        voiceInputBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        voiceInputBtn.sizeToFit()
        voiceInputBtn.addTarget(self, action: #selector(voiceInputBtnClicked), for: .touchUpInside)
        
        let languageSelectingBtn = PAOffsetedSubviewButton(style: PAOffsetedSubviewButton.imageRightTitleLeft)
        inputBgView.addSubview(languageSelectingBtn)
        languageSelectingBtn.setImage(UIImage(named: "ic_arrow_gray_down")?.withRenderingMode(.alwaysOriginal), for: .normal)
        languageSelectingBtn.setTitle("普通话 ", for: .normal)
        languageSelectingBtn.setTitleColor(UIColor.paGrayColor(), for: .normal)
        languageSelectingBtn.titleLabel?.font   = UIFont.systemFont(ofSize: 13)
        languageSelectingBtn.clipsToBounds      = true
        languageSelectingBtn.layer.cornerRadius = 14
        languageSelectingBtn.layer.borderColor  = UIColor.paGrayColor().cgColor
        languageSelectingBtn.layer.borderWidth  = PADeviceSize.separatorSize * 1.5
        languageSelectingBtn.sizeToFit()
        languageSelectingBtn.addTarget(self, action: #selector(languageSelectingButtonClicked), for: .touchUpInside)
        
        let languageSelectingBtnSpace: CGFloat = 20
        let sumOfButtonsWidth = voiceInputBtn.frame.width + padding_15 + (languageSelectingBtn.frame.width + languageSelectingBtnSpace)
        let buttonsY = textView.frame.maxY + padding_15
        let voiceInputBtnX = (view.frame.width - sumOfButtonsWidth)/2.0
        voiceInputBtn.frame = CGRect(x: voiceInputBtnX, y: buttonsY, width: voiceInputBtn.frame.width, height: buttonHeight)
        let languageSelectingBtnX = voiceInputBtn.frame.maxX + padding_15
        languageSelectingBtn.frame = CGRect(x: languageSelectingBtnX, y: buttonsY, width: languageSelectingBtn.frame.width + languageSelectingBtnSpace, height: buttonHeight)
        
        let bottomSeparator = UIImageView()
        inputBgView.addSubview(bottomSeparator)
        bottomSeparator.layer.backgroundColor = UIColor.paDividingColor().cgColor
        bottomSeparator.frame = CGRect(x: 0, y: voiceInputBtn.frame.maxY + padding_15, width: view.frame.width, height: PADeviceSize.separatorSize)
    }
    
    fileprivate func setupPhotoSelectingView() {
        let padding_5 : CGFloat = 5
        let padding_15: CGFloat = 15
        
        var gridViewDefaultFlowLayout = PAImagePickerGridView.defaultLayout().flow
        let gridViewX                 = padding_15 - gridViewDefaultFlowLayout.minimumInteritemSpacing
        let gridViewWidth             = view.frame.width - 2 * gridViewX
        gridViewDefaultFlowLayout     = PAImagePickerGridView.defaultLayout(fittingWidth: gridViewWidth).flow
        let gridHeight                = gridViewDefaultFlowLayout.itemSize.height
        
        let hintLabel  = UILabel()
        hintLabel.text = "注：每张图片不可大于4M，可上传4张"
        hintLabel.font = UIFont.systemFont(ofSize: 13)
        hintLabel.textColor = UIColor.paGrayColor()
        let hintLabelSize = hintLabel.sizeThatFits(PADeviceSize.greatestSize)
        
        let bgViewNeedHeight: CGFloat = padding_15 + gridHeight + padding_5 + hintLabelSize.height + padding_15 + 2 * PADeviceSize.separatorSize
        
        let bgView = UIView()
        view.addSubview(bgView)
        bgView.backgroundColor = .white
        bgView.frame = CGRect(x: 0, y: inputBgView.frame.maxY + padding_15, width: view.frame.width, height: bgViewNeedHeight)
        
        let topSeparator = UIImageView()
        bgView.addSubview(topSeparator)
        topSeparator.layer.backgroundColor = UIColor.paDividingColor().cgColor
        topSeparator.frame = CGRect(x: 0, y: 0, width: bgView.frame.width, height: PADeviceSize.separatorSize)
        
        imagePickerGridView = PAImagePickerGridView(frame: .zero, flowLayout: gridViewDefaultFlowLayout, dataSource: [])
        bgView.addSubview(imagePickerGridView)
        imagePickerGridView.frame = CGRect(x: gridViewX, y: topSeparator.frame.maxY + padding_15, width: gridViewWidth, height: gridHeight)
        imagePickerGridView.numberOfImagesAllowed = 4
        imagePickerGridView.alertControllerPresentedController = self
        imagePickerGridView.itemClicked = { [weak self] (gridView, indexPath) in
            let browser = PAPhotoBrowserViewController()
            browser.photos = self?.selectedFullScreenImages ?? [Any]()
            browser.currentIndex = indexPath.row
            browser.isContainDelete = true
            browser.didRemoveImage = { (removedIndex, _) in
                self?.selectedFullScreenImages.remove(at: removedIndex)
                self?.selectedThumbnails.remove(at: removedIndex)
            }
            self?.navigationController?.pushViewController(browser, animated: true)
        }
        imagePickerGridView.showAlumbAction = { [weak self] _ in
            guard self != nil else { return }
            self?.imagePickerController = QBImagePickerController()
            self?.imagePickerController.showsNumberOfSelectedAssets = true
            self?.imagePickerController.allowsMultipleSelection     = true
            let remainningCount = 4 - self!.selectedThumbnails.count
            self?.imagePickerController.maximumNumberOfSelection    = UInt(remainningCount)
            self?.imagePickerController.minimumNumberOfSelection    = 0
            self?.imagePickerController.delegate = self
            self?.present(self!.imagePickerController, animated: true, completion: nil)
        }
        imagePickerGridView.cameraImageSelectedAction = { [weak self] (_, compressdCameraImage) in
            self?.selectedFullScreenImages.append(compressdCameraImage)
            self?.selectedThumbnails.append(compressdCameraImage)
        }
        imagePickerGridView.itemDeleteButtonClicked = { [weak self] (gridView, indexPath) in
            gridView.remove(imageAt: indexPath)
            self?.selectedThumbnails.remove(at: indexPath.row)
            self?.selectedFullScreenImages.remove(at: indexPath.row)
        }
        let wrappedBlock: @convention(block) (AspectInfo) -> Swift.Void = { [weak self] (info) in
            if self?.imagePickerController?.selectedAssetURLs.count == 0 {
                self?.qb_imagePickerController(self?.imagePickerController, didSelectAssets: [])
            }
        }
        _ = try? QBAssetsViewController.aspect_hook(Selector(("done:")), with: .positionBefore, usingBlock: wrappedBlock)
        
        bgView.addSubview(hintLabel)
        hintLabel.frame = CGRect(x: padding_15, y: imagePickerGridView.frame.maxY + padding_5, width: hintLabelSize.width, height: hintLabelSize.height)
        
        let bottomSeparator = UIImageView()
        bgView.addSubview(bottomSeparator)
        bottomSeparator.layer.backgroundColor = UIColor.paDividingColor().cgColor
        bottomSeparator.frame = CGRect(x: 0, y: hintLabel.frame.maxY + padding_15, width: bgView.frame.width, height: PADeviceSize.separatorSize)
    }
    
    fileprivate func setupConfirmButton() {
        let padding_15: CGFloat = 15
        confirmButton = UIButton()
        view.addSubview(confirmButton)
        confirmButton.frame = CGRect(x: padding_15, y: inputBgView.frame.maxY + padding_15, width: view.frame.width - 2*padding_15, height: 44)
        confirmButton.tintColor = .clear
        confirmButton.titleLabel?.font = .systemFont(ofSize: 17)
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.setBackgroundImage(UIImage.buttonBackgroundImage.bgImage, for: .normal)
        confirmButton.setBackgroundImage(UIImage.buttonBackgroundImage.highlightBgImage, for: .highlighted)
        confirmButton.layer.cornerRadius  = 4.0
        confirmButton.layer.masksToBounds = true
        confirmButton.addTarget(self, action: #selector(confirmButtonClicked), for: .touchUpInside)
    }
}

//MARK: - Setup Data
extension PAMovingDossierItemSettingController1 {
    
}

extension PAMovingDossierItemSettingController1 : QBImagePickerControllerDelegate {
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didSelectAssets assets: [Any]!) {
        guard let assets = assets as? [ALAsset] else { return }
        var thumbnials = [UIImage]()
        for asset in assets {
            thumbnials.append(UIImage(cgImage: asset.thumbnail().takeUnretainedValue()))
            if let url = asset.value(forProperty: ALAssetPropertyAssetURL) {
                selectedImageUrls.append(url)
            }
        }
        selectedThumbnails.append(contentsOf: thumbnials)
        debugLog(imagePickerController.selectedAssetURLs)
        imagePickerController.dismiss(animated: true, completion: nil)
        
        DispatchQueue.global().async {
            var fullScreenImages = [UIImage]()
            for asset in assets {
                fullScreenImages.append(UIImage(cgImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue()))
            }
            self.selectedFullScreenImages.append(contentsOf: fullScreenImages)
        }
    }
}

//MARK: - Handle Events
extension PAMovingDossierItemSettingController1 : UITextViewDelegate {
    
    @objc fileprivate func voiceInputBtnClicked() {
        // 语音识别弹窗调用
        if PASpeechRecognizeManager.checkMicPhoneIsOpen() {
            let speechAlertView = PASpeechAlertView()
            // 语言类型0.普通话1.粤语2.英语
            speechAlertView.languageState = 0
                speechAlertView.showSpeechAlertView(animated: false, inView: view)
            speechAlertView.finalSpeechTextBlock = { [weak self] finalSpeechText in
                self?.textView.text = (self?.textView.text)! + finalSpeechText!
            }
        } else {
            PASpeechRecognizeManager.showMicPhoneAlert()
        }
    }
    
    @objc fileprivate func languageSelectingButtonClicked(sender: UIButton) {
        view.endEditing(true)
        var applyingTransform = CGAffineTransform.identity
        if sender.imageView?.transform == .identity {
            applyingTransform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        }
        UIView.animate(withDuration: 0.25) { 
            sender.imageView?.transform = applyingTransform
        }
        
        let pop = PATablePickerView(dataSource: languageCheckItems)
        pop.show(onView: self.view)
        pop.allowMultipleSelection = false
        pop.willHideAction = { (_) in
            UIView.animate(withDuration: 0.25) {
                sender.imageView?.transform = .identity
            }
        }
    }
    
    @objc fileprivate func confirmButtonClicked() {
        view.endEditing(true)
        _ = navigationController?.popViewController(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.finishedEditingAction?(self.textView.text, self.selectedThumbnails)
        }
    }
}
