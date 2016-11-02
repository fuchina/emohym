//
//  UIView+borders.h
//  HouseRent
//
//  Created by tongtiexin on 13-11-18.
//  Copyright (c) 2016年 www.guazi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+POViewFrameBuilder.h"

typedef NS_ENUM(NSUInteger, UIViewBorderPosition) {
    UIViewBorderPositionTop = 0,
    UIViewBorderPositionBottom = 1,
    UIViewBorderPositionLeft = 2,
    UIViewBorderPositionRight = 3
};
@interface UIView (borders)

-(NSInteger)borderTagWithPosition:(UIViewBorderPosition)position;
-(void)setBorderWithColor:(UIColor*)color borderSize:(CGSize)size in:(enum UIViewBorderPosition)position;
-(void)setBorderWithColor:(UIColor*)color thickness:(CGFloat)thickness in:(enum UIViewBorderPosition)position edgeInserts:(UIEdgeInsets)edgeInserts;

@end
