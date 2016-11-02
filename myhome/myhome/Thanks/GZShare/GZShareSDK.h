//
//  GZShareSDK.h
//  GZShareSDK
//
//  Created by 刘猛 on 15/12/28.
//  Copyright © 2015年 刘猛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GZShareTypeWXFriend,      //微信聊天界面
    GZShareTypeWXTimeline,    //微信朋友圈
    GZShareTypeWXFavorite,    //微信收藏
    GZShareTypeWBShare,       //微博分享
    GZShareTypeQQShare,       //QQ分享
    GZShareTypeQQZoneShare    //QQ空间分享
} GZShareType;

@interface GZShareSDK : NSObject

- (void)setShareSDKKeysWithQQID:(NSString *)qqID wechatID:(NSString *)wechatID weiBoID:(NSString *)weiBoID;

/*!
 @method
 @abstract 分享管理类
 @discussion
 @return
 */
+ (instancetype)shareInstance;

/*!
 @method
 @abstract 是否是分享回调
 @discussion
 @return
 */
+ (BOOL)isShareOpenURL:(NSURL *)url;

/*!
 @method
 @abstract 分享回调
 @discussion
 @return
 */
- (BOOL)handleOpenUrl:(NSURL*)url;

/*!
 @method
 @abstract 是否支持分享
 @discussion
 @param shareType 分享类型
 @return
 */
+ (BOOL)canSupportShare:(GZShareType)shareType;

/*!
 @method
 @abstract 分享纯文本消息
 @discussion
 @param textMessage 文本信息
 @param shareType   分享类型
 @param shareResult 分享结果
 @return
 */
- (void)shareTextMessage:(NSString *)textMessage shareType:(GZShareType)shareType shareResult:(void(^)(BOOL result))shareResult;

/*!
 @method
 @abstract 微信分享URL
 @discussion
 @param title           标题
 @param description     描述
 @param thumbImage      小图
 @param shareURL        分享URL
 @param shareType       分享类型
 @param shareResult     分享结果
 @return
 */
- (void)shareMediaMessageWithTitle:(NSString *)title
                       description:(NSString *)description
                        thumbImage:(UIImage *)thumbImage
                          shareURL:(NSString *)shareURL
                         shareType:(GZShareType)shareType
                       shareResult:(void(^)(BOOL result))shareResult;

@end
