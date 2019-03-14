//
//  WMCustomizedPageController.m
//  WMPageControllerExample
//
//  Created by Mark on 2017/6/21.
//  Copyright © 2017年 Mark. All rights reserved.
//

#import "QDTestVC.h"
#import "QDFirstViewController.h"
#import "QDSecondViewController.h"
#import "QDThirdViewController.h"
#import "QDFourViewController.h"

@interface QDTestVC ()
@end

@implementation QDTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APP_WHITECOLOR;
    self.progressViewIsNaughty = YES;
    self.progressWidth = 10;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
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
        case 0: return @"用玩贝";
        case 1: return @"转玩贝";
        case 2: return @"我的报单";
        case 3: return @"我的摘单";
    }
    return @"NONE";
}

//- (UIColor *)titleColorNormal{
//    return APP_BLUECOLOR;
//}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0: return [[QDFirstViewController alloc] init];
        case 1: return [[QDSecondViewController alloc] init];
        case 2: return [[QDThirdViewController alloc] init];
        case 3: return [[QDFourViewController alloc] init];
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
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        menuView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        menuView.style = WMMenuViewStyleLine;
        return CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 64);
    }
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    CGFloat originY = self.showOnNavigationBar ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(leftMargin, 24, self.view.frame.size.width - 2*leftMargin, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        return CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 44);
    }
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
//    if (self.menuViewStyle == WMMenuViewStyleTriangle) {
//        originY += self.redView.frame.size.height;
//    }
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}

@end
