//
//  GZECShareView.m
//  GJErCarApp
//
//  Created by 刘猛 on 15/12/7.
//  Copyright © 2015年 Li Yi. All rights reserved.
//

#import "GZECShareView.h"
#import "UIView+borders.h"
#import "UIView+Addition.h"
#import "FuSoft.h"

#define kRowCount 3

@interface GZECShareButtonView ()

@property (nonatomic, copy) GZECShareButtonClick clickAction;

@end

@implementation GZECShareButtonView

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title clickAction:(GZECShareButtonClick)click
{
    if (self = [super init]) {
        self.clickAction = click;
        
        NSInteger width = WIDTHFC/kRowCount;
        self.width = width;
        self.height = 75;
        
        UIImage *image = [UIImage imageNamed:imageName];
        self.shareBtn = [[UIImageView alloc] init];
        _shareBtn.image = image;
        
        self.shareBtn.width = image.size.width;
        self.shareBtn.height = image.size.height;
        self.shareBtn.centerX = width/2;
        self.shareBtn.top = 10;
        
        [self addSubview:self.shareBtn];
        
        self.titleLab = [[UILabel alloc] init];
        [self.titleLab setText:title];
        self.titleLab.font = [UIFont systemFontOfSize:13];
        [self.titleLab sizeToFit];
        self.titleLab.backgroundColor = [UIColor clearColor];
        self.titleLab.textColor = GZColorFromRGB(0x333333);
        self.titleLab.top = self.shareBtn.bottom + 5;
        self.titleLab.centerX = width/2;
        [self addSubview:self.titleLab];
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.titleLab.textColor = GZColorFromRGB(0x22ac38);
        self.backgroundColor = GZColorFromRGB(0xf4f4f4);
    } else {
        self.titleLab.textColor = GZColorFromRGB(0x333333);
        self.backgroundColor = GZColorFromRGB(0xffffff);
    }
}

- (void)buttonClick
{
    if (self.clickAction) {
        _clickAction();
    }
}

@end

struct SharePosition
{
    int x;
    int y;
};

@interface GZECShareView ()

@property (nonatomic, strong) NSMutableArray *buttonList;
@property (nonatomic, strong) NSString *cancelTitle;
@property (nonatomic, strong) UIControl *backgroundView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIControl *contentView;

@end

@implementation GZECShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithButtonGroup:(NSArray *)buttons cancelTitle:(NSString *)cancelTitle
{
    if (self = [super init]) {
        _buttonList = [NSMutableArray arrayWithArray:buttons];
        _cancelTitle = cancelTitle;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.backgroundColor = [UIColor clearColor];
    self.width = WIDTHFC;
    self.height = HEIGHTFC;
    
    _backgroundView = [[UIControl alloc] init];
    [_backgroundView addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.width = WIDTHFC;
    _backgroundView.height = HEIGHTFC;
    _backgroundView.left = 0;
    _backgroundView.top = 0;
    
    _contentView = [[UIControl alloc] initWithFrame:CGRectMake(0, HEIGHTFC, WIDTHFC, 0)];
    [_contentView addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _contentView.backgroundColor = GZColorFromRGB(0xf2f2f2);
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, 0)];
    backView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:backView];
    
    NSInteger numbersPerLine = (_buttonList.count == 4)?2:3;
    _contentView.height = (_buttonList.count < 4)?127:203;
    
    CGFloat width = _contentView.width / numbersPerLine;
    GZECShareButtonView *button = nil;
    for (int i = 0; i < _buttonList.count; i++) {
        button = [_buttonList objectAtIndex:i];
        button.frame = CGRectMake((i % numbersPerLine) * width, (i / numbersPerLine) * button.height, width, button.height);
        button.shareBtn.centerX = button.width / 2;
        button.titleLab.centerX = button.width / 2;
//        struct SharePosition posi = getPosition(i);
//        button.left = posi.y * button.width;
//        button.top = posi.x * button.height;
//        [button setBorderWithColor:GZS_TextColor_Light borderSize:CGSizeMake(button.width, GZS_LineThickness) in:UIViewBorderPositionBottom];
//        [button setBorderWithColor:GZS_TextColor_Light borderSize:CGSizeMake(button.height, GZS_LineThickness) in:UIViewBorderPositionRight];
        [_contentView addSubview:button];
    }
    backView.height = button.bottom;
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(0, 0, WIDTHFC, 40);
    _cancelButton.bottom = _contentView.height;
//    [_cancelButton setBorderWithColor:DefaultLineColor borderSize:CGSizeMake(_cancelButton.width, 1) in:UIViewBorderPositionTop];
    _cancelButton.backgroundColor = [UIColor whiteColor];
    [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:GZColorFromRGB(0x333333) forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = FONTFC(14);
    [_contentView addSubview:_cancelButton];
    
    [self addSubview:_backgroundView];
    [self addSubview:_contentView];
    
    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xAxis.minimumRelativeValue = @(-15);
    xAxis.maximumRelativeValue = @15;
    
    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yAxis.minimumRelativeValue = @(-15);
    yAxis.maximumRelativeValue = @15;
    
    [_contentView addMotionEffect:xAxis];
    [_contentView addMotionEffect:yAxis];
}

struct SharePosition getPosition(int index)
{
    int x = 0; int y = 0;
    x = index/kRowCount;
    y = index%kRowCount;
    struct SharePosition posi;
    posi.x = x;
    posi.y = y;
    return posi;
}

- (void)show
{
    UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] firstObject];
    CGRect winFrame = keyWindow.frame;
    
    self.frame = winFrame;
    _backgroundView.frame = winFrame;
    _backgroundView.alpha = 0.0;
    
    
    [keyWindow addSubview:self];
    _contentView.top = HEIGHTFC;
    
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.3;
        _contentView.bottom = HEIGHTFC;
    }];
}

- (void)hide
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.0;
        _contentView.top = HEIGHTFC;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)cancelButtonClick
{
    [self hide];
}

@end
