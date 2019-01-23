//
//  ViewController.m
//  tewtsdf
//
//  Created by 冉金 on 2019/1/17.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//
#define SCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)

#import "QDRestaurantViewController.h"
#import "QDRestaurantTopView.h"
#import "QDRestaurantViewCell.h"
@interface QDRestaurantViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation QDRestaurantViewController

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
    QDRestaurantTopView *restView = [[QDRestaurantTopView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.054, 0, SCREEN_WIDTH*0.89, SCREEN_HEIGHT*0.048)];
    [self.view addSubview:restView];
    [self initTableView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return SCREEN_HEIGHT*0.03;
    }
    return 0.01;
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.126, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
//    if (@available(iOS 11.0, *)) {
//        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
#pragma mark -- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT*0.375;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"QDRestaurantViewCell";
    QDRestaurantViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[QDRestaurantViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self addShadowToView:cell withColor:APP_GRAYCOLOR];
    
    //设置cell点击时的颜色
    //    UIView *backgroundViews = [[UIView alloc]initWithFrame:cell.frame];
    //    backgroundViews.backgroundColor = [UIColor whiteColor];
    //    [cell setSelectedBackgroundView:backgroundViews];
    //    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(13,13);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 13;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 6;
    
}

@end
