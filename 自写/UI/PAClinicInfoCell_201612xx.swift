//
//  PAClinicInfoCell.swift
//  wanjia2B
//
//  Created by luozhijun on 2016/11/2.
//  Copyright © 2016年 pingan. All rights reserved.
//  显示诊所信息的cell

import UIKit
import SDWebImage

/** 显示诊所信息的cell */
class PAClinicInfoCell: UITableViewCell {

    //MARK: - Properties
    static let reuseIdentifier = "PAClinicInfoCell"
    
    var bgView              = UIView()
    var topSeparator        = UIView()
    var mainImage           = UIImageView()
    var textContentView     = UIView()
    var titleLabel          = UILabel()
    var genreLabel          = UILabel()
    var authenticationBadge = UILabel()
    var insuranceBadge      = UILabel()
    var addressLabel        = UILabel()
    var midSeparator        = UIView()
    var associateBtn        = UIButton(type: .system)
    var bottomSeparator     = UIView()
    
    var indexPath: IndexPath?
    
    var associatedBtnClickedAtIndexPath: ((IndexPath) -> Void)?
    
    var dataModel: PAClinicInfo? {
        didSet {
            guard let dataModel = dataModel else { return }
            let imageRootPath   = PAUserDefaults.sharedInstance.loginUserBaseModel?.imageRoot
            mainImage.sd_setImage(with: URL(string: (imageRootPath ?? "") + (dataModel.clinicLogoPath ?? "")), placeholderImage: UIImage(named: "image_default_clinic"))
            titleLabel.text     = dataModel.clinicName
            genreLabel.text     = dataModel.diagnosisType1
            addressLabel.text   = dataModel.fullAddressWithCountry

            if dataModel.isView != nil {
                authenticationBadge.isHidden = dataModel.isView == "0"
            } else {
                authenticationBadge.isHidden = true
            }
            if dataModel.isMedicalInsurance != nil {
                insuranceBadge.isHidden      = dataModel.isMedicalInsurance == "0"
            } else {
                insuranceBadge.isHidden      = true
            }
            
            let authenticationBadgeNeedSize = authenticationBadge.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            if authenticationBadge.isHidden {
                insuranceBadge.mas_remakeConstraints({ (make) in
                    make!.left.mas_equalTo()(self.titleLabel)
                    make!.centerY.mas_equalTo()(self.authenticationBadge)
                })
            } else {
                insuranceBadge.mas_remakeConstraints({ (make) in
                    make!.left.mas_equalTo()(self.authenticationBadge.mas_right)?.setOffset(6)
                    make!.centerY.mas_equalTo()(self.authenticationBadge)
                })
            }
            
            let padding_12: CGFloat = 12.0
            let padding_10: CGFloat = 10.0
//            let padding_8 : CGFloat = 8.0

            
//            var addressLabelLayoutPriorView: UIView = authenticationBadge
            var badgeNeedHeight: CGFloat = authenticationBadgeNeedSize.height + padding_10
            if authenticationBadge.isHidden && insuranceBadge.isHidden {
//                addressLabelLayoutPriorView = genreLabel
                badgeNeedHeight = 0.0
            }
            
            let titleLabelConstraintSize = CGSize(width: UIScreen.width - padding_12 - mainImage.bounds.size.width - padding_12 - padding_12, height: CGFloat.greatestFiniteMagnitude)
            
            let titleLabelNeedHeight = titleLabel.sizeThatFits(titleLabelConstraintSize).height
            let genreLabelNeedHeight = genreLabel.sizeThatFits(titleLabelConstraintSize).height
            let addressLabelNeedHeight = addressLabel.sizeThatFits(titleLabelConstraintSize).height
            addressLabel.mas_remakeConstraints { (make) in
                make!.left.right().mas_equalTo()(self.titleLabel)
//                make!.top.mas_equalTo()(addressLabelLayoutPriorView.mas_bottom)?.setOffset(padding_8)
                make!.bottom.mas_equalTo()(self.mainImage)
                // warning 发现不加这句会导致少数情况下高度不正确
                make!.height.mas_equalTo()(addressLabelNeedHeight)
            }
            
            let textContentNeedHeight = titleLabelNeedHeight + padding_10 + genreLabelNeedHeight + badgeNeedHeight + padding_10 + addressLabelNeedHeight
            if textContentNeedHeight < self.mainImage.bounds.size.height {
                midSeparator.mas_remakeConstraints ({ (make) in
                    make!.left.mas_equalTo()(self.mainImage)
                    make!.right.mas_equalTo()(self.bgView)
                    make!.height.mas_equalTo()(UIScreen.separatorSize)
                    make!.top.mas_equalTo()(self.mainImage.mas_bottom)?.setOffset(padding_10)
                })
            } else {
                midSeparator.mas_remakeConstraints({ (make) in
                    make!.left.mas_equalTo()(self.mainImage)
                    make!.right.mas_equalTo()(self.bgView)
                    make!.height.mas_equalTo()(UIScreen.separatorSize)
                    make!.top.mas_equalTo()(self.addressLabel.mas_bottom)?.setOffset(padding_10)
                })
            }
        }
    }
    
    //MARK: - Life Cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupSubviews()
        setupConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup UI
extension PAClinicInfoCell {
    fileprivate func setupSubviews() {
        contentView.backgroundColor = UIColor.paBackground
        
        contentView.addSubview(bgView)
        bgView.backgroundColor = UIColor.white
        
        bgView.addSubview(topSeparator)
        topSeparator.layer.backgroundColor = UIColor.paDividing.cgColor
        
        bgView.addSubview(mainImage)
        mainImage.bounds.size = CGSize(width: 92, height: 92)
        mainImage.contentMode = .scaleAspectFill
        mainImage.clipsToBounds = true
        
        bgView.addSubview(textContentView)
        
        bgView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
//        titleLabel.numberOfLines = 0
        titleLabel.text = "测试"
        
        bgView.addSubview(genreLabel)
        genreLabel.font = UIFont.systemFont(ofSize: 14)
        genreLabel.textColor = UIColor.paGray
//        genreLabel.numberOfLines = 0
        genreLabel.text = "测试"
        
        bgView.addSubview(authenticationBadge)
        authenticationBadge.font                = UIFont.systemFont(ofSize: 12)
        authenticationBadge.textColor           = UIColor.paOrange
        authenticationBadge.text                = " 上线 "
        authenticationBadge.layer.cornerRadius  = 2.0
        authenticationBadge.layer.borderColor   = authenticationBadge.textColor.cgColor
        authenticationBadge.layer.borderWidth   = UIScreen.separatorSize
        authenticationBadge.layer.masksToBounds = true
        // warning 发现少数情况下, 这个label的高度会被挤压, 这里显示设置以避免
        authenticationBadge.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        
        bgView.addSubview(insuranceBadge)
        insuranceBadge.font                = authenticationBadge.font
        insuranceBadge.textColor           = UIColor(hexString: "6d99ff")
        insuranceBadge.text                = " 医保 "
        insuranceBadge.layer.cornerRadius  = 2.0
        insuranceBadge.layer.borderColor   = insuranceBadge.textColor.cgColor
        insuranceBadge.layer.borderWidth   = UIScreen.separatorSize
        insuranceBadge.layer.masksToBounds = true
        insuranceBadge.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        
        bgView.addSubview(addressLabel)
        addressLabel.textColor = UIColor.paGray
        addressLabel.font = UIFont.systemFont(ofSize: 14)
//        addressLabel.numberOfLines = 0

        addressLabel.text = "测试"
        
        bgView.addSubview(midSeparator)
        midSeparator.layer.backgroundColor = topSeparator.layer.backgroundColor
        
        bgView.addSubview(associateBtn)
        associateBtn.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 85, height: 26))
        associateBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        associateBtn.setTitleColor(UIColor.paOrange, for: UIControlState())
        associateBtn.setTitle("申请关联", for: UIControlState())
        associateBtn.layer.cornerRadius = 4.0
        associateBtn.layer.borderColor = UIColor.paOrange.cgColor
        associateBtn.layer.borderWidth = UIScreen.roundRectButtonBorderWidth
        associateBtn.layer.masksToBounds = true
        associateBtn.addTarget(self, action: #selector(associateBtnClicked), for: .touchUpInside)
        
        bgView.addSubview(bottomSeparator)
        bottomSeparator.layer.backgroundColor = topSeparator.layer.backgroundColor
    }
    
    fileprivate func setupConstraints() {
        
        let padding_12: CGFloat = 12.0
//        let padding_10: CGFloat = 10.0
        let padding_8:  CGFloat = 8.0
        
        let bgViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        bgView.mas_makeConstraints { (make) in
            make!.edges.mas_equalTo()(self.contentView)?.setInsets(bgViewInsets)
        }
        
        topSeparator.mas_makeConstraints { (make) in
            make!.top.left().right().mas_equalTo()(self.bgView)
            make!.height.mas_equalTo()(UIScreen.separatorSize)
        }
        
        mainImage.mas_makeConstraints { (make) in
            make!.top.mas_equalTo()(self.topSeparator.mas_bottom)?.setOffset(padding_12)
            make!.left.mas_equalTo()(self.bgView)?.setOffset(padding_12)
            make!.width.mas_equalTo()(self.mainImage.bounds.size.width)
            make!.height.mas_equalTo()(self.mainImage.bounds.size.height)
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make!.top.mas_equalTo()(self.mainImage)
            make!.left.mas_equalTo()(self.mainImage.mas_right)?.setOffset(padding_12)
            make!.right.mas_equalTo()(self.bgView)?.setOffset(-padding_12)
        }
        
        genreLabel.mas_makeConstraints { (make) in
            make!.top.mas_equalTo()(self.titleLabel.mas_bottom)?.setOffset(padding_8)
            make!.left.right().mas_equalTo()(self.titleLabel)
        }
        
        authenticationBadge.mas_makeConstraints { (make) in
            make!.top.mas_equalTo()(self.genreLabel.mas_bottom)?.setOffset(padding_8)
            make!.left.mas_equalTo()(self.genreLabel)
        }
        
        associateBtn.mas_makeConstraints { (make) in
            make!.top.mas_equalTo()(self.midSeparator.mas_bottom)?.setOffset(padding_8)
            make!.right.mas_equalTo()(self.bgView)?.setOffset(-padding_12)
            make!.width.mas_equalTo()(self.associateBtn.bounds.size.width)
            make!.height.mas_equalTo()(self.associateBtn.bounds.size.height)
        }
        
        bottomSeparator.mas_makeConstraints { (make) in
            make!.top.mas_equalTo()(self.associateBtn.mas_bottom)?.setOffset(padding_8)
            make!.height.mas_equalTo()(UIScreen.separatorSize)
            make!.left.right().mas_equalTo()(self.bgView)
            make!.bottom.mas_equalTo()(self.bgView)
        }
    }
}

//MARK: - Handle Events
extension PAClinicInfoCell {
    @objc fileprivate func associateBtnClicked() {
        guard indexPath != nil else { return }
        associatedBtnClickedAtIndexPath?(indexPath!)
    }
}
