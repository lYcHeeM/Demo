//
//  PAModel.swift
//  wanjia2B
//
//  Created by luozhijun on 2017/5/18.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit

// 诊所资质审核状态
public enum PAClinicCheckStatus : Int {
    /// 待完善资料 
    case waitPerfectState = 0
    /// 待审核 
	case waitCheckState
    /// 初审通过 
	case firstPassState
    /// 初审退回 
	case firstBackState
    /// 初审失败 
	case firstFailState
    /// 待完善审核通过（初审）~ 
    case waitPerfectFirstPassState
    /// 复审通过~ 
    case nextPassState = 11
    /// 复审退回 
	case nextBackState
    /// 待完善审核通过（复审）~ 
    case waitPerfectNextPassState
    /// 更新待审核~ 
    case updateWaitCheckState = 21
    /// 更新初审通过~ 
    case updateFirstPassState
    /// 更新初审退回~ 
    case updateFirstBackState
    /// 更新复审通过~ 
    case updateNextFailState
    /// 更新复审退回~ 
    case updateNextBackState
}

// 医生资质审核状态
public enum PADoctorCheckStatus : Int {
    /// 未提交 
	case notSubmitState = 0
    /// 待审核 
	case waitCheckState
    /// 初审通过 
	case firstPassState
    /// 初审退回 
	case firstBackState
    /// 复审通过 
	case nextPassState = 12
    /// 复审退回 
	case nextBackState
}

// 医生上线状态
public enum PADoctorIsView : Int {
    /// 未上线 
	case notOnlineState = 0
    /// 已上线 
	case onlineState
    /// 已下线 
	case offlineState
}

// 诊所资质审核状态
public enum PAChainClinicCheckStatus : Int {
    /// 待完善资料 
    case waitPerfectState = 0
    /// 待审核 
	case waitCheckState
    /// 审核通过 
	case passState
    /// 审核退回 
	case backState
    /// 审核失败 
    case failState
    /// 更新审核
    case updateCheckState
    /// 更新成功 
	case updatePassState
    /// 更新退回 
	case updateBackState
    /// 更新失败 
	case updateFailState
}

