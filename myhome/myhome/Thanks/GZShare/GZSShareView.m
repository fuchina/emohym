//
//  GZSShareView.m
//  GZSalesApp
//
//  Created by fudon on 2016/9/12.
//  Copyright © 2016年 www.guazi.com. All rights reserved.
//

#import "GZSShareView.h"
#import "GZECShareView.h"
#import "GZECShareEntity.h"
#import "GZShareSDK.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <MessageUI/MessageUI.h>
#import "FuSoft.h"
#import "FSBaseController.h"

typedef enum : NSUInteger {
    ACCTIONSHEET_TAG_WEIBO,
    ACCTIONSHEET_TAG_WEIXIN,
    ACCTIONSHEET_TAG_QQ,
} ACCTIONSHEET_TAG;

@interface GZSShareView ()<MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) GZECShareView     *shareView;
@property (nonatomic, strong) GZECShareEntity   *shareData;
@property (nonatomic, strong) UIAlertView       *alertView;
@property (nonatomic, weak)   UIViewController  *callController;

@end

@implementation GZSShareView

static GZSShareView *manager = nil;
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GZSShareView alloc] init];
    });
    return manager;
}

- (void)shareWithTitle:(NSString *)title description:(NSString *)description wbContent:(NSString *)content shareID:(NSString *)shareID imageUrl:(NSString *)imageUrl shareURL:(NSString *)url types:(NSArray<NSNumber *> *)types controller:(UIViewController *)controller
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = nil;
        if (imageUrl.description.length) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            UIImage *newImage = [UIImage imageWithData:data];
            image = [FuData compressImage:newImage targetWidth:100];
        }
        
        if (!image) {
            image = [UIImage imageNamed:@"share_Logo_app"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self shareWithTitle:title description:description content:content shareID:shareID wxImage:image wbImage:image shareURL:url QQImage:image types:types controller:controller];
        });
    });
}

- (void)shareWithTitle:(NSString *)title description:(NSString *)description content:(NSString *)content shareID:(NSString *)shareID wxImage:(UIImage *)wxImange wbImage:(UIImage *)wbImage shareURL:(NSString *)url QQImage:(UIImage *)qqImage types:(NSArray<NSNumber *> *)types controller:(UIViewController *)controller
{
    self.callController = controller;
    self.shareData = [[GZECShareEntity alloc] init];
    
    title = [FuData cleanString:title];
    if (!title.length) {
        title = @"瓜子二手车直卖网分享";
    }
    _shareData.shareTitle = title;
    
    _shareData.shareContent = content.description;
    
    if (![description isKindOfClass:[NSString class]]) {
        return;
    }
    if (!description.length) {
        description = @"瓜子二手车直卖网";
    }
    _shareData.shareDescription = description;
    
    if (!content.description.length) {
        content = @"分享内容";
    }
    if (shareID) {
        _shareData.shareId = shareID;
    }
    if (wxImange) {
        _shareData.shareImageForWX = wxImange;
    }
    if (wbImage) {
        _shareData.shareImageDataForWB = UIImageJPEGRepresentation(wbImage, 0.9);
    }
    
    if (![url isKindOfClass:[NSString class]]) {
        return;
    }
    if (url.length) {
        _shareData.shareURL = url;
    }else{
        _shareData.shareURL = @"https://www.guazi.com";
    }
    if (qqImage) {
        _shareData.shareImageURLForQQ = qqImage;
    }
    
    if (_shareView) {
        [_shareView removeFromSuperview];
        _shareView = nil;
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    WEAKSELF(ws);
    if ([types containsObject:@(GZSShareTypeFriends)]) {
        GZECShareButtonView *wechatTimeline = [[GZECShareButtonView alloc] initWithImageName:@"icon_wechat_timeline" title:@"朋友圈" clickAction:^{
            [ws.shareView hide];
            if (![GZShareSDK canSupportShare:GZShareTypeWXTimeline]) {
                [ws showAlertViewWithAlertTitle:@"未安装最新版本微信" message:@"是否去下载最新版微信" delegate:ws cancelButtonTitle:@"取消" otherButtonTitle:@"去下载" tag:ACCTIONSHEET_TAG_WEIXIN];
                return;
            }
            [[GZShareSDK shareInstance] shareMediaMessageWithTitle:ws.shareData.shareTitle description:ws.shareData.shareDescription thumbImage:ws.shareData.shareImageForWX shareURL:ws.shareData.shareURL shareType:GZShareTypeWXTimeline shareResult:^(BOOL result) {
                if (result) {
                    FSBaseController *baseController = (FSBaseController *)self.callController;
                    [baseController showTitle:@"朋友圈分享成功"];
//                    [fsst addActionLog:Car_detailpages_Sharecarsource attributes:@{@"from":@"朋友圈"}];
                }
            }];
        }];
        [array addObject:wechatTimeline];
    }
    
    if ([types containsObject:@(GZSShareTypeWechat)]) {
        GZECShareButtonView *wechat = [[GZECShareButtonView alloc] initWithImageName:@"icon_wechat" title:@"微信好友" clickAction:^{
            [ws.shareView hide];
            if (![GZShareSDK canSupportShare:GZShareTypeWXFriend]) {
                [ws showAlertViewWithAlertTitle:@"未安装最新版本微信" message:@"是否去下载最新版微信" delegate:ws cancelButtonTitle:@"取消" otherButtonTitle:@"去下载" tag:ACCTIONSHEET_TAG_WEIXIN];
                return;
            }
            [[GZShareSDK shareInstance] shareMediaMessageWithTitle:ws.shareData.shareTitle description:ws.shareData.shareDescription thumbImage:ws.shareData.shareImageForWX shareURL:ws.shareData.shareURL shareType:GZShareTypeWXFriend shareResult:^(BOOL result) {
                if (result) {
                    FSBaseController *baseController = (FSBaseController *)self.callController;
                    [baseController showTitle:@"微信好友分享成功"];
//                    [GZSStatisticsTool addActionLog:Car_detailpages_Sharecarsource attributes:@{@"from":@"微信好友"}];
                }
            }];
        }];
        [array addObject:wechat];
    }
    
    if ([types containsObject:@(GZSShareTypeWeibo)]) {
        GZECShareButtonView *sina = [[GZECShareButtonView alloc] initWithImageName:@"icon_sina" title:@"新浪微博" clickAction:^{
            [ws.shareView hide];
            if (![GZShareSDK canSupportShare:GZShareTypeWBShare]) {
                [ws showAlertViewWithAlertTitle:@"未安装微博客户端，是否现在去下载" message:nil delegate:ws cancelButtonTitle:@"以后再说" otherButtonTitle:@"现在下载" tag:ACCTIONSHEET_TAG_WEIBO];
                return;
            }
            [[GZShareSDK shareInstance] shareMediaMessageWithTitle:ws.shareData.shareTitle description:ws.shareData.shareDescription thumbImage:[UIImage imageWithData:ws.shareData.shareImageDataForWB] shareURL:ws.shareData.shareURL shareType:GZShareTypeWBShare shareResult:^(BOOL result) {
                if (result) {
                    FSBaseController *baseController = (FSBaseController *)self.callController;
                    [baseController showTitle:@"新浪微博分享成功"];
//                    [GZSStatisticsTool addActionLog:Car_detailpages_Sharecarsource attributes:@{@"from":@"新浪微博"}];
                }
            }];
        }];
        [array addObject:sina];
    }
    
    if ([types containsObject:@(GZSShareTypeQQ)]) {
        GZECShareButtonView *qq = [[GZECShareButtonView alloc] initWithImageName:@"icon_qq" title:@"QQ好友" clickAction:^{
            [ws.shareView hide];
            if (![GZShareSDK canSupportShare:GZShareTypeQQShare]) {
                [ws showAlertViewWithAlertTitle:@"未安装最新版本QQ" message:@"是否去下载最新版" delegate:ws cancelButtonTitle:@"取消" otherButtonTitle:@"去下载" tag:ACCTIONSHEET_TAG_QQ];
                return;
            }
            [[GZShareSDK shareInstance] shareMediaMessageWithTitle:ws.shareData.shareTitle description:ws.shareData.shareDescription thumbImage:ws.shareData.shareImageURLForQQ shareURL:ws.shareData.shareURL shareType:GZShareTypeQQShare shareResult:^(BOOL result) {
                if (result) {
                    FSBaseController *baseController = (FSBaseController *)self.callController;
                    [baseController showTitle:@"QQ好友分享成功"];
//                    [GZSStatisticsTool addActionLog:Car_detailpages_Sharecarsource attributes:@{@"from":@"QQ好友"}];
                }
            }];
        }];
        [array addObject:qq];
    }
    
    if ([types containsObject:@(GZSShareTypeQQZone)]) {
        GZECShareButtonView *qqzone = [[GZECShareButtonView alloc] initWithImageName:@"icon_qqzone" title:@"QQ空间" clickAction:^{
            [ws.shareView hide];
            if (![GZShareSDK canSupportShare:GZShareTypeQQZoneShare]) {
                [ws showAlertViewWithAlertTitle:@"未安装最新版本QQ" message:@"是否去下载最新版" delegate:ws cancelButtonTitle:@"取消" otherButtonTitle:@"去下载" tag:ACCTIONSHEET_TAG_QQ];
                return;
            }
            [[GZShareSDK shareInstance] shareMediaMessageWithTitle:ws.shareData.shareTitle description:ws.shareData.shareDescription thumbImage:ws.shareData.shareImageURLForQQ shareURL:ws.shareData.shareURL shareType:GZShareTypeQQZoneShare shareResult:^(BOOL result) {
                if (result) {
                    FSBaseController *baseController = (FSBaseController *)self.callController;
                    [baseController showTitle:@"QQ空间分享成功"];
//                    [GZSStatisticsTool addActionLog:Car_detailpages_Sharecarsource attributes:@{@"from":@"QQ空间"}];
                }
            }];
        }];
        [array addObject:qqzone];
    }
    
    if ([types containsObject:@(GZSShareTypeCopy)]) {
        GZECShareButtonView *copy = [[GZECShareButtonView alloc] initWithImageName:@"icon_copy" title:@"复制链接" clickAction:^{
            [ws.shareView hide];
            if (ws.shareData.shareURL) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = ws.shareData.shareURL;
                FSBaseController *baseController = (FSBaseController *)self.callController;
                [baseController showTitle:@"链接已经复制到粘贴板"];
//                [GZSSystemUtil showTipWithMessage:@"链接已经复制到粘贴板"];
//                [GZSStatisticsTool addActionLog:Car_detailpages_Sharecarsource attributes:@{@"from":@"复制链接"}];
            }else{
                FSBaseController *baseController = (FSBaseController *)self.callController;
                [baseController showTitle:@"没有链接!"];
            }
        }];
        [array addObject:copy];
    }
    
    if ([types containsObject:@(GZSShareTypeMessage)]) {
        GZECShareButtonView *copy = [[GZECShareButtonView alloc] initWithImageName:@"icon_share_message" title:@"发送短信" clickAction:^{
            [ws.shareView hide];
            
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.messageComposeDelegate = ws;
            picker.body =  ws.messageContent;
            if (ws.recipients) {
                picker.recipients = ws.recipients;
            }
            if (picker) {
                [ws.callController presentViewController:picker animated:YES completion:nil];
            }
        }];
        [array addObject:copy];
    }
    
    _shareView = [[GZECShareView alloc] initWithButtonGroup:array cancelTitle:@"取消"];
    [_shareView show];
}

- (void)showAlertViewWithAlertTitle:(NSString *)title
                            message:(NSString*)message
                           delegate:(id)delegate
                  cancelButtonTitle:(NSString*)cancelButtonTitile
                   otherButtonTitle:(NSString*)otherButtonTitle
                                tag:(NSInteger)tag
{
    self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitile otherButtonTitles:otherButtonTitle  , nil];
    _alertView.tag = tag;
    [_alertView show];
}

#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case ACCTIONSHEET_TAG_WEIXIN:
            if(buttonIndex == 1){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
            }
            break;
        case ACCTIONSHEET_TAG_WEIBO:
            if(buttonIndex == 1){
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WeiboSDK getWeiboAppInstallUrl]]];
                
            }
            break;
        case ACCTIONSHEET_TAG_QQ:
            if (buttonIndex == 1) {
                
            }
            break;
        default:
            break;
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
        {
            FSBaseController *baseController = (FSBaseController *)self.callController;
            [baseController showTitle:@"发送取消"];
        }
            break;
        case MessageComposeResultSent:
        {
            FSBaseController *baseController = (FSBaseController *)self.callController;
            [baseController showTitle:@"发送成功"];
        }
//            [GZSSystemUtil showTipWithMessage:@"发送成功"];
            break;
            
        case MessageComposeResultFailed:
        {
            FSBaseController *baseController = (FSBaseController *)self.callController;
            [baseController showTitle:@"发送失败"];
        }            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
