//
//  QDLoginAndRegisterVC.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/15.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDLoginAndRegisterVC.h"

@interface QDLoginAndRegisterVC ()
@end

@implementation QDLoginAndRegisterVC

- (void)viewWillAppear:(BOOL)animated{
    _isResetPwdNextStep = NO;
    [_loginBtn setHidden:YES];
    [_registerBtn setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //登录页面
    _loginView = [[QDLoginView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_loginView.gotologinBtn addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.forgetPWD addTarget:self action:@selector(forgetPWD:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_loginView];
    [_loginView setHidden:NO];

    //注册页面
    _registerView = [[QDRegisterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_registerView.nextBtn addTarget:self action:@selector(registNextStep:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerView];
    [_registerView setHidden:YES];
    
    //身份验证页面
    _identifyView = [[IdentifyView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_registerView];
    [self.view addSubview:_identifyView];
    [_identifyView setHidden:YES];

    //协议富文本
    _yyLabel = [[YYLabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.056, SCREEN_HEIGHT*0.49, SCREEN_WIDTH*0.7, 40)];
    _yyLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _yyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_yyLabel];
    [self protocolIsSelect:NO];
    [_yyLabel setHidden:YES];
    
    //_identifyInputView
    _identifyInputView = [[VertificationCodeInputView alloc]initWithFrame:CGRectMake(50,SCREEN_HEIGHT*0.48,self.view.frame.size.width - 100,55)];
    _identifyInputView.delegate = self;
    _identifyInputView.numberOfVertificationCode = 4;
    _identifyInputView.secureTextEntry =NO;
    [self.view addSubview:_identifyInputView];
    [_identifyInputView setHidden:YES];
    
    //_msgInputView
    _msgInputView = [[VertificationCodeInputView alloc]initWithFrame:CGRectMake(50,SCREEN_HEIGHT*0.34,self.view.frame.size.width - 100,55)];
    _msgInputView.delegate = self;
    /****** 设置验证码/密码的位数默认为四位 ******/
    _msgInputView.numberOfVertificationCode = 4;
    /*********验证码（显示数字）YES,隐藏形势 NO，数字形式**********/
    _msgInputView.secureTextEntry =NO;
    [self.view addSubview:_msgInputView];
    [_msgInputView setHidden:YES];
    
    //短信验证码
    _msgVerifyView = [[QDMsgVerifyView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_msgVerifyView];
    [_msgVerifyView setHidden:YES];
    
    //设置登录密码
    _setLogPwdView = [[QDSetLoginPwdView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_setLogPwdView.registerBtn addTarget:self action:@selector(setLoginPwd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_setLogPwdView];
    [_setLogPwdView setHidden:YES];
    
    //忘记密码view
    _forgetPwdView = [[QDForgetPwdView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_forgetPwdView.nextStepBtn addTarget:self action:@selector(resetPwdNextStep:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetPwdView];
    [_forgetPwdView setHidden:YES];
    
    //
    _resetLoginPwdView  = [[QDResetLoginPwdView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_resetLoginPwdView.confirmBtn addTarget:self action:@selector(confirmToModeifyPwd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resetLoginPwdView];
    [_resetLoginPwdView setHidden:YES];
    
    [self setSideBtn];
}

- (void)setSideBtn{
    _cancelBtn = [[UIButton alloc] init];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(SCREEN_HEIGHT*0.054);
        make.left.equalTo(self.view.mas_left).offset(SCREEN_WIDTH*0.056);
    }];
    
    _loginBtn = [[UIButton alloc] init];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];

    [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.view addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cancelBtn);
        make.right.equalTo(self.view.mas_right).offset(-(SCREEN_WIDTH*0.056));
    }];
    
    _registerBtn = [[UIButton alloc] init];
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cancelBtn);
        make.right.equalTo(self.view.mas_right).offset(-(SCREEN_WIDTH*0.056));
    }];
    
}

//取消按钮
- (void)cancelAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//点击右上角登录按钮
- (void)loginAction:(UIButton *)sender{
    [_registerBtn setHidden:NO];
    [_loginBtn setHidden:YES];
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [_registerView.layer addAnimation:animation forKey:nil];
    _registerView.hidden = YES;
    [_loginView setHidden:NO];
    [_yyLabel setHidden:YES];
    //
    [_msgVerifyView setHidden:YES];
    [_setLogPwdView setHidden:YES];
    [_identifyView setHidden:YES];
    [_msgInputView setHidden:YES];
    [_identifyInputView setHidden:YES];
}

//点击右上角注册按钮
- (void)registerAction:(UIButton *)sender{
    [_registerBtn setHidden:YES];
    [_loginBtn setHidden:NO];
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [_loginView.layer addAnimation:animation forKey:nil];
    _loginView.hidden = YES;
    [_registerView setHidden:NO];
    [_yyLabel setHidden:NO];
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

#pragma mark - 用户登录
- (void)userLogin:(UIButton *)sender{
//    [WXProgressHUD showHUD];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[QDServiceClient shareClient] loginWithUserName:@"13207166278" password:@"1" successBlock:^(NSDictionary *responseObject) {
        QDLog(@"123");
        if ([[responseObject objectForKey:@"code"] intValue] == 0) {
//            [WXProgressHUD hideHUD];
            NSDictionary *dic = [responseObject objectForKey:@"result"];
            [QDUserDefaults setObject:[dic objectForKey:@"sessionId"] forKey:@"Token"];
            QDLog(@"Token = %@", [dic objectForKey:@"sessionId"]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [WXProgressHUD showInfoWithTittle:@"登录成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
//            QDToast(<#str#>)
        }
    } failureBlock:^(NSError *error) {

    }];
}

#pragma mark - 忘记密码
- (void)forgetPWD:(UIButton *)sender{
    [_loginView setHidden:YES];
    [_forgetPwdView setHidden:NO];
}

#pragma mark - 下一步按钮:注册行点&&找回密码
- (void)registNextStep:(UIButton *)sender{
    _isResetPwdNextStep = NO;
    QDLog(@"%@", self.presentedViewController.view.class);
    [_identifyView setHidden:NO];
    [_loginView setHidden:YES];
    [_registerView setHidden:YES];
    [_yyLabel setHidden:YES];
    //当前为验证身份inputView
    _currentInputView = _identifyInputView;
    [_identifyInputView becomeFirstResponder];
    [_identifyInputView setHidden:NO];
}

#pragma mark - 忘记密码页面的下一步按钮
- (void)resetPwdNextStep:(UIButton *)sender{
    _isResetPwdNextStep = YES;
    QDLog(@"%@", self.presentedViewController.view.class);
    //当前为验证身份inputView
    [_forgetPwdView setHidden:YES];
    _currentInputView = _identifyInputView;
    [_identifyInputView becomeFirstResponder];
    [_identifyInputView setHidden:NO];
    [_identifyView setHidden:NO];
}
#pragma mark --------- 获取验证码
-(void)returnTextFieldContent:(NSString *)content{
    NSLog(@"%@================验证码",content);
    if (_currentInputView == _identifyInputView) {
        //    [_vertificationCodeInputView errorSMSAnim];
        //验证码成功,发送短信
        [_identifyView setHidden:YES];
        [_identifyInputView setHidden:YES];
        [_msgVerifyView setHidden:NO];
        [_msgInputView setHidden:NO];
        _currentInputView = _msgInputView;
        [_msgInputView becomeFirstResponder];
    }else if (_currentInputView == _msgInputView){
        //输入完成 设置登录密码
        [_msgVerifyView setHidden:YES];
        [_msgInputView setHidden:YES];
        if (_isResetPwdNextStep) {
            //请重置登录密码
            [_resetLoginPwdView setHidden:NO];
        }else{
            [_setLogPwdView setHidden:NO];
        }
    }
}

#pragma mark - 设置登录密码
- (void)setLoginPwd:(UIButton *)sender{
    
}

#pragma mark - 重置登录密码
- (void)confirmToModeifyPwd:(UIButton *)sender{
    
}
@end
