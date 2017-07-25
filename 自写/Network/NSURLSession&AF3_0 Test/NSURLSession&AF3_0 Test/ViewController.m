//
//  ViewController.m
//  NSURLSession&AF3_0 Test
//
//  Created by luozhijun on 15/10/23.
//  Copyright © 2015年 luozhijun. All rights reserved.
//

#import "ViewController.h"
#import "ZJHTTPHelper.h"

@interface ViewController () <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate, NSURLSessionDataDelegate>
{
    NSTimer *_timer;
    NSLock *_lock;
    NSURLSession *_session;
}
@end

@implementation ViewController

static double percent = 0;
static NSString * AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kAFCharactersToBeEscaped = @":/?&=;+!@#$()~";
    static NSString * const kAFCharactersToLeaveUnescaped = @"[].";
    
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescaped, (__bridge CFStringRef)kAFCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", NSHomeDirectory());
    
    _lock = [[NSLock alloc] init];
    _lock.name = @"percentLock";
    
    NSString *url = @"http://gc.ditu.aliyun.com/geocoding?a=苏州市";
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    url = AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(url, NSUTF8StringEncoding);
    NSLog(@"%@", url);
    
    ZJProgressStatusHint *hudHint = [ZJProgressStatusHint objectWithloadingHint:@"哈哈哈" successHint:@"dfadfaf" failureHint:@"dddd"];
    [ZJHTTPHelper postWithURL:url params:nil hudHint:hudHint hudAccessBlock:^(MBProgressHUD *hud) {
        hud.opacity = 0.3;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
//    AFURLSessionManager *mgr = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"abcde"]];
//    NSURLSessionTask *task = [mgr downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dlsw.baidu.com/sw-search-sp/soft/2a/25677/QQ_V4.0.3_setup.1435732931.dmg"]] progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        NSString *destfilePath = [@"/Users/luozhijun/Desktop" stringByAppendingPathComponent:response.suggestedFilename];
//        NSURL *destUrl = [NSURL URLWithString:[@"file://" stringByAppendingString:destfilePath]];
//        NSLog(@"%@", destfilePath);
//        return destUrl;
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        
//    }];
//    [task resume];
}

#pragma mark - testAF_3.0

#pragma mark - testNSURLSession
- (void)testNSURLSession
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"abcde"] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:@"http://dlsw.baidu.com/sw-search-sp/soft/a8/27390/android_studio_bundle_V1.2.0.0_windows.1433235883.exe"];//@"http://dlsw.baidu.com/sw-search-sp/soft/b4/25734/itunes12.3.1442478948.dmg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url]; //]@"http://dlsw.baidu.com/sw-search-sp/soft/2a/25677/QQ_V4.0.3_setup.1435732931.dmg"
    NSURLSessionTask *task = [session downloadTaskWithRequest:request];
    [task resume];
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 1.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"\n----------------------%f", percent);
        if (fabs(percent - 1) < 1e-6) {
            dispatch_suspend(timer);
        }
    });
    dispatch_resume(timer);
    
    //    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(printPercent) userInfo:nil repeats:YES];
}

- (void)printPercent
{
    NSLog(@"\n----------------------%f, %p", percent, _session);
    if (fabs(percent - 1) < 1e-6) {
        [_timer invalidate];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    _session = session;
    percent = (double)totalBytesWritten / totalBytesExpectedToWrite;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"\n\n\n----------: %@", location);
    NSError *fileMoveError = nil;
    NSString *destfilePath = [@"/Users/luozhijun/Desktop" stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    NSURL *destUrl = [NSURL URLWithString:[@"file://" stringByAppendingString:destfilePath]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:destfilePath]) {
        NSLog(@"+++++++++++++fileExistsAtPath");
        [[NSFileManager defaultManager] removeItemAtURL:destUrl error:nil];
    }
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:destUrl error:&fileMoveError];
    [session invalidateAndCancel];
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    NSLog(@"\n\n\n+++++++++didBecomeInvalidWithError%@", error);
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSLog(@"\n\n\n+++++++didReceiveChallenge");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"\n\n\n+++++++didCompleteWithError: %@", error);
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    NSLog(@"\n\n\n+++++++URLSessionDidFinishEventsForBackgroundURLSession");
}

@end
