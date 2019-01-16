//
//  QDBaseViewController.m
//  QDINFI
//
//  Created by ZengTark on 2017/12/5.
//  Copyright © 2017年 quantdo. All rights reserved.
//

#import "QDBaseViewController.h"

@interface QDBaseViewController ()

@end

@implementation QDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    QDWeakSelf(self);
    [self setThemeChangeBlock:^{
        [weakself.view setBackgroundColor:[UIColor colorWithHexString:[QDColorTheme shareColorTheme].background]];
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showBack:(BOOL)show
{
    if (show) {
        UIImage *backImage = [UIImage imageNamed:@"back"];
        UIImage *selectedImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:selectedImage style:UIBarButtonItemStylePlain target:self action:@selector(navBack:)];
        [self.navigationItem setLeftBarButtonItem:backItem animated:YES];
    }
}

- (void)showBackWithMark{
    
}

- (void)popToLast{
    UIImage *backImage = [UIImage imageNamed:@"back"];
    UIImage *selectedImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:selectedImage style:UIBarButtonItemStylePlain target:self action:@selector(popTheLast:)];
    [self.navigationItem setLeftBarButtonItem:backItem animated:YES];
}

- (void)navBack:(UIBarButtonItem *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)popTheLast:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
