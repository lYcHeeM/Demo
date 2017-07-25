//
//  ZJErrorCodeAndMessage.m
//  jingGang
//
//  Created by luozhijun on 15/8/6.
//  Copyright (c) 2015年 luozhijun. All rights reserved.
//

#import "ZJErrorCodeAndMessage.h"

inline NSString *ZJ_GenerateErrorDomainWithErrorCode(NSInteger errorCode)
{
    NSString *domain = @"com.superFinance.network.http.";;
    if (errorCode == ZJNetworkInternalSystemErrorCode.integerValue) {
        domain = [domain stringByAppendingString:@"internalSystemError"];
    } else if (errorCode == ZJNetworkUnauthorizedErrorCode.integerValue) {
        domain = [domain stringByAppendingString:@"unauthorizedError"] ;
    } else if (errorCode == ZJNetworkArgumentErrorCode.integerValue) {
        domain = [domain stringByAppendingString:@"argumentError"];
    } else if (errorCode == ZJNetworkServerDataErrorCode.integerValue) {
        domain = [domain stringByAppendingString:@"serverDataError"];
    } else {
        domain = [domain stringByAppendingString:@"unknowTypeError"];
    }
    return domain;
}

NSString *const ZJNetworkServerErrorHint               = @"连接服务器失败, 请稍后再试";

NSString *const ZJNetworkInternalSystemErrorCode       = @"1";
NSString *const ZJNetworkInternalSystemErrorDetailCode = @"operation_failed";
NSString *const ZJNetworkInternalSystemErrorMag        = @"系统错误，操作失败";

NSString *const ZJNetworkUnauthorizedErrorCode         = @"2";
NSString *const ZJNetworkUnauthorizedDetailErrorCode   = @"401";
NSString *const ZJNetworkTokenExpiredErrorCode         = @"410";
NSString *const ZJNetworkTokenExpiredErrorMsg          = @"Token已失效, 请重新登录";
NSString *const ZJNetworkUnauthorizedErrorMag          = @"未授权的请求, 请重新登录";

NSString *const ZJNetworkArgumentErrorCode             = @"3";
NSString *const ZJNetworkDateFormatErrorCode           = @"error_date_format";
NSString *const ZJNetworkDateFormatErrorMsg            = @"日期格式错误";

NSString *const ZJNetworkServerDataErrorCode           = @"4";
NSString *const ZJNetworkServerNoDataDetailErrorCode   = @"no_data";
NSString *const ZJNetworkServerNodataErrorMsg          = @"没有找到对应的数据";

