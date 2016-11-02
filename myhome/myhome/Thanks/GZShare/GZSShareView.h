//
//  GZSShareView.h
//  GZSalesApp
//
//  Created by fudon on 2016/9/12.
//  Copyright © 2016年 www.guazi.com. All rights reserved.
//

/*
    帐号信息：
        QQ平台:
            密码:GZSqq123!!
*/

#import <UIKit/UIKit.h>
#import "GZShareSDK.h"

// C端
//#define kWeChatAppID        @"wxb3389a453a8b44af"
//#define kWeChatAppSecret    @"cf227a213846e90310c5234a63fd070c"
#define kWeiBoAppKey        @"1470713583"
//#define kQQAppKey           @"rD9BkrkhShNmj9hQ"
//#define kQQAppID            @"1104626856"

//#define kWeChatAppID        @"wxea89df63e447e88e"
#define kWeChatAppID        @"wx9a072d35782dfa06"

//#define kWeChatAppSecret    @"cf227a213846e90310c5234a63fd070c"
//#define kQQAppID            @"1105694090"
//#define kQQAppKey           @"1vRQEPSX4Boyn8Ok"
//#define kQQAppID            @"1105723990"
//#define kQQAppKey           @"a4vCwfoXQosOaDLw"

#define kQQAppID            @"1105723990"
#define kQQAppKey           @"a4vCwfoXQosOaDLw"


typedef enum : NSInteger {
    GZSShareTypeQQ = 0,
    GZSShareTypeQQZone,
    GZSShareTypeWechat,
    GZSShareTypeFriends,
    GZSShareTypeWeibo,
    GZSShareTypeMessage,
    GZSShareTypeCopy
} GZSShareType;

@interface GZSShareView : UIView

@property (nonatomic,copy) NSString     *messageContent;
@property(nonatomic,copy) NSArray<NSString *> *recipients;

+ (instancetype)shareInstance;

- (void)shareWithTitle:(NSString *)title description:(NSString *)description wbContent:(NSString *)content shareID:(NSString *)shareID imageUrl:(NSString *)imageUrl shareURL:(NSString *)url types:(NSArray<NSNumber *> *)types controller:(UIViewController *)controller;


@end
