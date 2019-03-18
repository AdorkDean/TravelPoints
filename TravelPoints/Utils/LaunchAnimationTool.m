//
//  LaunchAnimationTool.m
//  AppLaunchScreenAnimation
//
//  Created by 孙金帅 on 16/5/30.
//  Copyright © 2016年 com.51fanxing. All rights reserved.
//

#import "LaunchAnimationTool.h"

static NSInteger const imageViewsborderOffset = 150;
// 屏幕尺寸
#define FXScreenBounds [UIScreen mainScreen].bounds
#define FXScreenSize [UIScreen mainScreen].bounds.size
#define FXScreenWidth [UIScreen mainScreen].bounds.size.width
#define FXScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation LaunchAnimationTool

+ (void)showLaunchAnimationViewToWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
//    UIView *launchView = [[NSBundle mainBundle] loadNibNamed:@"LaunchImage" owner:nil options:nil].firstObject;
//    launchView.frame = FXScreenBounds;
    
//    [window addSubview:launchView];
    UIImageView *backGroundImageView = [[UIImageView alloc] initWithFrame:FXScreenBounds];
    backGroundImageView.image = [UIImage imageNamed:@"emptySource"];
    
    backGroundImageView.frame = CGRectMake(-imageViewsborderOffset,0,FXScreenWidth + (imageViewsborderOffset),FXScreenHeight);
    
    backGroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backGroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backGroundImageView.alpha = 1;
    [window addSubview:backGroundImageView];

    [UIView animateWithDuration:1.8f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear animations:^{
        
        backGroundImageView.alpha = 0.5;
        
    } completion:^(BOOL finished) {
        
//        [window removeFromSuperview];

    }];
}

@end
