//
//  GZShareSDK.m
//  GZShareSDK
//
//  Created by 刘猛 on 15/12/28.
//  Copyright © 2015年 刘猛. All rights reserved.
//

#import "GZShareSDK.h"
#import "GZWeChatShareSDK.h"
#import "GZWeiBoShareSDK.h"
#import "GZQQShareSDK.h"

@interface GZShareSDK ()

@property (nonatomic, strong) GZWeiBoShareSDK *weiBoShareKit;
@property (nonatomic, strong) GZWeChatShareSDK *wechatShareKit;
@property (nonatomic, strong) GZQQShareSDK *qqShareKit;

@property (nonatomic, strong) NSString *qqAppID;
@property (nonatomic, strong) NSString *weiBoAppKey;
@property (nonatomic, strong) NSString *weChatAppID;

@end

@implementation GZShareSDK

- (void)setShareSDKKeysWithQQID:(NSString *)qqID wechatID:(NSString *)wechatID weiBoID:(NSString *)weiBoID
{
    if (qqID) {
        self.qqShareKit = [[GZQQShareSDK alloc] initWithShareID:qqID];
    }
    if (weiBoID) {
        self.weiBoShareKit = [[GZWeiBoShareSDK alloc] initWithShareID:weiBoID];
    }
    if (wechatID) {
        self.wechatShareKit = [[GZWeChatShareSDK alloc] initWithShareID:wechatID];
    }
}

static GZShareSDK *gShareSDKInstance = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gShareSDKInstance = [[GZShareSDK alloc] init];
    });
    return gShareSDKInstance;
}

+ (BOOL)isShareOpenURL:(NSURL *)url
{
    BOOL isOpenURL = NO;
    isOpenURL = [gShareSDKInstance.weiBoShareKit isWeiBoOpenURL:url];
    if (isOpenURL) {
        return YES;
    }
    isOpenURL = [gShareSDKInstance.wechatShareKit isWechatOpenURL:url];
    if (isOpenURL) {
        return YES;
    }
    isOpenURL = [gShareSDKInstance.qqShareKit isQQOpenURL:url];
    if (isOpenURL) {
        return YES;
    }
    return NO;
}

- (BOOL)handleOpenUrl:(NSURL*)url
{
    if ([_weiBoShareKit isWeiBoOpenURL:url]) {
        return [_weiBoShareKit handleOpenUrl:url];
    } else if ([_wechatShareKit isWechatOpenURL:url]) {
        return [_wechatShareKit handleOpenUrl:url];
    } else if ([_qqShareKit isQQOpenURL:url]) {
        return [_qqShareKit handleOpenUrl:url];
    }
    return NO;
}

+ (BOOL)canSupportShare:(GZShareType)shareType
{
    if (shareType == GZShareTypeWXFriend || shareType == GZShareTypeWXTimeline || shareType == GZShareTypeWXFavorite) {
        return [GZWeChatShareSDK canSupportShare];
    }
    if (shareType == GZShareTypeWBShare) {
        return [GZWeiBoShareSDK canSupportShare];
    }
    if (shareType == GZShareTypeQQShare || shareType == GZShareTypeQQZoneShare) {
        return [GZQQShareSDK canSupportShare];
    }
    return NO;
}

- (void)shareTextMessage:(NSString *)textMessage shareType:(GZShareType)shareType shareResult:(void(^)(BOOL result))shareResult
{
    if (shareType == GZShareTypeWXFriend || shareType == GZShareTypeWXTimeline || shareType == GZShareTypeWXFavorite) {
        [_wechatShareKit shareTextMessage:textMessage shareType:(GZWeChatShareType)shareType shareResult:shareResult];
    } else if (shareType == GZShareTypeWBShare) {
        [_weiBoShareKit shareTextMessage:textMessage shareResult:shareResult];
    }
}

- (void)shareMediaMessageWithTitle:(NSString *)title
                       description:(NSString *)description
                        thumbImage:(UIImage *)thumbImage
                          shareURL:(NSString *)shareURL
                         shareType:(GZShareType)shareType
                       shareResult:(void(^)(BOOL result))shareResult
{
    if (shareType == GZShareTypeWXFriend || shareType == GZShareTypeWXTimeline || shareType == GZShareTypeWXFavorite) {
        [_wechatShareKit shareMediaMessageWithTitle:title description:description thumbImage:thumbImage shareURL:shareURL shareType:(GZWeChatShareType)shareType shareResult:shareResult];
    } else if (shareType == GZShareTypeWBShare) {
        [_weiBoShareKit shareMediaMessageWithTitle:title description:description thumbImage:thumbImage shareURL:shareURL shareResult:shareResult];
    } else if (shareType == GZShareTypeQQShare || shareType == GZShareTypeQQZoneShare) {
        GZQQShareType qqShareT = GZQQShareQType;
        if (shareType == GZShareTypeQQZoneShare) {
            qqShareT = GZQQShareQZoneType;
        }
        [_qqShareKit shareMediaMessageWithTitle:title description:description thumbImage:thumbImage shareURL:shareURL shareType:qqShareT shareResult:shareResult];
    }
}

@end