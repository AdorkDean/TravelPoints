//
//  QDServiceErrorHandler.m
//  QDINFI
//
//  Created by 冉金 on 2017/10/24.
//  Copyright © 2017年 quantdo. All rights reserved.
//

#import "QDServiceErrorHandler.h"
#import "QDLoginViewController.h"

@implementation QDServiceErrorHandler

+ (void)handleError:(NSInteger)errorCode
{
    __block NSString *errorMsg;
    NSDictionary *error = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QDError" ofType:@"plist"]];
    NSDictionary *serviceError = [error objectForKey:@"ServiceError"];
    if (serviceError) {
        [serviceError enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key integerValue] == errorCode && errorCode != 200) {
                errorMsg = [NSString stringWithFormat:@"%@", obj];
            }
        }];
    }
    if (errorMsg != nil) {
        if (errorCode == 100) {
            //未登录，跳转至登录页面
            QDLog(@"isLogon = %@", [QDUserDefaults getObjectForKey:@"isLogon"]);
            if ([QDUserDefaults getObjectForKey:@"isLogon"] == nil) {
                [QDUserDefaults setObject:@"0" forKey:@"isLogon"];
            }else{
                [QDUserDefaults setObject:@"0" forKey:@"isLogon"];
            }
        }else{
            NSString *errorString = [NSString stringWithFormat:@"Code:%ld, Msg:%@", errorCode, errorMsg];
            
        }
    }
//        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        QDLoginViewController *loginVC = [[QDLoginViewController alloc] init];
//        delegate.window.rootViewController = loginVC;
}

@end
