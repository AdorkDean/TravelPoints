//
//  QDOrderDetailVC.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/16.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDOrderDetailVC.h"
#import "QDPickOrderView.h"
@interface QDOrderDetailVC (){
    QDPickOrderView *_pickOrderView;
}

@end

@implementation QDOrderDetailVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}

- (void)setLeftBtnItem{
    UIImage *backImage = [UIImage imageNamed:@"icon_return"];
    UIImage *selectedImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:selectedImage style:UIBarButtonItemStylePlain target:self action:@selector(leftBtn)];
    [self.navigationItem setLeftBarButtonItem:backItem animated:YES];
}
- (void)leftBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.view.backgroundColor = APP_WHITECOLOR;
    [self setLeftBtnItem];
    _pickOrderView = [[QDPickOrderView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _pickOrderView.backgroundColor = APP_GRAYBACKGROUNDCOLOR;
    11
    [self.view addSubview:_pickOrderView];
}
@end
