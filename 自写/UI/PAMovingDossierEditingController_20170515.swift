//
//  PAMovingDossierEditingController1.swift
//  wanjia2B
//
//  Created by luozhijun on 2017/2/10.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit
import QBImagePickerController

/** 移动病历详情和编辑界面 */
class PAMovingDossierEditingController1: PABaseViewController {
    
    //MARK: - Properties
    /// 上级界面传过来的患者模型, 若为空则表示"快速接诊"
    fileprivate var patient: PAMovingDossierPatientModel?
    /// 上级界面传过来的病历详情模型
    fileprivate var dossierDetail: PAMovingDossierDetialResponse?
    /// 快速接诊返回值模型
    fileprivate var fastReception: PAMovingDossierFastReceptionResponse?
    
    var fastReceptionSucceed: (() -> Swift.Void)?
    var treatmentFinished: (() -> Swift.Void)?
    
    fileprivate var tableView = UITableView(frame: .zero, style: .grouped)
    fileprivate lazy var treatmentCategorySelectingView: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["初诊", "复诊"])
        let size = CGSize(width: 110, height: 25)
        segment.frame = CGRect(x: self.view.frame.width - SettingItem().accessoryViewHorizontalIndent - size.width, y: (44 - size.height)/2, width: size.width, height: size.height)
        segment.tag = -1111
        segment.layer.cornerRadius = 10
        segment.tintColor = .paOrangeColor()
        segment.selectedSegmentIndex = 0
        return segment
    }()
    fileprivate var headerSliderTab: PASliderTab!
    
    fileprivate var itemGroups = [SettingGroup]()
    fileprivate var editingItem: SettingItem! = nil
    
    fileprivate var nameItem: SettingItem!
    
    fileprivate var dissierItemCategoryTitles    = ["主诉", "既往史", "过敏史", "诊断"]
    fileprivate var dissierItemCategoryIconNames = ["patient_diagnose_detail", "patient_diagnose_history", "patient_diagnose_allergy", "patient_diagnose_current"]
    
    /// 门诊病历分组
    fileprivate var polyclinicDossierGroup: SettingGroup?
    /// 中医病历分组
    fileprivate var chineseDossierGroup: SettingGroup?
    
    fileprivate var dossierTypeSelectingItem: SettingArrowItem!
    
    fileprivate var childController: UIViewController?
    
    //MARK: NormalPicker
    fileprivate var normalPickerView: CustomPickerView!
    fileprivate lazy var showNormalPickerViewAction: SettingItemAction = {
        return { [weak self] (item) in
            self?.editingItem = item
            self?.view.endEditing(true)
            self?.tableView.scrollToNearestSelectedRow(at: .middle, animated: true)
            self?.normalPickerView.show()
        }
    }()
    
    //MARK: datePicker
    fileprivate lazy var datePickerFormat = "yyyy-MM-dd"
    fileprivate lazy var lastSelectedDate: Date? = nil
    fileprivate lazy var datePickerView: PACustomDatePickerView = {
        let picker = PACustomDatePickerView(selectedDate: self.lastSelectedDate ?? Date())
        picker.delegate = self
        return picker
    }()
    fileprivate lazy var showDatePickerViewAction: SettingItemAction = {
        return { [weak self] (item) in
            self?.editingItem = item
            self?.view.endEditing(true)
            self?.tableView.scrollToNearestSelectedRow(at: .middle, animated: true)
            self?.datePickerView.show()
        }
    }()
    
    //MARK: genderPicker
    fileprivate lazy var sexPickerView: CustomPickerView = {
        var lastSelectedIndex = 0
        let sexPickerView = CustomPickerView(index: lastSelectedIndex, dataArray: ["男", "女"], btnTitle1: "取消", btnTitle2: "确定")
        sexPickerView?.delegate = self
        return sexPickerView!
    }()
    
    //MARK: Keeping itemEditingController
    /// '主诉'关联的编辑界面
    fileprivate lazy var mainTellingItemEditingController: PAMovingDossierItemSettingController = {
        let v = PAMovingDossierItemSettingController(nibName: nil, bundle: nil)
        v.navigationItem.title = "主诉"
        return v
    }()
    /// '既往史'关联的编辑界面
    fileprivate lazy var historyItemEditingController: PAMovingDossierItemSettingController = {
        let v = PAMovingDossierItemSettingController(nibName: nil, bundle: nil)
        v.navigationItem.title = "既往史"
        return v
    }()
    /// '过敏史'关联的编辑界面
    fileprivate lazy var allergicHistoryItemEditingController: PAMovingDossierItemSettingController = {
        let v = PAMovingDossierItemSettingController(nibName: nil, bundle: nil)
        v.navigationItem.title = "过敏史"
        return v
    }()
    /// '诊断'关联的编辑界面
    fileprivate lazy var treatmentItemEditingController: PAMovingDossierItemSettingController = {
        let v = PAMovingDossierItemSettingController(nibName: nil, bundle: nil)
        v.navigationItem.title = "诊断"
        return v
    }()
    
    fileprivate var httpTasks = [URLSessionTask?]()
    
    //MARK: - View Life Cycle
    required init(patient: PAMovingDossierPatientModel? = nil, dossierDetail: PAMovingDossierDetialResponse? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.patient = patient
        self.dossierDetail = dossierDetail
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "病历详情"
        statisName = "mobileDossier"
        
        if patient != nil {
            setupTableViewAndBottomBtn()
            setupTableHeaderTab()
            requestDossierDetial { [weak self] in
                self?.setupUIAccordingToPatientOrDossier()
                self?.tableView.reloadData()
            }
        } else {
            setupUI()
        }
    }
    
    deinit {
        httpTasks.forEach { $0?.cancel() }
        deinitLog(self)
    }
}

//MARK: - Setup UI
extension PAMovingDossierEditingController1 {
    fileprivate func setupUI() {
        setupTableViewAndBottomBtn()
        setupTableHeaderTab()
        setupUIAccordingToPatientOrDossier()
    }
    
    /// 与数据相关的界面设置
    fileprivate func setupUIAccordingToPatientOrDossier() {
        setupItemGroup_0()
        setupDossierTypeSelectingItem()
        if dossierDetail?.cnMedical != nil {
            setupDossierInfoItems(withDossierType: 1)
        }
        if dossierDetail?.westMedicalMedical != nil {
            setupDossierInfoItems(withDossierType: 0)
        }
    }
    
    fileprivate func setupTableViewAndBottomBtn() {
        let bottomButtonHeight: CGFloat = 44
        let headerTapHeigth: CGFloat    = 44
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height - 64 - bottomButtonHeight)
        tableView.backgroundColor  = .paBackgroundColor()
        tableView.separatorColor   = .paDividingColor()
        tableView.dataSource       = self
        tableView.delegate         = self
        tableView.layoutMargins    = .zero
        tableView.separatorInset   = .zero
        tableView.contentInset.top = headerTapHeigth
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.reuseIdentifier)
        
        let bottomBtnView = UIView()
        view.addSubview(bottomBtnView)
        bottomBtnView.frame = CGRect(x: 0, y: tableView.frame.maxY, width: view.frame.width, height: bottomButtonHeight)
        
        let separator = UIImageView()
        bottomBtnView.addSubview(separator)
        separator.frame = CGRect(x: 0, y: 0, width: bottomBtnView.frame.width, height: PADeviceSize.separatorSize)
        separator.layer.backgroundColor = UIColor.paDividingColor().cgColor
        
        let saveBtn = UIButton(type: .system)
        bottomBtnView.addSubview(saveBtn)
        saveBtn.frame = CGRect(x: 0, y: separator.frame.maxY, width: bottomBtnView.frame.width/2.0, height: bottomButtonHeight - separator.frame.height)
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        saveBtn.tintColor = .clear
        saveBtn.setTitleColor(.paGrayColor(), for: .normal)
        saveBtn.setTitle("结束就诊", for: .normal)
        saveBtn.addTarget(self, action: #selector(finishButtonClicked), for: .touchUpInside)
        
        let finishBtn = UIButton(type: .system)
        bottomBtnView.addSubview(finishBtn)
        finishBtn.frame = CGRect(x: saveBtn.frame.maxX, y: saveBtn.frame.origin.y, width: bottomBtnView.frame.width/2.0, height: bottomButtonHeight - separator.frame.height)
        finishBtn.tintColor = .clear
        finishBtn.backgroundColor = .paOrangeColor()
        finishBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        finishBtn.setTitleColor(.white, for: .normal)
        finishBtn.setTitle("保存", for: .normal)
        finishBtn.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
    }
    
    fileprivate func setupTableHeaderTab() {
        headerSliderTab = PASliderTab(titles: ["病历", "处方"], selectedIndex: 0)
        headerSliderTab.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: 44)
        headerSliderTab.barTintColor = .white
        headerSliderTab.buttonClicked = { [weak self] (sliderTab, previousSelectedIndex, selectedIndex) in
            guard previousSelectedIndex != selectedIndex, self != nil else { return  false}
            self?.childController?.removeFromParentViewController()
            self?.childController?.view.removeFromSuperview()
            if selectedIndex == 0 {
                self?.tableView.isHidden = false
                if self!.tableView.contentOffset.y > 20 {
                    sliderTab.barTintColor = nil
                }
            } else if selectedIndex == 1 && self?.childController == nil {
                if self?.patient?.acogryphyId == nil {
                    PAAlertView.showBaseAlert(message: "请先保存病历，稍后进行处方操作")
                    return false
                }
                
                self?.childController = PAMovingDossierPrescriptionInfoController()
                (self?.childController as! PAMovingDossierPrescriptionInfoController).acographyId = self?.patient?.acogryphyId
            }
            if selectedIndex != 0 && self?.childController != nil {
                sliderTab.isBottomSepratorHidden  = false
                sliderTab.barTintColor            = .white
                self?.tableView.isHidden          = true
                let childViewStartY: CGFloat      = 64 + 44
                self?.childController?.view.frame = CGRect(x: 0, y: childViewStartY, width: self!.view.frame.width, height: self!.view.frame.height - childViewStartY)
                self?.addChildViewController(self!.childController!)
                self?.view.addSubview(self!.childController!.view!)
            }
            return true
        }
        view.addSubview(headerSliderTab)
    }
    
    fileprivate func setupItemGroup_0() {
        let group0 = SettingGroup()
        
        // 患者姓名
        nameItem = SettingTextFieldItem(title: "患者姓名", subtitle: patient?.patientName, subtitlePlaceholder: "请输入患者姓名", required: patient == nil, enable: false, isUserInteractionEnabled: patient == nil)
        group0.items.append(nameItem)
        
        // 性别
        let sexItem = SettingArrowItem(title: "性别", subtitle: patient == nil ? nil : (patient?.patientSex == 1 ? "男" : "女"), subtitlePlaceholder: "请选择", required: patient == nil, enable: patient == nil, isUserInteractionEnabled: patient == nil)
        sexItem.isArrowHidden = sexItem.subtitle != nil
        sexItem.action = { [weak self] (item) in
            self?.normalPickerView = self?.sexPickerView
            self?.showNormalPickerViewAction(item)
        }
        group0.items.append(sexItem)
        
        // 手机
        let phoneNumberItem = SettingTextFieldItem(title: "手机号码", subtitle: patient?.mobilePhoneNumber, subtitlePlaceholder: "请选择", required: patient == nil, enable: patient == nil, isUserInteractionEnabled: patient == nil)
        group0.items.append(phoneNumberItem)
        
        // 出生年月
        let ageItem = SettingArrowItem(title: "出生年月", subtitle: patient?.paticentBirthDate, subtitlePlaceholder: "请选择", required: patient == nil, enable: patient == nil, isUserInteractionEnabled: patient == nil)
        ageItem.isArrowHidden = ageItem.subtitle != nil
        ageItem.action = showDatePickerViewAction
        group0.items.append(ageItem)
        
        // 就诊时间
        var timeString: String?
        if (patient?.modifyDate.intValue).noneNull > 0 {
            timeString = String(dateFormat: "YYYY-MM-dd", secondsSince1970: (patient?.modifyDate.intValue).noneNull/1000)
        } else {
            timeString = Date().toString()
        }
        let treatmentTimeItem = SettingArrowItem(title: "就诊时间", subtitle: timeString, subtitlePlaceholder: "请选择", required: false, enable: false, isUserInteractionEnabled: false)
        treatmentTimeItem.isArrowHidden = treatmentTimeItem.subtitle != nil
        treatmentTimeItem.action = showDatePickerViewAction
        group0.items.append(treatmentTimeItem)
        
        // 就诊类型
        // let treatmentGenreItem = SettingItem(title: "就诊类型", required: true)
        // group0.items.append(treatmentGenreItem)
        
        group0.items.forEach {
            $0.titleColor                   = .paGrayColor()
            $0.subtitleAlignment            = .left
            $0.subtitlePlaceholderAlignment = .left
        }
        itemGroups.append(group0)
    }
    
    fileprivate func setupDossierTypeSelectingItem() {
        let group1 = SettingGroup()
        var subtitle: String?
        if dossierDetail?.westMedicalMedical != nil {
            subtitle = "综合门诊"
        } else if dossierDetail?.cnMedical != nil {
            subtitle = "中医"
        }
        // 病历类型
        dossierTypeSelectingItem = SettingArrowItem(title: "病历类型", subtitle: subtitle, subtitlePlaceholder: "请选择", enable: true)
        dossierTypeSelectingItem.action = { [weak self] (item) in
            let action1 = PAActionModel(title: "综合门诊") {
                item.subtitle = "综合门诊"
                self?.setupDossierInfoItems(withDossierType: 0, isCreating: self?.polyclinicDossierGroup == nil)
                self?.tableView.reloadRows(at: [item.indexPath!], with: .automatic)
            }
            let action2 = PAActionModel(title: "中医") { (_) in
                item.subtitle = "中医"
                self?.setupDossierInfoItems(withDossierType: 1, isCreating: self?.chineseDossierGroup == nil)
                self?.tableView.reloadRows(at: [item.indexPath!], with: .automatic)
            }
            PAActionSheet.showActionSheet(title: nil, message: nil, actions: [action1, action2], controller: self)
        }
        group1.items.append(dossierTypeSelectingItem)
        itemGroups.append(group1)
    }
    
    /**
    fileprivate func setupOtherItemGroups() {
        let groupHeaderTitles    = ["主诉", "既往史", "过敏史", "诊断"]
        let groupHeaderIconNames = ["patient_diagnose_detail", "patient_diagnose_history", "patient_diagnose_allergy", "patient_diagnose_current"]
        
        // group2 -- group5
        for index in 0..<groupHeaderTitles.count {
            let aGroup = SettingGroup()
            aGroup.headerTitle = groupHeaderTitles[index]
            
            let sectionHeaderItem = SettingSectionHeaderItem(title: groupHeaderTitles[index])
            sectionHeaderItem.headerIconName = groupHeaderIconNames[index]
            aGroup.items.append(sectionHeaderItem)
            
            let textViewItem = SettingTextViewItem(title: nil, subtitlePlaceholder: "输入内容不得超过1000个字符")
            textViewItem.subtitlePlaceholderAlignment = .left
            textViewItem.textViewEnable = false
            textViewItem.cellInsets = UIEdgeInsets(top: 0, left: SettingThumbnailGridItem.horizontalIndent, bottom: 10, right: SettingThumbnailGridItem.horizontalIndent)
            aGroup.items.append(textViewItem)
            
            itemGroups.append(aGroup)
            
            // 测试
            if index == 1 {
                let thumbnailGridItem = SettingThumbnailGridItem(title: nil)
                let images = [UIImage(named: "insurence_public_receive")!, UIImage(named: "insurence_public_receive")!, UIImage(named: "insurence_public_receive")!, UIImage(named: "insurence_public_receive")!]
                thumbnailGridItem.thumbnails = images.map { (image) -> UIImage in
                    return image.roundingCorner(forRadius: thumbnailGridItem.imageCornerRadius, sizeToFit: thumbnailGridItem.imageViewSize) ?? image
                }
                thumbnailGridItem.cellInsets = UIEdgeInsets(top: 1, left: SettingThumbnailGridItem.horizontalIndent, bottom: 12, right: SettingThumbnailGridItem.horizontalIndent)
                aGroup.items.append(thumbnailGridItem)
            }
        }
    }
     */
    
    fileprivate func setupDossierInfoItems(withDossierType type: Int = 0, isCreating: Bool = true, isDeleting: Bool = false) {
        if itemGroups.count == 3 {
            itemGroups.removeLast()
        }
        if isDeleting {
            if type == 0 {
                polyclinicDossierGroup = nil
            } else {
                chineseDossierGroup = nil
            }
            
            // 修改按钮, 把"添加"按钮加上去
            var noneNilGroup: SettingGroup?
            if polyclinicDossierGroup != nil  {
                noneNilGroup = polyclinicDossierGroup
            } else if chineseDossierGroup != nil {
                noneNilGroup = chineseDossierGroup
            }
            if let actionItem = noneNilGroup?.items.last as? SettingRightActionsItem {
                actionItem.buttonTitles = ["添加", "删除"]
                actionItem.highlightedButtonIndex = 0
            }
            
            // 如果全被删除了, 修改病历类型标题
            if noneNilGroup == nil {
                itemGroups[1].items.first?.subtitle = nil
            }
        }
        guard isCreating else {
            var usingType = type
            if isDeleting { // 删除的时候此处用到的type要反转
                usingType = type == 0 ? 1 : 0
            }
            if usingType == 0 && polyclinicDossierGroup != nil {
                itemGroups.append(polyclinicDossierGroup!)
            }
            if usingType == 1 && chineseDossierGroup != nil {
                itemGroups.append(chineseDossierGroup!)
            }
            if itemGroups.count >= 3 {
                tableView.reloadSections(IndexSet(integer: 2), with: .left)
            } else {
                tableView.reloadData()
            }
            return
        }
        
        let headerTitles    = dissierItemCategoryTitles
        let headerIconNames = dissierItemCategoryIconNames
        
        let aGroup = SettingGroup()
        for index in 0..<headerTitles.count {
            
            let sectionHeaderItem = SettingSectionHeaderItem(title: headerTitles[index])
            sectionHeaderItem.headerIconName = headerIconNames[index]
            aGroup.items.append(sectionHeaderItem)
            
            let textViewItem = SettingTextViewItem(title: headerTitles[index], subtitlePlaceholder: "输入内容不得超过1000个字符", enable: true)
            textViewItem.selectionStyle = .none
            textViewItem.subtitlePlaceholderAlignment = .left
            textViewItem.textViewEnable = false
            textViewItem.cellInsets = UIEdgeInsets(top: 0, left: SettingThumbnailGridItem.horizontalIndent, bottom: 0, right: SettingThumbnailGridItem.horizontalIndent)
            // 方便判断是否进入下一级界面
            textViewItem.name = headerTitles[index]
            if type == 0 {
                if index == 0 {
                    textViewItem.subtitle = dossierDetail?.westMedicalMedical?.dwsMedicalRecord?.chiefComplaint
                } else if index == 1 {
                    textViewItem.subtitle = dossierDetail?.westMedicalMedical?.dwsMedicalRecord?.allergiesHistory
                } else if index == 2 {
                    textViewItem.subtitle = dossierDetail?.westMedicalMedical?.dwsMedicalRecord?.personalHistory
                } else {
                    textViewItem.subtitle = dossierDetail?.westMedicalMedical?.dwsDiagnosisRecordList?.first?.diagnosis
                }
            } else {
                if index == 0 {
                    textViewItem.subtitle = dossierDetail?.cnMedical?.chiefComplaint
                } else if textViewItem.name == "诊断" {
                    textViewItem.subtitle = dossierDetail?.cnMedical?.chineseTraDiagnosis
                }
            }
            aGroup.items.append(textViewItem)
            
            // 测试
            /**
            if index == 1 {
                let thumbnailGridItem = SettingThumbnailGridItem(title: nil)
                let images = [UIImage(named: "insurence_public_receive")!, UIImage(named: "insurence_public_receive")!, UIImage(named: "insurence_public_receive")!, UIImage(named: "insurence_public_receive")!]
                thumbnailGridItem.thumbnails = images.map { (image) -> UIImage in
                    return image.roundingCorner(forRadius: thumbnailGridItem.imageCornerRadius, sizeToFit: thumbnailGridItem.imageViewSize) ?? image
                }
                thumbnailGridItem.cellInsets = UIEdgeInsets(top: 10, left: SettingThumbnailGridItem.horizontalIndent, bottom: 1, right: SettingThumbnailGridItem.horizontalIndent)
                thumbnailGridItem.name = headerTitles[index]
                aGroup.items.append(thumbnailGridItem)
            }
             */
            
            if index == headerTitles.count - 1 {
                let rightActionsItem = SettingRightActionsItem(title: nil)
                if polyclinicDossierGroup != nil || chineseDossierGroup != nil { // 已至少存在一个病历
                    rightActionsItem.buttonTitles = ["删除"]
                    rightActionsItem.highlightedButtonIndex = -1
                    // 同时删除上一个病历的"添加"按钮
                    var noneNilGroup: SettingGroup?
                    if polyclinicDossierGroup != nil  {
                        noneNilGroup = polyclinicDossierGroup
                    } else if chineseDossierGroup != nil {
                        noneNilGroup = chineseDossierGroup
                    }
                    if let actionItem = noneNilGroup?.items.last as? SettingRightActionsItem {
                        actionItem.buttonTitles = ["删除"]
                        actionItem.highlightedButtonIndex = -1
                    }
                } else {
                    rightActionsItem.buttonTitles = ["添加", "删除"]
                    rightActionsItem.highlightedButtonIndex = 0
                }
                rightActionsItem.buttonClicked = { [weak self] (index, btn) in
                    if type == 1 {
                        self?.itemGroups[1].items.first?.subtitle = "综合门诊"
                    } else {
                        self?.itemGroups[1].items.first?.subtitle = "中医"
                    }
                    if btn.title(for: .normal) == "添加" {
                        self?.setupDossierInfoItems(withDossierType: type == 0 ? 1 : 0)
                    } else {
                        self?.setupDossierInfoItems(withDossierType: type, isCreating: false, isDeleting: true)
                    }
                }
                aGroup.items.append(rightActionsItem)
            }
        }
        itemGroups.append(aGroup)

        if type == 0 {
            polyclinicDossierGroup = aGroup
        } else {
            chineseDossierGroup = aGroup
        }
        
        if tableView.numberOfSections >= 3 && itemGroups.count >= 3 {
            tableView.reloadSections(IndexSet(integer: 2), with: .right)
        } else {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Setup Data
extension PAMovingDossierEditingController1 {
    fileprivate func requestDossierDetial(finished: @escaping () -> Swift.Void) {
        guard let patient = patient else { return }
        let task = PAMovingDossierRequests.fetchDossier(("0", patient.empiId.noneNull, patient.acogryphyId.noneNull), for: self) { [weak self] (responseModel) in
            self?.dossierDetail = responseModel
            finished()
        }
        httpTasks.append(task)
    }
    
    /// 填写病历时, 检查必填项; 如果都已填写, 返回填写后的字符串数组
    fileprivate var fillInDossier: (isCompleted: Bool, polyDossierTexts: [String], chineseDossierTexts: [String]) {
        if itemGroups.count < 3 {
            PAMBManager.sharedInstance.showBriefMessage(message: "请至少填写一个病历", view: view, after: 1.0)
            return (false, [], [])
        }
        
        var polyDossierTexts    = [String]()
        var chineseDossierTexts = [String]()
        /// 此闭包中的返回值Bool, 表示是否循环是否应该中图停止(以及程序是否应该退出)
        let itemOperation: (SettingItem, Bool) -> Bool = { item, shouldShowAlert in
            if item is SettingFullTextItem {
                if item.subtitle == nil || (item.subtitle != nil && item.subtitle?.isEmpty == true) {
                    if shouldShowAlert {
                        var hintPrefix = ""
                        if self.itemGroups[2] == self.polyclinicDossierGroup {
                            hintPrefix = "请填写\"门诊病历\"的"
                        } else if self.itemGroups[2] == self.chineseDossierGroup {
                            hintPrefix = "请填写\"中医病历\"的"
                        }
                        PAMBManager.sharedInstance.showBriefMessage(message: hintPrefix + item.title.noneNull, view: self.view, after: 1.0)
                    }
                    return true
                } else if item.subtitle != nil {
                    if self.itemGroups[2] == self.polyclinicDossierGroup {
                        polyDossierTexts.append(item.subtitle!)
                    } else if self.itemGroups[2] == self.chineseDossierGroup {
                        chineseDossierTexts.append(item.subtitle!)
                    }
                }
            }
            return false
        }
        
        var isPolyDossierTextsCompleted = true
        if let polyclinicDossierGroup = polyclinicDossierGroup {
            for item in polyclinicDossierGroup.items {
                if itemOperation(item, false) {
                    isPolyDossierTextsCompleted = false
                    break
                }
            }
        }
        var isChineseDossierTextsCompleted = true
        if let chineseDossierGroup = chineseDossierGroup {
            for item in chineseDossierGroup.items {
                if itemOperation(item, false) {
                    isChineseDossierTextsCompleted = false
                    break
                }
            }
        }
        
        // 检查必填项:
        if !isPolyDossierTextsCompleted && !isChineseDossierTextsCompleted {
            polyDossierTexts.removeAll()
            chineseDossierTexts.removeAll()
            if self.itemGroups[2] == polyclinicDossierGroup {
                for item in polyclinicDossierGroup!.items {
                    if itemOperation(item, true) {
                        return (false, [], [])
                    }
                }
            }
            if self.itemGroups[2] == chineseDossierGroup {
                for item in chineseDossierGroup!.items {
                    if itemOperation(item, true) {
                        return (false, [], [])
                    }
                }
            }
        }
        
        return (true, polyDossierTexts, chineseDossierTexts)
    }
}

//MARK: - Handle Events
extension PAMovingDossierEditingController1 : PACustomDatePickerViewDelegate, CustomPickerViewDelegate {
    @objc fileprivate func commitBtnClicked() {
    }
    
    @objc fileprivate func saveButtonClicked(isFinished: Bool = false) {
//        if itemGroups.count >= 3 {
//            if itemGroups[2].items[2] is SettingThumbnailGridItem {
//                itemGroups[2].items.remove(at: 2)
//                tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
//            }
//        }
        
        // 如果没有患者信息, 须先请求快速接诊
        if patient == nil && fastReception == nil {
            // 检测必填项目
            for item in itemGroups[0].items {
                if item.required {
                    let subtitle = item.subtitle ?? ""
                    guard subtitle.characters.count > 0 else {
                        PAMBManager.sharedInstance.showBriefMessage(message: "请填写" + item.title!, view: view, after: 1.0)
                        return
                    }
                }
            }
            // 快速接诊接口
            let fastReceptionInfo = PAMovingDossierFastReceptionParam.FastReceptionInfo()
            fastReceptionInfo.patientName       = itemGroups[0].items[0].subtitle
            fastReceptionInfo.patientGender     = itemGroups[0].items[1].subtitle == "女" ? "2" : "1"
            fastReceptionInfo.mobilePhoneNumber = itemGroups[0].items[2].subtitle
            fastReceptionInfo.patientBirthDate  = itemGroups[0].items[3].subtitle
            PAMovingDossierRequests.fastReception(with: fastReceptionInfo, for: self) { [weak self] (responseModel) in
                if responseModel != nil {
                    self?.fastReception = responseModel
                    self?.saveDossierDetial(isFinished: isFinished)
                }
            }
            return
        }
        
        saveDossierDetial(isFinished: isFinished)
    }
    
    fileprivate func saveDossierDetial(isFinished: Bool = false) {
        if itemGroups.count < 3 {
            PAMBManager.sharedInstance.showBriefMessage(message: "请至少填写一个病历", view: view, after: 1.0)
            return
        }
        // 检查必填项:
        var texts = [String]()
        for index in 0..<itemGroups[2].items.count {
            let item = itemGroups[2].items[index]
            if item is SettingTextViewItem {
                if item.subtitle == nil || (item.subtitle != nil && item.subtitle?.isEmpty == true) {
                    PAMBManager.sharedInstance.showBriefMessage(message: "请填写" + item.title.noneNull, view: view, after: 1.0)
                    return
                } else if item.subtitle != nil {
                    texts.append(item.subtitle!)
                }
            }
        }
        
        // 保存病历接口
        let savingParam = PAMovingDossierSavingParam()
        
        // 综合门诊病历详情模型->子模型
        let dwsMedicalInfo = PAMovingDossierSavingParam.PolyclinicMedicalInfo.DwsMedicalRecord()
        if polyclinicDossierGroup != nil {
            // 综合门诊病历详情模型
            let polyClinicMedicalInfo = PAMovingDossierSavingParam.PolyclinicMedicalInfo()
            polyClinicMedicalInfo.dwsDiagnosisRecordList = [PAMovingDossierSavingParam.Diagnosis(diagnosis: texts[3])]
            
            dwsMedicalInfo.empiId           = patient != nil ? patient?.empiId : fastReception?.empiId
            dwsMedicalInfo.acographyId      = patient != nil ? patient?.acogryphyId : fastReception?.acographyId
            dwsMedicalInfo.chiefComplaint   = texts[0]
            dwsMedicalInfo.allergiesHistory = texts[1]
            dwsMedicalInfo.personalHistory  = texts[2]
            
            polyClinicMedicalInfo.dwsMedicalRecord = dwsMedicalInfo
            // 服务端要求这个json需转成字符串
            savingParam.medicalInfoWest = polyClinicMedicalInfo.yy_modelToJSONString()
        }
        if chineseDossierGroup != nil {
            // 中医病历详情模型
            let chineseMedicialInfo = PAMovingDossierSavingParam.ChineseMedicalInfo()
            chineseMedicialInfo.empiId              = patient != nil ? patient?.empiId : fastReception?.empiId
            chineseMedicialInfo.acographyId         = patient != nil ? patient?.acogryphyId : fastReception?.acographyId
            chineseMedicialInfo.chiefComplaint      = texts[0]
            chineseMedicialInfo.chineseTraDiagnosis = texts[3]
            savingParam.medicalInfoCN = chineseMedicialInfo.yy_modelToJSONString()
        }
        
        PAMovingDossierRequests.saveDossier(savingParam, for: self) { [weak self] (responseModel) in
            guard self != nil else { return }
            if responseModel != nil {
                // 更新就诊流水号
                let newAcogryphyId = responseModel?.CNResponse?.acographyId != nil ? responseModel?.CNResponse?.acographyId : responseModel?.westResponse?.acographyId
                if newAcogryphyId != nil {
                    self?.patient?.acogryphyId       = newAcogryphyId
                    self?.fastReception?.acographyId = newAcogryphyId
                }
                
                if isFinished {
                    /// 调用更改状态接口
                    let updatePatientParam = PAMovingDossierUpdatePatientParam()
                    if self?.patient != nil {
                        let dwsAcography                = PAMovingDossierUpdatePatientParam.DwsAcography(patient: self!.patient!)
                        updatePatientParam.acographyId  = self!.patient?.acogryphyId
                        updatePatientParam.dwsAcography = dwsAcography.yy_modelToJSONString()
                    } else {
                        updatePatientParam.acographyId  = self!.fastReception?.acographyId
                        let dwsAcography                = PAMovingDossierUpdatePatientParam.DwsAcography()
                        dwsAcography.empiId             = self!.fastReception?.empiId
                        dwsAcography.acographyId        = self!.fastReception?.acographyId
                        updatePatientParam.dwsAcography = dwsAcography.yy_modelToJSONString()
                    }
                    updatePatientParam.status = "12"
                    
                    PAMovingDossierRequests.updatePatientInfo(self!.patient, param: updatePatientParam, for: self) { [weak self] (responseModel) in
                        if responseModel != nil {
                            PAMBManager.sharedInstance.showBriefMessage(message: "保存病历成功", view: self?.view, after: 1.0)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { 
                               _ = self?.navigationController?.popViewController(animated: true)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                    self?.treatmentFinished?()
                                })
                            })
                        }
                    }
                } else {
                    PAMBManager.sharedInstance.showBriefMessage(message: "保存病历成功", view: self?.view, after: 1.75)
                    // 如果是快速接诊, 保存病历后服务端会生成新的"已接诊"数据模型, 故须通知上级列表
                    if self?.fastReception != nil {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            //_ = self?.navigationController?.popViewController(animated: true)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                self?.fastReceptionSucceed?()
                            })
                        })
                    }
                }
            }
        }
    }
    
    @objc fileprivate func finishButtonClicked() {
        /**
        let thumbnailGridItem = SettingThumbnailGridItem(title: nil)
        let images = [UIImage(named: "insurence_healthcare_receive")!, UIImage(named: "insurence_healthcare_receive")!, UIImage(named: "insurence_healthcare_receive")!, UIImage(named: "insurence_healthcare_receive")!]
        thumbnailGridItem.thumbnails = images.map { (image) -> UIImage in
            return image.roundingCorner(forRadius: thumbnailGridItem.imageCornerRadius, sizeToFit: thumbnailGridItem.imageViewSize) ?? image
        }
        thumbnailGridItem.cellInsets = UIEdgeInsets(top: 10, left: SettingThumbnailGridItem.horizontalIndent, bottom: 1, right: SettingThumbnailGridItem.horizontalIndent)
        thumbnailGridItem.name = "既往史"
        if itemGroups.count >= 3 {
            itemGroups[2].items.insert(thumbnailGridItem, at: 2)
            tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
        }
         */
        
        saveButtonClicked(isFinished: true)
    }
    
    //MARK: PACustomDatePickerViewDelegate
    func tapItem(withSelect date: Date, andView view: PACustomDatePickerView) {
             lastSelectedDate = date
            let dateString = date.toString(by: datePickerFormat)
            if editingItem.subtitle != dateString /** 避免重复设置 */ {
                editingItem.subtitle = dateString
                if let indexPath = editingItem.indexPath {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
        }
    }
    
    //MARK: CustomPickerViewDelegate
    func tapItem(withSelect string: String!, andView view: CustomPickerView!) {
        if editingItem.subtitle != string {
            editingItem.subtitle = string
            if let indexPath = editingItem.indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate
extension PAMovingDossierEditingController1 : UITableViewDataSource, UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0.5 || scrollView.contentOffset.y < -0.5 {
            headerSliderTab?.isBottomSepratorHidden = false
        } else {
            headerSliderTab?.isBottomSepratorHidden = true
        }
        if scrollView.contentOffset.y > 20 {
            headerSliderTab?.barTintColor = nil
        } else {
            headerSliderTab?.barTintColor = .white
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemGroups[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier) as! SettingCell
        cell.item = itemGroups[indexPath.section].items[indexPath.row]
        cell.item?.indexPath = indexPath
        
        if indexPath.section > 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
        } else {
            cell.separatorInset = UIEdgeInsets.zero
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = itemGroups[indexPath.section].items[indexPath.row]
        if let item = item as? SettingTextViewItem {
            return item.cellHeight
        } else if let item = item as? SettingThumbnailGridItem {
            return item.cellNeedHeight
        } else if item is SettingSectionHeaderItem {
            return 36
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = itemGroups[indexPath.section].items[indexPath.row]
        guard item.enable else { return }
        item.action?(item)
        
        guard itemGroups.count > 2 else { return }
        var texts = [String: String]()
        for index in 0..<itemGroups[2].items.count {
            let item = itemGroups[2].items[index]
            if item is SettingTextViewItem, item.subtitle?.isEmpty == false {
                texts[item.title!] = item.subtitle
            }
        }
        if item is SettingTextViewItem || item is SettingThumbnailGridItem {
            var pushingController: PAMovingDossierItemSettingController!
            switch item.name {
            case dissierItemCategoryTitles[0]:
                pushingController = mainTellingItemEditingController
                pushingController.textView?.text = texts["主诉"]
            case dissierItemCategoryTitles[1]:
                pushingController = historyItemEditingController
                pushingController.textView?.text = texts["既往史"]
            case dissierItemCategoryTitles[2]:
                pushingController = allergicHistoryItemEditingController
                pushingController.textView?.text = texts["个人史"]
            case dissierItemCategoryTitles[3]:
                pushingController = treatmentItemEditingController
                pushingController.textView?.text = texts["诊断"]
            default:
                return
            }
            let editingItemGroup = itemGroups[indexPath.section]
            pushingController.title = editingItemGroup.headerTitle
            pushingController.finishedEditingAction = { [weak self] (text, images) in
                if let textViewItem = editingItemGroup.items[indexPath.row] as? SettingTextViewItem {
                    textViewItem.subtitle = text
                } else if let textViewItem = editingItemGroup.items[indexPath.row - 1] as? SettingTextViewItem {
                    textViewItem.subtitle = text
                }
                if images.count > 0 {
                    let newImageGridItem = SettingThumbnailGridItem()
                    newImageGridItem.thumbnails = images.map { (image) -> UIImage in
                        return image.roundingCorner(forRadius: newImageGridItem.imageCornerRadius, sizeToFit: newImageGridItem.imageViewSize) ?? image
                    }
                    newImageGridItem.cellInsets = UIEdgeInsets(top: 10, left: SettingThumbnailGridItem.horizontalIndent, bottom: 1, right: SettingThumbnailGridItem.horizontalIndent)
                    
                    if let item = editingItemGroup.items[indexPath.row] as? SettingThumbnailGridItem {
                        editingItemGroup.items.remove(element: item)
                        editingItemGroup.items.insert(newImageGridItem, at: indexPath.row)
                    } else if let item = editingItemGroup.items[indexPath.row + 1] as? SettingThumbnailGridItem {
                        editingItemGroup.items.remove(element: item)
                        editingItemGroup.items.insert(newImageGridItem, at: indexPath.row + 1)
                    } else {
                        editingItemGroup.items.insert(newImageGridItem, at: indexPath.row + 1)
                    }
                } else {
                    if let item = editingItemGroup.items[indexPath.row] as? SettingThumbnailGridItem {
                        editingItemGroup.items.remove(element: item)
                    } else if let item = editingItemGroup.items[indexPath.row + 1] as? SettingThumbnailGridItem {
                        editingItemGroup.items.remove(element: item)
                    }
                }
                self?.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            }
            navigationController?.pushViewController(pushingController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 2 {
            return 0.000001
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == itemGroups.count - 1 {
            return 10
        }
        return 0.000001
    }
}

