//
//  PAReserveDetailsController.swift
//  wanjia2B
//
//  Created by luozhijun on 2016/12/29.
//  Copyright © 2016年 pingan. All rights reserved.
//

import UIKit
import Masonry

/** 展示已预约患者\医生信息的界面 */
class PAScheduledPersonInfoController: PABaseViewController {

    var isFromAdd = false
    
    var scheduledPerson: Any?
    fileprivate var scheduledPatient: PAScheduledPatient?
    fileprivate var scheduledDoctor:  PAScheduledDoctor?
    
    fileprivate var scrollContentView = UIView()
    
    fileprivate var pictureUrls = [String]()
    fileprivate var symptomLabel = UILabel()
    fileprivate var separator_3 = UIImageView()
    
    fileprivate var httpTasks = [URLSessionTask]()
    
    //MARK: - View Life Cycle
    init(scheduledPerson: Any?) {
        super.init(nibName: nil, bundle: nil)
        self.scheduledPerson = scheduledPerson
        scheduledPatient = scheduledPerson as? PAScheduledPatient
        scheduledDoctor  = scheduledPerson as? PAScheduledDoctor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statisName = "doctorSchedulePatientDetail"
        setupNaviBar()
        setupUI()
        requestPictureUrls()
    }
    
    deinit {
        httpTasks.forEach { $0.cancel() }
        deinitLog(self)
    }
    
    fileprivate func requestPictureUrls() {
        guard let scheduledPersonId = scheduledPatient?.apptOrderCode else { return }
        let task = PAScheduleAndReservationRequests.pictureUrls(ofScheduledPerson: scheduledPersonId, for: self) { [weak self] (pictureUrls, error) in
            if error == nil, let pictureUrls = pictureUrls {
                self?.pictureUrls = pictureUrls
                self?.setupPhotosView()
            }
        }
        if task != nil { httpTasks.append(task!) }
    }
}

//MARK: - Setup UI
extension PAScheduledPersonInfoController {
    fileprivate func setupNaviBar() {
        if isFromAdd {
            let button = UIButton(type: .system)
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 18)
            button.addTarget(self, action: #selector(backActionFromAdd), for: .touchUpInside)
            button.setImage(UIImage(named: "back_leftButton"), for: .normal)
            button.contentHorizontalAlignment = .left
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
            let backItem = UIBarButtonItem(customView: button)
            navigationItem.leftBarButtonItem = backItem
        }
    }
    
    fileprivate func setupUI() {
        title = "预约详情"
        
        let padding_15: CGFloat = 15.0
        let padding_12: CGFloat = 12.0
        let padding_6 : CGFloat = 6
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.alwaysBounceVertical = true
        scrollView.mas_makeConstraints { (make) in
            make!.left.right().bottom().mas_equalTo()(self.view)
            make!.top.mas_equalTo()(self.view)?.setOffset(64)
        }
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.backgroundColor = .white
        scrollContentView.mas_makeConstraints { (make) in
            make!.edges.mas_equalTo()(scrollView)
            make!.width.mas_equalTo()(scrollView)
        }
        
        
        let timeLabel = UILabel()
        scrollContentView.addSubview(timeLabel)
        timeLabel.textColor = UIColor.paOrangeColor()
        timeLabel.font = UIFont.systemFont(ofSize: 18)
        timeLabel.mas_makeConstraints { (make) in
            make!.left.mas_equalTo()(self.scrollContentView)?.setOffset(padding_15)
            make!.top.mas_equalTo()(self.scrollContentView)?.setOffset(padding_15)
            make!.right.mas_equalTo()(self.scrollContentView)?.setOffset(-padding_15)
        }
        
        let separator_1 = UIImageView()
        scrollContentView.addSubview(separator_1)
        separator_1.backgroundColor = UIColor.paDividingColor()
        separator_1.mas_makeConstraints { (make) in
            make!.left.right().mas_equalTo()(self.scrollContentView)
            make!.top.mas_equalTo()(timeLabel.mas_bottom)?.setOffset(padding_15)
            make!.height.mas_equalTo()(PADeviceSize.separatorSize)
        }
        
        let nameLabel = UILabel()
        scrollContentView.addSubview(nameLabel)
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.mas_makeConstraints { (make) in
            make!.left.right().mas_equalTo()(timeLabel)
            make!.top.mas_equalTo()(separator_1.mas_bottom)?.setOffset(padding_15)
        }
        
        let sexLabel = UILabel()
        scrollContentView.addSubview(sexLabel)
        sexLabel.font = nameLabel.font
        sexLabel.mas_makeConstraints { (make) in
            make!.left.right().mas_equalTo()(nameLabel)
            make!.top.mas_equalTo()(nameLabel.mas_bottom)?.setOffset(padding_12)
        }
        
        let birthdayLabel = UILabel()
        scrollContentView.addSubview(birthdayLabel)
        birthdayLabel.font = nameLabel.font
        birthdayLabel.mas_makeConstraints { (make) in
            make!.left.right().mas_equalTo()(nameLabel)
            make!.top.mas_equalTo()(sexLabel.mas_bottom)?.setOffset(padding_12)
        }
        
        let phoneNumberLabel = UILabel()
        scrollContentView.addSubview(phoneNumberLabel)
        phoneNumberLabel.font = nameLabel.font
        phoneNumberLabel.mas_makeConstraints { (make) in
            make!.left.right().mas_equalTo()(nameLabel)
            make!.top.mas_equalTo()(birthdayLabel.mas_bottom)?.setOffset(padding_12)
        }
        
        let separator_2 = UIImageView()
        scrollContentView.addSubview(separator_2)
        separator_2.backgroundColor = UIColor.paDividingColor()
        separator_2.mas_makeConstraints { (make) in
            make!.left.right().mas_equalTo()(self.scrollContentView)
            make!.top.mas_equalTo()(phoneNumberLabel.mas_bottom)?.setOffset(padding_15)
            make!.height.mas_equalTo()(PADeviceSize.separatorSize)
        }
        
        let symptomPrefixLabel = UILabel()
        scrollContentView.addSubview(symptomPrefixLabel)
        symptomPrefixLabel.font = nameLabel.font
        symptomPrefixLabel.text = "症状描述："
        symptomPrefixLabel.mas_makeConstraints { (make) in
            make!.left.right().mas_equalTo()(nameLabel)
            make!.top.mas_equalTo()(separator_2.mas_bottom)?.setOffset(padding_15)
        }
        
        scrollContentView.addSubview(symptomLabel)
        symptomLabel.font = nameLabel.font
        symptomLabel.numberOfLines = 0
        symptomLabel.mas_makeConstraints { (make) in
            make!.left.right().mas_equalTo()(nameLabel)
            make!.top.mas_equalTo()(symptomPrefixLabel.mas_bottom)?.setOffset(padding_6)
        }
        
        //MARK: Setup Data
        guard let scheduledPatient = scheduledPatient else { return }
        timeLabel.text = "就诊时间：" + "\(scheduledPatient.timeSpanStartTime ?? "")~\(scheduledPatient.timeSpanEndTime ?? "")"
        guard let patientPersonalInfo = scheduledPatient.patientVisit else { return }
        nameLabel.text = "患者姓名：" + (patientPersonalInfo.name ?? "")
        if let sexCode = patientPersonalInfo.sexCode {
            sexLabel.text = "患者性别：" + (sexCode == "1" ? "男" : "女")
        } else {
            sexLabel.text = "患者性别：" + "未知"
        }
        birthdayLabel.text    = "出生日期：" + (patientPersonalInfo.birthday ?? "")
        phoneNumberLabel.text = "手机号码：" + (patientPersonalInfo.mobile   ?? "")
        symptomLabel.text     = scheduledPatient.apptRemark
    }
    
    fileprivate func setupPhotosView() {
        let padding_15: CGFloat = 15.0
        let padding_2 : CGFloat = 2
        
        guard pictureUrls.count > 0 else {
            scrollContentView.addSubview(separator_3)
            separator_3.backgroundColor = UIColor.paDividingColor()
            separator_3.mas_makeConstraints { (make) in
                make!.left.right().mas_equalTo()(self.scrollContentView)
                make!.top.mas_equalTo()(self.symptomLabel.mas_bottom)?.setOffset(padding_15)
                make!.height.mas_equalTo()(PADeviceSize.separatorSize)
            }
            
            scrollContentView.mas_makeConstraints { (make) in
                make!.bottom.mas_equalTo()(self.separator_3)
            }
            return
        }
        
        let photosConstraintWidth = view.frame.width - 2*padding_15
        let lineAmount: CGFloat = 4
        let photoWidth = (photosConstraintWidth - (lineAmount-1)*padding_2) / lineAmount
        let photoHeight: CGFloat = 80
        
        var photoLeftLayoutRefrenceView: UIView = scrollContentView
        var photoTopLayoutRefrenceView: UIView  = self.symptomLabel
        var leftPadding = padding_15
        var previousPhotoView: UIView! = nil
        for index in 0..<pictureUrls.count {
            let photoView = UIButton(type: .custom)
            scrollContentView.addSubview(photoView)
            photoView.tag = index
            if index % Int(lineAmount) == 0 {
                photoLeftLayoutRefrenceView = scrollContentView
                leftPadding = padding_15
                if index > 0 {
                    photoTopLayoutRefrenceView = previousPhotoView
                }
            } else {
                photoLeftLayoutRefrenceView = previousPhotoView
                leftPadding = padding_2
            }
            photoView.mas_makeConstraints({ (make) in
                make!.top.mas_equalTo()(photoTopLayoutRefrenceView.mas_bottom)?.setOffset(padding_2)
                if photoLeftLayoutRefrenceView == self.scrollContentView {
                    make!.left.mas_equalTo()(photoLeftLayoutRefrenceView)?.setOffset(leftPadding)
                } else {
                    make!.left.mas_equalTo()(photoLeftLayoutRefrenceView.mas_right)?.setOffset(leftPadding)
                }
                make!.width.mas_equalTo()(photoWidth)
                make!.height.mas_equalTo()(photoHeight)
            })
            if let url = URL(string: pictureUrls[index]) {
                photoView.sd_setImage(with: url, for: .normal)
            }
            photoView.addTarget(self, action: #selector(photoTapped), for: .touchUpInside)
            previousPhotoView = photoView
        }
        
        scrollContentView.addSubview(separator_3)
        separator_3.backgroundColor = UIColor.paDividingColor()
        separator_3.mas_makeConstraints { (make) in
            make!.left.right().mas_equalTo()(self.scrollContentView)
            make!.top.mas_equalTo()(previousPhotoView.mas_bottom)?.setOffset(padding_15)
            make!.height.mas_equalTo()(PADeviceSize.separatorSize)
        }
        
        scrollContentView.mas_makeConstraints { (make) in
            make!.bottom.mas_equalTo()(self.separator_3)
        }
    }
}

//MARK: - Handle Events
extension PAScheduledPersonInfoController {
    @objc fileprivate func backActionFromAdd() {
        guard let vcs = navigationController?.viewControllers else { return }
        let index = vcs.count - 3;
        if index >= 0 {
            // 跳转到预约控制器
            let appointmentVc = vcs[index]
            _ = navigationController?.popToViewController(appointmentVc, animated: true)
        }
    }
    
    @objc fileprivate func photoTapped(sender: UIButton) {
        let photoBrowser = PAPhotoBrowser()
        photoBrowser.photos = pictureUrls
        photoBrowser.currentIndex = sender.tag
        present(photoBrowser, animated: true, completion: nil)
    }
}
