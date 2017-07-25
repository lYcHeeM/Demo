//
//  ZJHTTPHelper.h
//  NSURLSession&ZJ3_0 Test
//
//  Created by luozhijun on 15/10/26.
//  Copyright © 2015年 luozhijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFURLResponseSerialization.h"
#import "AbstractResponse.h"
#import "ZJErrorCodeAndMessage.h"
#import "ZJHUDHelper.h"
#import "ZJProgressStatusHint.h"

@class ZJFormData;

typedef void (^ZJHttpRequestSuccessBlock)(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject);
typedef void (^ZJHttpRequestFailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

typedef NS_ENUM(NSInteger, ZJHttpMethod) {
    ZJHttpMethodGET = 1,
    ZJHttpMethodPOST
};

@interface ZJHTTPHelper : NSObject

#pragma mark - 带有hud提示的http请求封装
+ (void)requestMethod:(ZJHttpMethod)method URL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray<__kindof ZJFormData *> *)formDataArray usingDefaultEncrypt:(BOOL)usingDefaultEncrypt encryptBlock:(void (^)(NSDictionary *))encryptBlock hudHint:(ZJProgressStatusHint *)hudHint hudAccessBlock:(void (^)(id hud))hudAccessBlock success:(ZJHttpRequestSuccessBlock)success failure:(ZJHttpRequestFailureBlock)failure;

#pragma mark - get
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params hudHint:(ZJProgressStatusHint *)hudHint hudAccessBlock:(void (^)(id hud))hudAccessBlock success:(ZJHttpRequestSuccessBlock)success failure:(ZJHttpRequestFailureBlock)failure;

#pragma mark - post
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params hudHint:(ZJProgressStatusHint *)hudHint hudAccessBlock:(void (^)(id hud))hudAccessBlock success:(ZJHttpRequestSuccessBlock)success failure:(ZJHttpRequestFailureBlock)failure;

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray hudHint:(ZJProgressStatusHint *)hudHint hudAccessBlock:(void (^)(id hud))hudAccessBlock success:(ZJHttpRequestSuccessBlock)success failure:(ZJHttpRequestFailureBlock)failure;

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray usingDefaultEncrypt:(BOOL)usingDefaultEncrypt encryptBlock:(void (^)(NSDictionary *))encryptBlock hudHint:(ZJProgressStatusHint *)hudHint hudAccessBlock:(void (^)(id hud))hudAccessBlock success:(ZJHttpRequestSuccessBlock)success failure:(ZJHttpRequestFailureBlock)failure;

@end

#pragma mark -
/** 用来封装上传的文件数据 */
@interface ZJFormData : NSObject
/** 文件数据 */
@property (nonatomic, strong, nonnull) NSData *data;
/** 参数名称 */
@property (nonatomic, copy, nullable) NSString *paramName;
/** 文件名 */
@property (nonatomic, copy, nullable) NSString *filename;
/** 文件类型 */
@property (nonatomic, copy, nonnull) NSString *mimeType;
@end

