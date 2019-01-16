//
//  QDRegisterViewController.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/14.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDRegisterViewController.h"
#import "QDRegisterView.h"
#import "QDLoginViewController.h"
@interface QDRegisterViewController ()

@property (nonatomic, strong) QDRegisterView *registerView;
@end

@implementation QDRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _registerView = [[QDRegisterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _registerView.backgroundColor = [UIColor whiteColor];
//    [_registerView.loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerView];
    _yyLabel = [[YYLabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.056, SCREEN_HEIGHT*0.49, SCREEN_WIDTH*0.7, 40)];
    _yyLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _yyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_yyLabel];
    [self protocolIsSelect:NO];
    // Do any additional setup after loading the view.
}

- (void)login:(UIButton *)sender{
    QDLoginViewController *loginVC = [[QDLoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:^{
    }];
}

- (void)protocolIsSelect:(BOOL)isSelect{
    //设置整段字符串的颜色
    UIColor *color = self.isSelect ? [UIColor blackColor] : [UIColor lightGrayColor];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12], NSForegroundColorAttributeName: color};
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"  已阅读并同意《行点用户注册协议》" attributes:attributes];
    //设置高亮色和点击事件
    [text yy_setTextHighlightRange:[[text string] rangeOfString:@"《行点用户注册协议》"] color:[UIColor blackColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"点击了《用户协议》");
    }];
    //添加图片
    UIImage *image = [UIImage imageNamed:self.isSelect == NO ? @"unSelectIcon" : @"selectIcon"];
    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(12, 12) alignToFont:[UIFont fontWithName:@"PingFangSC-Regular"  size:12] alignment:(YYTextVerticalAlignment)YYTextVerticalAlignmentCenter];
    //将图片放在最前面
    [text insertAttributedString:attachment atIndex:0];
    //添加图片的点击事件
    [text yy_setTextHighlightRange:[[text string] rangeOfString:[attachment string]] color:[UIColor clearColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        __weak typeof(self) weakSelf = self;
        weakSelf.isSelect = !weakSelf.isSelect;
        [weakSelf protocolIsSelect:self.isSelect];
    }];
    _yyLabel.attributedText = text;
    //居中显示一定要放在这里，放在viewDidLoad不起作用
    _yyLabel.textAlignment = NSTextAlignmentCenter;
    
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
