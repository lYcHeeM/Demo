//
//  ZJErrorCodeAndMessage.h
//  jingGang
//
//  Created by luozhijun on 15/8/6.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - - Network

#pragma mark - *****公共错误*****
/** 生成以逆向DNS命名的ErrorDomain */
extern inline NSString *ZJ_GenerateErrorDomainWithErrorCode(NSInteger errorCode);
/** 服务器出错情况下的提示信息 */
extern NSString *const ZJNetworkServerErrorHint;

#pragma mark 系统错误 1
/** 内部系统错误 - 根错误码(errorCode) */
extern NSString *const ZJNetworkInternalSystemErrorCode;
/** 内部系统错误 - 详细错误码(subCode) */
extern NSString *const ZJNetworkInternalSystemErrorDetailCode;
/** 内部系统错误提示信息 */
extern NSString *const ZJNetworkInternalSystemErrorMag;

#pragma mark 权限错误 2
/** 未授权错误(需要用户重新登录以获取token) - 根错误码(errorCode) */
extern NSString *const ZJNetworkUnauthorizedErrorCode;
/** 未授权错误 - 详细错误码(subCode) */
extern NSString *const ZJNetworkUnauthorizedDetailErrorCode;
/** 未授权错误提示信息 */
extern NSString *const ZJNetworkUnauthorizedErrorMag;
/** token失效的错误码 - 详细错误码(subCode) */
extern NSString *const ZJNetworkTokenExpiredErrorCode;
/** token失效的错误提示信息 */
extern NSString *const ZJNetworkTokenExpiredErrorMsg;

#pragma mark 参数错误 3
/** 参数错误 - 根错误码(errorCode) */
extern NSString *const ZJNetworkArgumentErrorCode;
/** 日期格式错误码 - 详细错误码(subCode) */
extern NSString *const ZJNetworkDateFormatErrorCode;
/** 日期格式错误提示信息 */
extern NSString *const ZJNetworkDateFormatErrorMsg;

#pragma mark 数据错误 4
/** 当前接口数据错误 - 根错误码(errorCode) */
extern NSString *const ZJNetworkServerDataErrorCode;
/** 当前接口无数据的错误 - 详细错误码(subCode) */
extern NSString *const ZJNetworkServerNoDataDetailErrorCode;
/** 当前接口没有数据的错误提示信息 */
extern NSString *const ZJNetworkServerNodataErrorMsg;





