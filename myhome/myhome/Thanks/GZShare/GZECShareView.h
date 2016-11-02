//
//  GZECShareView.h
//  GJErCarApp
//
//  Created by 刘猛 on 15/12/7.
//  Copyright © 2015年 Li Yi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GZECShareButtonClick)(void);

@interface GZECShareButtonView : UIControl

@property (nonatomic ,strong) UIImageView *shareBtn;
@property (nonatomic ,strong) UILabel *titleLab;
- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title clickAction:(GZECShareButtonClick)click;

@end

@interface GZECShareView : UIView

- (instancetype)initWithButtonGroup:(NSArray *)buttons cancelTitle:(NSString *)cancelTitle;

- (void)show;
- (void)hide;

@end
