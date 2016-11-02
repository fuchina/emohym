//
//  UIView+borders.m
//  HouseRent
//
//  Created by tongtiexin on 13-11-18.
//  Copyright (c) 2016年 www.guazi.com. All rights reserved.
//

#import "UIView+borders.h"
#import <CoreGraphics/CoreGraphics.h>
#import "FuSoft.h"

#define kBorderViewTag 345344

//static inline NSUInteger borderTagWithPosition(enum UIViewBorderPosition position)
//{
//    return kBorderViewTag + position;
//};

@implementation UIView (borders)

-(NSInteger)borderTagWithPosition:(UIViewBorderPosition)position
{
	return kBorderViewTag + position;
}

-(void)setBorderWithColor:(UIColor*)color borderSize:(CGSize)size in:(enum UIViewBorderPosition)position
{
    static NSInteger baseTag=2365;
    UIView *border=[self viewWithTag:baseTag+position];
    [border removeFromSuperview];
    border=nil;
	border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTHFC, size.height)];
	border.backgroundColor = color;
    [border.po_frameBuilder setWidth:size.width];
    [self addSubview:border];
    switch (position) {
        case UIViewBorderPositionTop:
        {
            [[border.po_frameBuilder alignToTopInSuperviewWithInset:0] centerHorizontallyInSuperview];
        }
            break;
        case UIViewBorderPositionLeft:
        {
            border.transform=CGAffineTransformMakeRotation(90 *M_PI / 180.0);CGAffineTransformMakeRotation(90 *M_PI / 180.0);
            [[border.po_frameBuilder alignLeftInSuperviewWithInset:0] centerVerticallyInSuperview];
        }
            break;
        case UIViewBorderPositionBottom:
        {
            [[border.po_frameBuilder alignToBottomInSuperviewWithInset:0] centerHorizontallyInSuperview];
        }
            break;
        case UIViewBorderPositionRight:
        {
            border.transform=CGAffineTransformMakeRotation(90 *M_PI / 180.0);CGAffineTransformMakeRotation(90 *M_PI / 180.0);
            [[border.po_frameBuilder alignRightInSuperviewWithInset:0] centerVerticallyInSuperview];
        }
            break;
        default:
            break;
    }
}

-(void)setBorderWithColor:(UIColor *)color thickness:(CGFloat)thickness in:(enum UIViewBorderPosition)position edgeInserts:(UIEdgeInsets)edgeInserts
{
    CGRect borderFrame;
    CGSize borderSize;
    CGPoint borderPosition;
    UIView *borderView=[self viewWithTag:[self borderTagWithPosition:position]];
    [borderView removeFromSuperview];
    borderView=nil;
    borderView=[[UIView alloc] init];
	borderView.backgroundColor = color;
	borderView.tag =  [self borderTagWithPosition:position];
    // 上下横向的线高度是粗细，左右纵向的线宽度是粗细
    if (position == UIViewBorderPositionTop || position == UIViewBorderPositionBottom) {
        borderSize.height = thickness;
        borderSize.width = self.width - edgeInserts.left - edgeInserts.right;
        
    }
    else {
        borderSize.height = self.height - edgeInserts.top - edgeInserts.bottom;
        borderSize.width = thickness;
    }
    switch (position) {
        case UIViewBorderPositionTop:
        {
            borderPosition.x = edgeInserts.left;
            borderPosition.y = edgeInserts.top;
        }
            break;
        case UIViewBorderPositionBottom:
        {
            borderPosition.x = edgeInserts.left;
            borderPosition.y = self.height - edgeInserts.bottom - thickness;

        }
            break;
        case UIViewBorderPositionLeft:
        {
            borderPosition.x = edgeInserts.left;
            borderPosition.y = edgeInserts.top;
        }
            break;
        case UIViewBorderPositionRight:
        {
            borderPosition.x = self.width - edgeInserts.right - thickness;
            borderPosition.y = edgeInserts.top;
        }
            break;
        default:
            break;
    }
    borderFrame.size = borderSize;
    borderFrame.origin = borderPosition;
    borderView.frame = borderFrame;
    borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:borderView];
}

@end
