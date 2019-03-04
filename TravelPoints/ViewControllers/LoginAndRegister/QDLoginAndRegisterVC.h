//
//  QDLoginAndRegisterVC.h
//  TravelPoints
//
//  Created by 冉金 on 2019/1/15.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"
#import "YYLabel.h"
#import "QDLoginView.h"
#import "QDRegisterView.h"
#import "IdentifyView.h"
#import "VertificationCodeInputView.h"
#import "QDMsgVerifyView.h"
#import "QDSetLoginPwdView.h"
#import "QDForgetPwdView.h"
#import "QDResetLoginPwdView.h"
NS_ASSUME_NONNULL_BEGIN

@interface QDLoginAndRegisterVC : UIViewController{
    QDLoginView *_loginView;
    QDRegisterView *_registerView;
    IdentifyView *_identifyView;
    UIView *_view;
    VertificationCodeInputView *_currentInputView;  //短信验证码
    VertificationCodeInputView *_identifyInputView; //身份验证
    VertificationCodeInputView *_msgInputView;      //短信验证码
    QDMsgVerifyView *_msgVerifyView;
    QDSetLoginPwdView *_setLogPwdView;
    QDForgetPwdView *_forgetPwdView;
    QDResetLoginPwdView *_resetLoginPwdView;
}

//取消&&登录&&注册按钮
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) YYLabel *yyLabel;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL isResetPwdNextStep;

@end

NS_ASSUME_NONNULL_END
