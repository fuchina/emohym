//
//  GZWeiBoShareSDK.m
//  GJErCarBusiness
//
//  Created by 刘猛 on 15/12/7.
//  Copyright © 2015年 刘猛. All rights reserved.
//

#import "GZWeiBoShareSDK.h"
#import "WeiboSDK.h"

@interface GZWeiBoShareSDK ()

@property (nonatomic, copy) void (^shareResult) (BOOL result);
@property (nonatomic, strong) NSString *weiBoAppKey;

@end

@implementation GZWeiBoShareSDK

- (id)initWithShareID:(NSString *)shareID
{
    self = [super init];
    if (self) {
        self.weiBoAppKey = shareID;
        [self initWeiBoShareKit];
    }
    return self;
}

- (BOOL)isWeiBoOpenURL:(NSURL *)url
{
    NSString *wbAppKey = [NSString stringWithFormat:@"wb%@", _weiBoAppKey];
    if ([url.scheme isEqualToString:wbAppKey]) {
        return YES;
    }
    return NO;
}

+ (BOOL)canSupportShare
{
    if ([WeiboSDK isCanShareInWeiboAPP]) {
        return YES;
    }
    return NO;
}

- (void)initWeiBoShareKit
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [WeiboSDK registerApp:_weiBoAppKey];
    });
}

- (BOOL)handleOpenUrl:(NSURL*)url
{
    NSString *wbAppKey = [NSString stringWithFormat:@"wb%@", _weiBoAppKey];
    if ([url.scheme isEqualToString:wbAppKey]) {
        return [WeiboSDK handleOpenURL:url delegate:(id<WeiboSDKDelegate>)self];
    }
    return NO;
}

- (void)shareTextMessage:(NSString *)textMessage shareResult:(void(^)(BOOL result))shareResult
{
    self.shareResult = shareResult;
    WBMessageObject *message = [WBMessageObject message];
    message.text = textMessage;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    
    if ([WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanShareInWeiboAPP]) {
        BOOL sendResult = [WeiboSDK sendRequest:request];
        if (!sendResult) {
            NSLog(@"打开微博失败!!");
            if (_shareResult) {
                _shareResult(0);
                self.shareResult = nil;
            }
        }
    }
}

- (void)shareMediaMessageWithTitle:(NSString *)title
                       description:(NSString *)description
                        thumbImage:(UIImage *)thumbImage
                          shareURL:(NSString *)shareURL
                       shareResult:(void(^)(BOOL result))shareResult
{
    self.shareResult = shareResult;
    WBMessageObject *message = [WBMessageObject message];
    WBWebpageObject *webpage = [WBWebpageObject object];
    
    
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    
    webpage.objectID = uuidString;
    webpage.title = title;
    webpage.description = description;
    
    NSData *data;
    data = UIImageJPEGRepresentation(thumbImage, 0.5);
    
    webpage.thumbnailData = data;
    webpage.webpageUrl = shareURL;
    message.mediaObject = webpage;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    
    if ([WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanShareInWeiboAPP]) {
        BOOL sendResult = [WeiboSDK sendRequest:request];
        if (!sendResult) {
            NSLog(@"打开微博失败!!");
            if (_shareResult) {
                _shareResult(0);
                self.shareResult = nil;
            }
        }
    }
}

#pragma mark -微博回调
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        if (_shareResult) {
            _shareResult(1);
            self.shareResult = nil;
        }
    } else {
        if (_shareResult) {
            _shareResult(0);
            self.shareResult = nil;
        }
    }
}

@end
