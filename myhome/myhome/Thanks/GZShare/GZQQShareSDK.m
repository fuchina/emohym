//
//  GZQQShareSDK.m
//  GJErCarBusiness
//
//  Created by 刘猛 on 15/12/8.
//  Copyright © 2015年 刘猛. All rights reserved.
//

#import "GZQQShareSDK.h"
#import "QQApiInterface.h"
#import "TencentOAuth.h"
#import "QQApiInterfaceObject.h"

@interface GZQQShareSDK ()

@property (nonatomic, copy) void (^shareResult) (BOOL result);
@property (nonatomic, strong) NSString *qqAppID;

@end

@implementation GZQQShareSDK

- (id)initWithShareID:(NSString *)shareID
{
    self = [super init];
    if (self) {
        self.qqAppID = shareID;
        TencentOAuth *oauth = [[TencentOAuth alloc] initWithAppId:_qqAppID
                                                      andDelegate:(id<TencentSessionDelegate>)self];
        if (!oauth) {
            //注册失败
        }
    }
    return self;
}

- (BOOL)isQQOpenURL:(NSURL *)url
{
    NSString *qqAppKey = [NSString stringWithFormat:@"tencent%@", _qqAppID];
    if ([url.scheme isEqualToString:qqAppKey]) {
        return YES;
    }
    return NO;
}

- (BOOL)handleOpenUrl:(NSURL*)url
{
    NSString *qqAppKey = [NSString stringWithFormat:@"tencent%@", _qqAppID];
    if ([url.scheme isEqualToString:qqAppKey]) {
        return [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)self];
    }
    return NO;
}

+ (BOOL)canSupportShare
{
    if ([QQApiInterface isQQSupportApi]) {
        return YES;
    }
    return NO;
}

- (void)shareTextMessage:(NSString *)textMessage
               shareType:(GZQQShareType)shareType
             shareResult:(void(^)(BOOL result))shareResult
{
    
}

- (void)shareMediaMessageWithTitle:(NSString *)title
                       description:(NSString *)description
                        thumbImage:(UIImage *)thumbImage
                          shareURL:(NSString *)shareURL
                         shareType:(GZQQShareType)shareType
                       shareResult:(void(^)(BOOL result))shareResult
{
    self.shareResult = shareResult;
    
    NSData *data;
    data = UIImageJPEGRepresentation(thumbImage, 0.5);
    QQApiURLObject *newsObj = [QQApiURLObject objectWithURL:[NSURL URLWithString:shareURL] title:title description:description previewImageData:data targetContentType:QQApiURLTargetTypeNews];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    QQApiSendResultCode sent = EQQAPISENDSUCESS;
    if (shareType == GZQQShareQType) {
        //将内容分享到qq
        sent = [QQApiInterface sendReq:req];
    }
    if (shareType == GZQQShareQZoneType) {
        //将内容分享到qzone
        sent = [QQApiInterface SendReqToQZone:req];
    }
    
    if (sent != EQQAPISENDSUCESS) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享失败" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alertView show];    }
}

#pragma mark -QQ回调
- (void)onResp:(QQBaseResp *)resp
{
    
}

@end
