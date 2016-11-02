//
//  GZECShareEntity.h
//  GJErCarApp
//
//  Created by 刘猛 on 15/12/7.
//  Copyright © 2015年 Li Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GZECShareEntity : NSObject

/**
 *  分享必传字段
 */
@property (nonatomic ,strong) NSString *shareTitle;  //分享标题
@property (nonatomic ,strong) NSString *shareDescription; //分享描述
@property (nonatomic ,strong) NSString *shareURL;  //分享内容从url


/**
 *  微博分享独有字段
 */
@property (nonatomic ,strong) NSString *shareContent;//消息的文本内容
@property (nonatomic ,strong) NSData *shareImageDataForWB;  //分享图片   <=32k
@property (nonatomic ,strong) NSString *shareId;     //分享内容ID--可传0或者puid


/**
 *  QQ分享独有字段
 */
@property (nonatomic ,strong) UIImage *shareImageURLForQQ;   //分享图片url


/**
 *  微信分享独有字段
 */
@property (nonatomic ,strong) UIImage *shareImageForWX;     //分享图片  <=32K

@end
