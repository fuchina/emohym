//
//  GZWeiBoShareSDK.h
//  GJErCarBusiness
//
//  Created by 刘猛 on 15/12/7.
//  Copyright © 2015年 刘猛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GZWeiBoShareSDK : NSObject

- (id)initWithShareID:(NSString *)shareID;

/*!
 @method
 @abstract 是否是分享回调
 @discussion
 @return
 */
- (BOOL)isWeiBoOpenURL:(NSURL *)url;

/*!
 @method
 @abstract 微博回调
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
- (void)shareTextMessage:(NSString *)textMessage shareResult:(void(^)(BOOL result))shareResult;

/*!
 @method
 @abstract 微信分享URL
 @discussion
 @param title           标题
 @param description     描述
 @param thumbImage      小图
 @param shareURL        分享URL
 @param shareResult     分享结果
 @return
 */
- (void)shareMediaMessageWithTitle:(NSString *)title
                       description:(NSString *)description
                        thumbImage:(UIImage *)thumbImage
                          shareURL:(NSString *)shareURL
                       shareResult:(void(^)(BOOL result))shareResult;

@end
