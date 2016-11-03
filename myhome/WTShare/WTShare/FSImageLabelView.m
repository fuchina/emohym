//
//  FSImageLabelView.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/5/14.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSImageLabelView.h"

@interface FSImageLabelView ()

@property (nonatomic,strong) UIImageView    *imageView;
@property (nonatomic,strong) UILabel        *label;

@end

@implementation FSImageLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self imageLabelDesignViews];
    }
    return self;
}

- (void)imageLabelDesignViews
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageLabelTapAction)];
    [self addGestureRecognizer:tap];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.width - 20)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 25, self.bounds.size.width, 25)];
    _label.font = [UIFont systemFontOfSize:14];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_label];
}

- (void)imageLabelTapAction
{
    if (_block) {
        _block(self);
    }
}

+ (FSImageLabelView *)imageLabelViewWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text
{
    FSImageLabelView *view = [[FSImageLabelView alloc] initWithFrame:frame];
    view.imageView.image = [UIImage imageNamed:imageName];
    view.label.text = text;
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
