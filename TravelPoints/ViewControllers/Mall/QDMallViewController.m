//
//  QDMallViewController.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/14.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDMallViewController.h"
#import "QDMallTopView.h"
@interface QDMallViewController (){
    QDMallTopView *_mallTopView;
}

@end

@implementation QDMallViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _mallTopView = [[QDMallTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.06)];
    _mallTopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mallTopView];
    // Do any additional setup after loading the view.
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
