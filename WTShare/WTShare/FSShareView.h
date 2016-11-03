//
//  FSShareView.h
//  WTShare
//
//  Created by FudonFuchina on 16/9/4.
//  Copyright © 2016年 wutong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSShareView : UIView

@property (nonatomic,copy) void (^block)(FSShareView *bShareView,NSInteger bType);

@end
