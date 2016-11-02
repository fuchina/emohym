//
//  GZQQShareSDK.h
//  GJErCarBusiness
//
//  Created by 刘猛 on 15/12/8.
//  Copyright © 2015年 刘猛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GZQQShareQType,   //微信聊天界面
    GZQQShareQZoneType    //微信朋友圈
} GZQQShareType;

@interface GZQQShareSDK : NSObject

- (id)initWithShareID:(NSString *)shareID;

/*!
 @method
 @abstract 是否是分享回调
 @discussion
 @return
 */
- (BOOL)isQQOpenURL:(NSURL *)url;

/*!
 @method
 @abstract 微信回调
 @discussion
 @return
 */
- (BOOL)handleOpenUrl:(NSURL*)url;

/*!
 @method
 @abstract 是否支持分享
 @discussion
 @return
 */
+ (BOOL)canSupportShare;

/*!
 @method
 @abstract 分享纯文本消息
 @discussion
 @param textMessage 文本信息
 @param shareResult 分享结果
 @return
 */
- (void)shareTextMessage:(NSString *)textMessage
               shareType:(GZQQShareType)shareType
             shareResult:(void(^)(BOOL result))shareResult;

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
                         shareType:(GZQQShareType)shareType
                       shareResult:(void(^)(BOOL result))shareResult;

@end
