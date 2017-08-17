//
//  ARPersonController.m
//  myhome
//
//  Created by fudon on 2016/11/1.
//  Copyright © 2016年 fuhope. All rights reserved.
//

#import "ARPersonController.h"
#import "FSShareView.h"
#import <FSKit.h>

@interface ARPersonController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray    *titles;

@end

@implementation ARPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    [self personDesignViews];
}

- (void)personDesignViews
{
    _titles = @[@"分享",@"反馈",@"关于",@"设置"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 64) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTHFC, 10)];
    tableView.tableHeaderView = headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self showShareView];
    }
}

- (void)showShareView
{
    __weak ARPersonController *this = self;
    FSShareView *shareView = [[FSShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.navigationController.tabBarController.view addSubview:shareView];
    shareView.block = ^ (FSShareView *bView,NSInteger bTag){
        [this shareTo:bTag];
    };
}

- (void)shareTo:(NSInteger)tag
{
    if (tag == WTShareTypeWeiBo) {
        [FSShareManager wt_shareWithContent:[WTShareContentItem shareWTShareContentItem] shareType:WTShareTypeWeiBo shareResult:^(NSString *shareResult) {
            [FSKit showAlertWithMessage:shareResult];
        }];
        
    }else if (tag == WTShareTypeQQ){
        [FSShareManager wt_shareWithContent:[WTShareContentItem shareWTShareContentItem] shareType:WTShareTypeQQ shareResult:^(NSString *shareResult) {
            [FSKit showAlertWithMessage:shareResult];
        }];
    }else if (tag == WTShareTypeQQZone){
        [FSShareManager wt_shareWithContent:[WTShareContentItem shareWTShareContentItem] shareType:WTShareTypeQQZone shareResult:^(NSString *shareResult) {
            [FSKit showAlertWithMessage:shareResult];
        }];
    }else if (tag == WTShareTypeWeiXinTimeline){
        [FSShareManager wt_shareWithContent:[WTShareContentItem shareWTShareContentItem] shareType:WTShareTypeWeiXinTimeline shareResult:^(NSString *shareResult) {
            [FSKit showAlertWithMessage:shareResult];
        }];
    }else if (tag == WTShareTypeWeiXinSession){
        [FSShareManager wt_shareWithContent:[WTShareContentItem shareWTShareContentItem] shareType:WTShareTypeWeiXinSession shareResult:^(NSString *shareResult) {
            [FSKit showAlertWithMessage:shareResult];
        }];
    }else if (tag == WTShareTypeWeiXinFavorite){
        [FSShareManager wt_shareWithContent:[WTShareContentItem shareWTShareContentItem] shareType:WTShareTypeWeiXinFavorite shareResult:^(NSString *shareResult) {
            [FSKit showAlertWithMessage:shareResult];
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
