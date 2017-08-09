//
//  FSShopClassView.h
//  myhome
//
//  Created by Guazi on 2017/7/12.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSShopClassView : UIView

@property (nonatomic,strong) NSArray    *dataSource;
@property (nonatomic,copy) void (^selectedBlock)(FSShopClassView *bView,NSInteger bIndex);

@end
