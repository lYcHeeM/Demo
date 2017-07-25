//
//  PARequestHelper.swift
//  wanjia2B
//
//  Created by luozhijun on 2016/12/13.
//  Copyright © 2016年 pingan. All rights reserved.
//

import Foundation
import MBProgressHUD
import AFNetworking
import YYModel

//MARK: - Error
public enum PAResponseError: Error {
    /// 服务器返回的统一格式的ResponseModel(见PAResponseModel.h)解析错误的原因
    public enum ResponseModelSerializationFailedReason {
        /// responseModel为空
        case responseModelNil
        /// responseModel中的result在属性类型转换时失败
        case resultTypeConvertFailed
        /// responseModel中的result转成模型数据失败
        case transformResultToModelFailed(error: Error?)
    }
    
    /// 服务器返回的统一格式的ResponseModel中的status字段校验不通过错误
    case responseModelValidationFailed
    /// 服务器返回的统一格式的ResponseModel(见PAResponseModel.h)解析错误
    case responseModelSerializationFailed(reason: ResponseModelSerializationFailedReason)
}

extension PAResponseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .responseModelValidationFailed:
            return "ResponseModel validation failed: `responseModel.status != SUCCESS`"
        case .responseModelSerializationFailed(let reason):
            return reason.localizedDescription
        }
    }
}

extension PAResponseError.ResponseModelSerializationFailedReason {
    public var localizedDescription: String {
        switch self {
        case .responseModelNil:
            return "`ResponseModel` is nil."
        case .resultTypeConvertFailed:
            return "Convert `result` to sepecific type failed."
        case .transformResultToModelFailed(let error):
            return "Transform `result` to model failed, error:\n\(error?.localizedDescription ?? "")"
        }
    }
}

//MARK: - PABaseRequest Extension
typealias RequestResponseDictionary = [String: Any]

extension PABaseRequest {
    class func post(withParams params: RequestResponseDictionary, at controller: UIViewController, serverFailureMessage: String = "数据拉取失败, 请稍后重试", finished: @escaping (PAResponseModel?, Error?) -> Void) -> URLSessionTask? {
        controller.updating(withMessage: nil)
        return PABaseRequest.post(withParams: params, success: { (responseModel) in
            controller.updatingEnd()
            var error: PAResponseError? = nil
            if responseModel?.status != "SUCCESS" {
                var errorMessage: String? = nil
                // 如果服务器有返回错误信息, 则使用之, 否则使用上层调用者传递的参数
                if let count = responseModel?.errorMsg.characters.count, count > 0 {
                    errorMessage = responseModel?.errorMsg
                } else {
                    errorMessage = serverFailureMessage
                }
                PAMBManager.sharedInstance.showBriefMessage(message: errorMessage, view: controller.view)
                error = PAResponseError.responseModelValidationFailed
            }
            
            if responseModel == nil && error == nil {
                error = PAResponseError.responseModelSerializationFailed(reason: .responseModelNil)
            }
            
            finished(responseModel, error)
        }) { (error) in
            controller.updatingEnd()
            finished(nil, error)
        }
    }
    
    class func yy_model(of type: AnyClass, json: Any?) -> Any? {
        if let NSObjectClass = type as? NSObject.Type, let json = json as? RequestResponseDictionary {
            return NSObjectClass.yy_model(with: json)
        }
        return nil
    }
    
    /**
     - parameter formData:           需要上传的数据
     - parameter progressHint:       对于success提示, 如果progressHint.success为nil, 不提示任何信息; 如果progressHint.success不为nil, 但长度位0, 则使用progressHint.defaultSuccessHint作为提示, 如果长度不为0, 则以progressHint.success作为提示；   对于failure提示, 如果progressHint中的failure不为nil, 则用hud提示错误, 否则不提示任何错误; 提示信息的优先级为：如果progressHint中的failure长度不为零, 则使用之；否则若服务器返回的错误信息长度不为零, 则使用之；否则使用PAProgressHint中的serverFailureMessage字段
     。
     - parameter responseModelClass: 目标模型的类名
     */
    class func request(_ url: String, method: PAHTTPMethod = .post, parameters: RequestResponseDictionary, formData: [PAFormData]? = nil, progressHint: PAProgressHint?, responseModelClass: AnyClass?, finished: @escaping (Any?, PAResponseModel?, Error?) -> Void) -> URLSessionTask? {
        
        // 移除之前的HUD, 防止多发请求时重叠
        if let previousHud = progressHint?.hudSuperView?.viewWithTag(PAProgressHint.loadingHudTag) as? MBProgressHUD {
            previousHud.hide(false)
        }
        var hud: MBProgressHUD? = nil
        if let lodingHint = progressHint?.loading, let hudSuperView = progressHint?.hudSuperView {
            hud = PAMBManager.show(indicatorMessage: lodingHint, inView: hudSuperView)
            hud?.tag = PAProgressHint.loadingHudTag
        }
        
        // 拼接默认参数
        let finalParams = parameters + PAAppInterface.paBaseSecretParams()
        
        // 成功回调
        let success: (URLSessionDataTask, Any?) -> Void = { (task, response) in
            var error: PAResponseError?                  = nil
            var resultModel: Any?                        = nil
            var returningResponseModel: PAResponseModel? = nil
            if let response = response as? RequestResponseDictionary, let responseModel = PAResponseModel.yy_model(with: response) {
                resultModel            = responseModel
                returningResponseModel = responseModel
                if let status = responseModel.status, status != "SUCCESS" {
                    // 处理全局错误
                    // 处理登录过期
                    if status == "ERROR", let errorCode = responseModel.errorCode, errorCode == "E27" || errorCode == "E26" {
                        (UIApplication.shared.delegate as! AppDelegate).logout()
                        PAMBManager.sharedInstance.showBriefAlert(alert: responseModel.errorMsg)
                        return
                    }
                    
                    var failureHint: String? = nil
                    // 如果progressHint中的failure不为nil, 则用hud提示错误, 否则不提示;
                    // 具体的hud提示信息优先级为：如果progressHint中的failure长度不为零, 则使用之；
                    // 否则若服务器返回的错误信息长度不为零, 则使用之；
                    // 否则使用PAProgressHint中的serverFailureMessage字段。
                    // 下同。
                    if let tempFailureHint = progressHint?.failure {
                        hud?.hide(false)
                        if tempFailureHint.characters.count > 0 {
                            failureHint = tempFailureHint
                        } // 如果服务器有返回错误信息, 则使用之, 否则使用上层调用者传递的参数
                        else if let errorMsg = responseModel.errorMsg, errorMsg.characters.count > 0 {
                            failureHint = errorMsg
                        } else {
                            failureHint = progressHint?.serverFailureHint
                        }
                        if let hudSuperView = progressHint?.hudSuperView {
                            PAMBManager.sharedInstance.showBriefMessage(message: failureHint, view: hudSuperView)
                        }
                    } else {
                        hud?.hide(true)
                    }
                    error = PAResponseError.responseModelValidationFailed
                }
                // 尝试解析JSON为'responseModelClass'类型的模型
                else if let responseModelClass = responseModelClass {
                    // 首先判断JSON是数组还是字典, 或均非
                    if let result = responseModel.result as? RequestResponseDictionary {
                        // 考虑分页请求
                        if let JSONArray = result["list"] as? [RequestResponseDictionary] {
                            resultModel = NSArray.yy_modelArray(with: responseModelClass, json: JSONArray)
                        } else {
                            resultModel = PABaseRequest.yy_model(of: responseModelClass, json: result)
                        }
                    } else if responseModel.result is [RequestResponseDictionary] {
                        resultModel = NSArray.yy_modelArray(with: responseModelClass, json: responseModel.result)
                    } else {
                        let detailError = NSError(domain: "PABaseRequest", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid `result` type: \(responseModelClass)."])
                        error = PAResponseError.responseModelSerializationFailed(reason: PAResponseError.ResponseModelSerializationFailedReason.transformResultToModelFailed(error: detailError))
                    }
                }
            }
            
            // 到此处如果发现error为空, 但又无返回值, 则把error默认置为JSON解析错误
            if resultModel == nil && error == nil {
                error = PAResponseError.responseModelSerializationFailed(reason: PAResponseError.ResponseModelSerializationFailedReason.transformResultToModelFailed(error: nil))
            }
            
            // 显示成功提示
            if error == nil && resultModel != nil, let tempSuccessHint = progressHint?.success {
                hud?.hide(false)
                var successHint: String! = nil
                if tempSuccessHint.characters.count > 0 {
                    successHint = tempSuccessHint
                } else {
                    successHint = progressHint?.defaultSuccessHint
                }
                if let hudSuperView = progressHint?.hudSuperView {
                    PAMBManager.sharedInstance.showSuccess(message: successHint, view: hudSuperView)
                }
            }
            // 如果到此处hud还是显示状态, 则以动画方式隐藏它
            hud?.hide(true)
            
            finished(resultModel, returningResponseModel, error)
        }
        
        // 失败回调
        let failure: (URLSessionDataTask?, Error) -> Void = { (task, error) in
            var failureHint: String? = nil
            // 如果progressHint中的failure不为nil, 则尝试用hud提示错误, 否则忽略
            if let tempFailureHint = progressHint?.failure {
                hud?.hide(false)
                if tempFailureHint.characters.count > 0 {
                    failureHint = tempFailureHint
                } else if error.localizedDescription.contains("cancelled") || error.localizedDescription.contains("已取消") {
                    failureHint = progressHint?.cancelHint
                } else {
                    failureHint = progressHint?.networkErrorHint
                }
                if let hudSuperView = progressHint?.hudSuperView {
                    PAMBManager.sharedInstance.showBriefMessage(message: failureHint, view: hudSuperView)
                }
            } else {
                hud?.hide(true)
            }
            
            finished(nil, nil, error)
        }
        
        var returningTask: URLSessionTask? = nil
        let manager                        = AFHTTPSessionManager()
        let requestSerializer              = AFHTTPRequestSerializer()
        requestSerializer.timeoutInterval  = 30
        manager.requestSerializer          = requestSerializer
        
        if method == .get {
            manager.get(url, parameters: finalParams, progress: nil, success: success, failure: failure)
        } else {
            if let formData = formData, formData.count > 0 {
                returningTask = manager.post(url, parameters: finalParams, constructingBodyWith: { (finalFormData) in
                    formData.forEach { finalFormData.appendPart(withFileData: $0.data, name: $0.parameterName, fileName: $0.fileName, mimeType: $0.mimeType) }
                }, progress: nil, success: success, failure: failure)
            } else {
                returningTask = manager.post(url, parameters: finalParams, progress: nil, success: success, failure: failure)
            }
        }
        return returningTask
    }
    
    class func post(_ parameters: RequestResponseDictionary, formData: [PAFormData]? = nil, progressHint: PAProgressHint?, responseModelClass: AnyClass?, finished: @escaping (Any?, PAResponseModel?, Error?) -> Void) -> URLSessionTask? {
        return request(PAAppInterface.paWJBaseUrl, method: .post, parameters: parameters, formData: formData, progressHint: progressHint, responseModelClass: responseModelClass, finished: finished)
    }
}

enum PAHTTPMethod {
    case get
    case post
}

/** 封装上传的文件数据 */
class PAFormData : NSObject {
    /** 文件数据 */
    var data: Data
    /** 参数名称 */
    var parameterName: String
    /** 文件名 */
    var fileName: String
    /** 文件类型 */
    var mimeType: String
    
    init(data: Data, parameterName: String, fileName: String, mimeType: String) {
        self.data          = data
        self.parameterName = parameterName
        self.fileName      = fileName
        self.mimeType      = mimeType
    }
}

/** 封装HUD的数据源和样式 */
class PAProgressHint : NSObject {
    var loading: String?
    var success: String?
    var failure: String?
    
    var defaultSuccessHint: String? = "请求成功"

    var cancelHint: String?         = "请求已取消"
    var networkErrorHint: String?   = "请求失败, 请稍后重试"
    var serverFailureHint: String?  = "数据拉取失败, 请稍后重试"
    
    weak var hudSuperView: UIView?  = nil
    
    static let `default` = PAProgressHint(loading: "加载中...", success: nil, failure: "")
    static let loadingHudTag = -100001
    
    static func defaultHint(withHudSuperView view: UIView) -> PAProgressHint {
        let progressHint = PAProgressHint.default
        progressHint.hudSuperView = view
        return progressHint
    }
    
    init(loading: String?, success: String?, failure: String?) {
        self.loading = loading
        self.success = success
        self.failure = failure
    }
}

