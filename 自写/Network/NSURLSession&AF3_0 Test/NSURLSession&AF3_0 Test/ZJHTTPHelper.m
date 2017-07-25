//
//  ZJHTTPHelper.m
//  NSURLSession&ZJ3_0 Test
//
//  Created by luozhijun on 15/10/26.
//  Copyright © 2015年 luozhijun. All rights reserved.
//

#import "ZJHTTPHelper.h"

@implementation ZJHTTPHelper

#pragma mark - 带有hud提示的请求封装
+ (void)requestMethod:(ZJHttpMethod)method URL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray<__kindof ZJFormData *> *)formDataArray usingDefaultEncrypt:(BOOL)usingDefaultEncrypt encryptBlock:(void (^)(NSDictionary *))encryptBlock hudHint:(ZJProgressStatusHint *)hudHint hudAccessBlock:(void (^)(id hud))hudAccessBlock success:(ZJHttpRequestSuccessBlock)success failure:(ZJHttpRequestFailureBlock)failure
{
    // HUD
    __block id hud = nil;
    if (hudHint.loadingHint) {
        hud = [ZJHUDHelper showMessage:hudHint.loadingHint];
    }
    
    // 对新创建的hud是否修改
    void (^editHudBlock)(id hud) = ^(id hud) {
        if (hudAccessBlock) {
            hudAccessBlock(hud);
        }
    };
    editHudBlock(hud);
    
    // 将要使用的参数字典
    NSDictionary *usingParams = params;
    
    // 加密
    if (usingDefaultEncrypt) {
        
    } else if (encryptBlock) {
        encryptBlock(usingParams);
    }
    
    // __unused NSString *jsonString = [usingParams jsonStringWithOptions:NSJSONWritingPrettyPrinted error:nil];
    // DebugLog(@"%@", jsonString);
    
    // 成功回调
    ZJHttpRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {

        AbstractResponse *response = nil;
        
        if (!response.errorCode.length && success) { // 成功
            
            success(task, responseObject);
            
            if (hudHint.successHint) {
                [ZJHUDHelper hideHUD:hud animated:NO];
                hud = [ZJHUDHelper showSuccess:hudHint.successHint];
                editHudBlock(hud);
            } else {
               [ZJHUDHelper hideHUDAfterDefaultDelay:hud];
            }
        }
        else if (failure) { // 失败
            NSString *errorHint = hudHint.failureHint.length ? hudHint.failureHint : response.subMsg;
            
            // 自定义错误
            NSError *error = [NSError errorWithDomain:ZJ_GenerateErrorDomainWithErrorCode(response.errorCode.integerValue) code:response.errorCode.integerValue userInfo:@{NSLocalizedDescriptionKey: response.subMsg}];
            
            failure(task, error);
            
            if (hudHint.failureHint) {
                [ZJHUDHelper hideHUD:hud animated:NO];
                hud = [ZJHUDHelper showError:errorHint];
                editHudBlock(hud);
            } else {
                [ZJHUDHelper hideHUDAfterDefaultDelay:hud];
            }
        }
    };
    
    // 失败回调
    ZJHttpRequestFailureBlock failureBlock = ^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (failure) {
            failure (task, error);
            
            if (hudHint.failureHint) {
                [ZJHUDHelper hideHUD:hud animated:NO];
                NSString *errorHint = hudHint.failureHint.length ? hudHint.failureHint : error.localizedDescription;
                if (error.code == -1003 /* && [error.description isEqualToString:@"A server with the specified hostname could not be found."] */) { // "未找到服务器" 错误
                    errorHint = ZJNetworkServerErrorHint;
                }
                hud = [ZJHUDHelper showError:errorHint];
                editHudBlock(hud);
            } else {
               [ZJHUDHelper hideHUDAfterDefaultDelay:hud];
            }
        }
    };
    
    // 使用ANF发送请求
    AFHTTPSessionManager *sessionMgr = [AFHTTPSessionManager manager];
    if (method == ZJHttpMethodGET) {
        [sessionMgr GET:url parameters:usingParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            successBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(task, error);
        }];
    }
    else if (method == ZJHttpMethodPOST) {
        if (formDataArray.count) {
            NSAssert([[formDataArray firstObject] isKindOfClass:[ZJFormData class]], @"Objects in `formDataArray` must be `ZJFormData` type, %s", __PRETTY_FUNCTION__);
            
            [sessionMgr POST:url parameters:usingParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                // 拼接文件数据
                for (ZJFormData *aFormData in formDataArray) {
                    [formData appendPartWithFileData:aFormData.data name:aFormData.paramName fileName:aFormData.filename mimeType:aFormData.mimeType];
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                successBlock(task, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failureBlock(task, error);
            }];
        }
        else {
            [sessionMgr POST:url parameters:usingParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                successBlock(task, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failureBlock(task, error);
            }];
        }
    }
}

+ (void)requestMethod:(ZJHttpMethod)method URL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray usingDefaultEncrypt:(BOOL)usingDefaultEncrypt encryptBlock:(void (^)(NSDictionary *))encryptBlock loadingHint:(NSString *)loadingHint successHint:(NSString *)successHint failureHint:(NSString *)failureHint hudAccessBlock:(void (^)(id hud))hudAccessBlock success:(ZJHttpRequestSuccessBlock)success failure:(ZJHttpRequestFailureBlock)failure
{
    ZJProgressStatusHint *hudHint = [ZJProgressStatusHint objectWithloadingHint:loadingHint successHint:successHint failureHint:failureHint];
    [self requestMethod:method URL:url params:params formDataArray:formDataArray usingDefaultEncrypt:usingDefaultEncrypt encryptBlock:encryptBlock hudHint:hudHint hudAccessBlock:hudAccessBlock success:success failure:failure];
}

#pragma mark - get

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params hudHint:(ZJProgressStatusHint *)hudHint hudAccessBlock:(void (^)(id hud))hudAccessBlock success:(ZJHttpRequestSuccessBlock)success failure:(ZJHttpRequestFailureBlock)failure
{
    [self requestMethod:ZJHttpMethodGET URL:url params:params formDataArray:nil usingDefaultEncrypt:NO encryptBlock:nil hudHint:hudHint hudAccessBlock:hudAccessBlock success:success failure:failure];
}

#pragma mark - post
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params hudHint:(ZJProgressStatusHint *)hudHint hudAccessBlock:(void (^)(id hud))hudAccessBlock success:(ZJHttpRequestSuccessBlock)success failure:(ZJHttpRequestFailureBlock)failure
{
    [self requestMethod:ZJHttpMethodPOST URL:url params:params formDataArray:nil usingDefaultEncrypt:NO encryptBlock:nil hudHint:hudHint hudAccessBlock:hudAccessBlock success:success failure:failure];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray hudHint:(ZJProgressStatusHint *)hudHint hudAccessBlock:(void (^)(id hud))hudAccessBlock success:(ZJHttpRequestSuccessBlock)success failure:(ZJHttpRequestFailureBlock)failure
{
    [self requestMethod:ZJHttpMethodPOST URL:url params:params formDataArray:formDataArray usingDefaultEncrypt:NO encryptBlock:nil hudHint:hudHint hudAccessBlock:hudAccessBlock success:success failure:failure];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray usingDefaultEncrypt:(BOOL)usingDefaultEncrypt encryptBlock:(void (^)(NSDictionary *))encryptBlock hudHint:(ZJProgressStatusHint *)hudHint hudAccessBlock:(void (^)(id hud))hudAccessBlock success:(ZJHttpRequestSuccessBlock)success failure:(ZJHttpRequestFailureBlock)failure
{
    [self requestMethod:ZJHttpMethodPOST URL:url params:params formDataArray:formDataArray usingDefaultEncrypt:usingDefaultEncrypt encryptBlock:encryptBlock hudHint:hudHint hudAccessBlock:hudAccessBlock success:success failure:failure];
}
@end


@implementation ZJFormData

@end
