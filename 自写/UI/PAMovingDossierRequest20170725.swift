//
//  PAMedicineSearchRequest.swift
//  wanjia2B
//
//  Created by luozhijun on 17/3/20.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit

class PAMovingDossierRequest {
    
    /// 保存病历
    @discardableResult
    class func saveDossier(_ param: PAMovingDossierSavingParam, for controller: UIViewController? = nil, finished: @escaping (PAMovingDossierSavingResponse?) -> Void) -> URLSessionTask? {
        guard let dictParam = param.yy_modelToJSONObject() as? RequestResponseDictionary  else { return nil }
        return PARequest.post(withParams: dictParam, for: controller, finished: { (responseModel, error) in
            var response: PAMovingDossierSavingResponse? = nil
            if let responseModel = responseModel, let result = responseModel.result as? RequestResponseDictionary {
                response = PAMovingDossierSavingResponse.yy_model(with: result)
            }
            finished(response)
        })
    }
    
    /// 单张上传病历图片
    @discardableResult
    class func upload(image: UIImage, progress: ((Progress) -> Void)? = nil, finished: @escaping (String?) -> Void) -> URLSessionTask? {
        let param: RequestResponseDictionary = ["app_code": "37017", "imageName": "temp.jpg"]
        let scaledImage = image.scaledImage(to: 1024)
        /// 按产品要求, 压缩系数和资格认证上传图片时的保持一致
        let data = UIImageJPEGRepresentation(scaledImage, 0.8)
        let request = PARequest()
        var result: String?
        request.start(withImageData: data, requestParams: param) { (response) in
            if response.isResponseSuccess, let resultDict = response.baseResponseModel?.result as? [String: Any] {
                result = resultDict["imageUrl"] as? String
                debugLog(response.baseResponseModel?.result)
            }
            finished(result)
        }
        return request.sessionTask
    }
    
    /// 多张图片异步上传
    /// - parameter images: [图片唯一标识: 图片对象]
    @discardableResult
    class func upload(images: [PAMovingDossierImages], progress: ((Double) -> Void)? = nil, finished: @escaping ([PAMovingDossierImages]?) -> Void) -> [URLSessionTask?] {
        var results: [PAMovingDossierImages]! = []
        var totalFullScreenImagesCount = 0
        for item in images {
            totalFullScreenImagesCount += item.fullScreenImages.count
        }
        var tasks = [URLSessionTask?]()
        for index1 in 0..<images.count {
            let imagesModel = images[index1]
            guard let name = imagesModel.name, imagesModel.images.count > 0 else { continue }
            let result = PAMovingDossierImages()
            result.type = imagesModel.type
            result.name = name
            results.append(result)
            for index2 in 0..<imagesModel.fullScreenImages.count {
                let image = imagesModel.fullScreenImages[index2]
                let task = upload(image: image, progress: { p in
//                    result.progress += p.fractionCompleted/Double(imagesModel.images.count)
//                    let sumOfProgressInResults = results.reduce(0, { (accumlatedValue, result) -> Double in
//                        return accumlatedValue + result.progress
//                    })
//                    let globleProgress = sumOfProgressInResults/Double(results.count)
//                    progress?(globleProgress)
                }, finished: { (urlString) in
                    guard let urlString = urlString else {
                        finished(nil)
                        return
                    }
                    result.imageUrls.append(urlString)
                    var totalImageUrlsCount = 0
                    for item in results {
                        totalImageUrlsCount += item.imageUrls.count
                    }
                    if results.count == images.count && totalImageUrlsCount == totalFullScreenImagesCount {
                        finished(results)
                    }
                })
                tasks.append(task)
            }
        }
        return tasks
    }
    
    /// 查询病历详情
    @discardableResult
    class func fetchDossier(_ param: (medicalType: String, empiId: String, acographyId: String), for controller: UIViewController?, finished: @escaping (PAMovingDossierDetialResponse?) -> Void) -> URLSessionTask? {
        let params = ["app_code": "37002", "medicalType": param.medicalType, "clinicId": PAUserDefaults.sharedInstance.getCurrentClinicId(), "empiId": param.empiId, "acographyId": param.acographyId]
        return PARequest.post(withParams: params, for: controller, finished: { (responseModel, error) in
            var response: PAMovingDossierDetialResponse? = nil
            if let responseModel = responseModel, let result = responseModel.result as? RequestResponseDictionary {
                response = PAMovingDossierDetialResponse()
                var cnMedical: PAMovingDossierDetialResponse.CNMedical?
                if let cnMedicalDict = result["cnMedical"] as? RequestResponseDictionary {
                    cnMedical = PAMovingDossierDetialResponse.CNMedical.yy_model(with: cnMedicalDict)
                    if cnMedical?.acographyId?.isEmpty == false || cnMedical?.empiId?.isEmpty == false {
                        response?.cnMedical = cnMedical
                    }
                }
                
                var westMedical: PAMovingDossierDetialResponse.WestMedicalMedical?
                if let westMedicalDict = result["westMedicalMedical"] as? RequestResponseDictionary {
                    westMedical = PAMovingDossierDetialResponse.WestMedicalMedical()
                    if let dwsDiagnosisRecordList = westMedicalDict["dwsDiagnosisRecordList"] as? [RequestResponseDictionary] {
                        if let dwsDiagnosisRecordModels = NSArray.yy_modelArray(with: PAMovingDossierSavingParam.Diagnosis.self, json: dwsDiagnosisRecordList) as? [PAMovingDossierSavingParam.Diagnosis] {
                            westMedical?.dwsDiagnosisRecordList = dwsDiagnosisRecordModels
                        }
                    }
                    if let dwsMedicalRecordDict = westMedicalDict["dwsMedicalRecord"] as? RequestResponseDictionary {
                        westMedical?.dwsMedicalRecord = PAMovingDossierSavingParam.PolyclinicMedicalInfo.DwsMedicalRecord.yy_model(with: dwsMedicalRecordDict)
                    }
                    if westMedical?.dwsMedicalRecord?.acographyId?.isEmpty == false || westMedical?.dwsMedicalRecord?.empiId?.isEmpty == false {
                        response?.westMedicalMedical = westMedical
                    }
                }
            }
            finished(response)
        })
    }
    
    /// 更新就诊人(患者)信息
    @discardableResult
    class func updatePatientInfo(_ patient: PAMovingDossierPatientModel?, param: PAMovingDossierUpdatePatientParam, for controller: UIViewController?, finished: @escaping (PAMovingDossierUpdatePatientResponse?) -> Void) -> URLSessionTask? {
        guard let dictParams = param.yy_modelToJSONObject() as? RequestResponseDictionary else { return nil }
        return PARequest.post(withParams: dictParams, for: controller, finished: { (responseModel, error) in
            var response: PAMovingDossierUpdatePatientResponse? = nil
            if let responseModel = responseModel, let result = responseModel.result as? RequestResponseDictionary {
                response = PAMovingDossierUpdatePatientResponse.yy_model(with: result)
                if response?.resultCode != "E0000000" {
                    response       = nil
                    if response?.resultMsg?.isEmpty != false {
                        PAMBManager.sharedInstance.showBriefMessage(message: response?.resultMsg, view: controller?.view)
                    }
                } else if let acographyId = response?.acographyId, !acographyId.isEmpty {
                    patient?.acogryphyId = acographyId
                }
            }
            finished(response)
        })
    }
    
    /// 快速接诊
    @discardableResult
    class func fastReception(with receptionModel: PAMovingDossierFastReceptionParam.FastReceptionInfo, for controller: UIViewController?, finished: @escaping (PAMovingDossierFastReceptionResponse?) -> Void) -> URLSessionTask? {
        let params = PAMovingDossierFastReceptionParam()
        params.fastRigisteInfo = receptionModel.yy_modelToJSONString()
        guard let dictParams = params.yy_modelToJSONObject() as? RequestResponseDictionary else { return nil }
        return PARequest.post(withParams: dictParams, for: controller, finished: { (responseModel, error) in
            var fastReceptionResponse: PAMovingDossierFastReceptionResponse? = nil
            if let responseModel = responseModel, let result = responseModel.result as? RequestResponseDictionary {
                fastReceptionResponse = PAMovingDossierFastReceptionResponse.yy_model(with: result)
            }
            finished(fastReceptionResponse)
        })
    }
    
    class func medicineSearchRequest(keyword: String, drugSortId: String, drugPropType: String, responseBlock:@escaping PARequestCompletionBlock) -> PARequest {
        var params = ["app_code": "37013",
                      "clinicId": PAUserDefaults.sharedInstance.getCurrentClinicId(),
                      "keyword": keyword,
                      "drugPropType":drugPropType]
        if drugSortId != ""{
            params["drugSortId"] = drugSortId
        }
        return PARequest().start(requestParams: params, completionBlock: { (response) in
            responseBlock(response)
        })
    }
    
    //处方查询
    class func queryPrescriptionList(acographyId:String,responseSuccessBlock:@escaping PARequestCompletionBlock) -> PARequest {
        let params = ["app_code": "37010",
                      "clinicId": PAUserDefaults.sharedInstance.getCurrentClinicId(),
                      "acographyId":acographyId]
        return PARequest().start( requestParams: params) { response in
            responseSuccessBlock(response)
        }
    }
    //查询中药类型（颗粒剂/饮片）
    class func startChineseMedicineTypeRequest(responseBlock:@escaping PARequestCompletionBlock) -> PARequest{
        let params = ["app_code": "37014",
                      "clinicId": PAUserDefaults.sharedInstance.getCurrentClinicId()]
        return PARequest().start(requestParams: params, completionBlock: { (response) in
            responseBlock(response)
        })
    }
    
    //西药频率 用法
    class func queryUsageAndFrequence(responseSuccessBlock:@escaping PARequestCompletionBlock) -> PARequest {
        let params = ["app_code": "37003",
                      "clinicId":PAUserDefaults.sharedInstance.getCurrentClinicId()]
        return PARequest().start( requestParams: params) { response in
            responseSuccessBlock(response)
        }
    }
    
    //新增或修改草药处方
    class func addOrUpdatePrescription(jsonStr:String,acographyId:String,responseSuccessBlock:@escaping PARequestCompletionBlock) -> PARequest {
        let params = ["app_code": "37011",
                      "clinicId":PAUserDefaults.sharedInstance.getCurrentClinicId(),
                      "acographyId":acographyId,
                      "dwsRecipes":jsonStr]
        return PARequest().start(requestParams: params) { response in
            responseSuccessBlock(response)
        }
    }
    
    //删除一个中药处方
    class func deletePrescription(recipeId rid:String,responseSuccessBlock:@escaping PARequestCompletionBlock) -> PARequest {
        let params = ["app_code": "37012",
                      "recipeId":rid,
                      "clinicId":PAUserDefaults.sharedInstance.getCurrentClinicId()]
        return PARequest().start(requestParams: params) { response in
            responseSuccessBlock(response)
        }
    }
    
    //新增／修改西药
    class func addOrUpdateWestPrescription(dwsRecipes json:String,acographyId:String,responseSuccessBlock:@escaping PARequestCompletionBlock) -> PARequest {
        let params = ["app_code": "37009",
                      "clinicId":PAUserDefaults.sharedInstance.getCurrentClinicId(),
                      "dwsRecipes":json,
                      "acographyId":acographyId]
        return PARequest().start(requestParams: params) { response in
            responseSuccessBlock(response)
        }
    }
    
    //草药加工方式
    class func queryProcessingTypes(responseSuccessBlock:@escaping PARequestCompletionBlock) -> PARequest {
        let params = ["app_code": "37015",
                      "clinicId":PAUserDefaults.sharedInstance.getCurrentClinicId()]
        return PARequest().start( requestParams: params) { response in
            responseSuccessBlock(response)
        }
    }
    
    //删除西药
    class func deleteWestPrescription(precriptionId:String,responseSuccessBlock:@escaping PARequestCompletionBlock) -> PARequest {
        let params = ["app_code": "37016",
                      "clinicId":PAUserDefaults.sharedInstance.getCurrentClinicId(),
                      "recipeId":precriptionId]
        return PARequest().start(requestParams: params) { response in
            responseSuccessBlock(response)
        }
    }
    
    //日志记录云之声调用情况 status 0:失败 1:成功 consumeTimes 本次请求耗时
    class func writeYunzhishenLog(status:String,consumeTimes:String,voiceText:String) {
        let params = ["app_code": "17701",
                      "osName":"ios",
                      "callDate":String(CLongLong( Date().timeIntervalSince1970 * 1000)),
                      "status":status,
                      "consumeTimes":consumeTimes,
                      "voiceText":voiceText,
                      "clinicId":PAUserDefaults.sharedInstance.getCurrentClinicId()]
        PARequest().start(requestParams: params, completionBlock: nil)
    }
}
