//
//  FSShareViewController.m
//  WTShare
//
//  Created by FudonFuchina on 16/9/4.
//  Copyright © 2016年 wutong. All rights reserved.
//

#import "FSShareViewController.h"
#import "FSShareView.h"
#import "FSShareManager.h"
#import "WTShareContentItem.h"

@interface FSShareViewController ()

@end

@implementation FSShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(bbiAction)];
    self.navigationItem.rightBarButtonItem = bbi;
}

- (void)bbiAction
{
    __weak FSShareViewController *this = self;
    FSShareView *shareView = [[FSShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.navigationController.view addSubview:shareView];
    shareView.block = ^ (FSShareView *bView,NSInteger bTag){
        [this shareTo:bTag];
    };
}


- (void)shareTo:(NSInteger)tag
{
    if (tag == WTShareTypeWeiBo) {
        
        [FSShareManager wt_shareWithContent:[WTShareContentItem shareWTShareContentItem] shareType:WTShareTypeWeiBo shareResult:^(NSString *shareResult) {
            NSLog(@"🐒🐒🐒🐒🐒🐒---%@", shareResult);
        }];
        
    }else if (tag == WTShareTypeQQ){
        [FSShareManager wt_shareWithContent:[WTShareContentItem shareWTShareContentItem] shareType:WTShareTypeQQ shareResult:^(NSString *shareResult) {
            NSLog(@"🐒🐒🐒🐒🐒🐒---%@", shareResult);
        }];
    }else if (tag == WTShareTypeQQZone){
        [FSShareManager wt_shareWithContent:[WTShareContentItem shareWTShareContentItem] shareType:WTShareTypeQQZone shareResult:^(NSString *shareResult) {
            NSLog(@"🐒🐒🐒🐒🐒🐒---%@", shareResult);
        }];
    }else if (tag == WTShareTypeWeiXinTimeline){
        [FSShareManager wt_shareWithContent:[WTShareContentItem shareWTShareContentItem] shareType:WTShareTypeWeiXinTimeline shareResult:^(NSString *shareResult) {
            NSLog(@"🐒🐒🐒🐒🐒🐒---%@", shareResult);
        }];
    }else if (tag == WTShareTypeWeiXinSession){
        [FSShareManager wt_shareWithContent:[WTShareContentItem shareWTShareContentItem] shareType:WTShareTypeWeiXinSession shareResult:^(NSString *shareResult) {
            NSLog(@"🐒🐒🐒🐒🐒🐒---%@", shareResult);
        }];
    }else if (tag == WTShareTypeWeiXinFavorite){
        [FSShareManager wt_shareWithContent:[WTShareContentItem shareWTShareContentItem] shareType:WTShareTypeWeiXinFavorite shareResult:^(NSString *shareResult) {
            NSLog(@"🐒🐒🐒🐒🐒🐒---%@", shareResult);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
