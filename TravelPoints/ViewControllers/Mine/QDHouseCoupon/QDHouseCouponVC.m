//
//  QDHouseCouponVC.m
//  TravelPoints
//
//  Created by WJ-Shao on 2019/3/28.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDHouseCouponVC.h"
#import "AllHouseCouponVC.h"
#import "UnusedHouseCouponVC.h"
#import "UserdHouseCouponVC.h"
#import "ExpiredHouseCouponVC.h"
@interface QDHouseCouponVC ()

@end

@implementation QDHouseCouponVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APP_WHITECOLOR;
    [self setTopHeaderView];
    self.progressViewIsNaughty = YES;
    self.progressWidth = 10;

}

- (void)setTopHeaderView{
    UIButton *returnBtn = [[UIButton alloc] init];
    [returnBtn setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(popPage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    [returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.width.and.height.mas_equalTo(60);
    }];
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"房券";
    titleLab.textColor = APP_BLACKCOLOR;
    titleLab.font = QDBoldFont(18);
    [self.view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(returnBtn);
    }];
    
    UILabel *infoLab = [[UILabel alloc] init];
    infoLab.text = @"如何获取";
    infoLab.textColor = APP_GRAYTEXTCOLOR;
    infoLab.font = QDFont(14);
    [self.view addSubview:infoLab];
    [infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLab);
        make.right.equalTo(self.view.mas_right).offset(-42);
    }];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    
}

- (void)popPage:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIColor *)progressColor{
    return APP_BLUECOLOR;
}

- (UIColor *)titleColorSelected{
    return APP_BLACKCOLOR;
}

- (CGFloat)titleSizeNormal{
    return 15;
}

- (CGFloat)titleSizeSelected{
    return 16;
}

- (WMMenuViewStyle)menuViewStyle{
    return WMMenuViewStyleLine;
}

- (UIColor *)titleColorNormal{
    return APP_GRAYTEXTCOLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 4;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index) {
        case 0: return @"全部";
        case 1: return @"未使用";
        case 2: return @"已使用";
        case 3: return @"已过期";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0: return [[AllHouseCouponVC alloc] init];
        case 1: return [[UnusedHouseCouponVC alloc] init];
        case 2: return [[UserdHouseCouponVC alloc] init];
        case 3: return [[ExpiredHouseCouponVC alloc] init];
    }
    return [[UIViewController alloc] init];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 20;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.style = WMMenuViewStyleFloodHollow;
    self.menuView.style = WMMenuViewStyleLine;
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    return CGRectMake(leftMargin, SafeAreaTopHeight-8, self.view.frame.size.width - 2*leftMargin, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}
@end
