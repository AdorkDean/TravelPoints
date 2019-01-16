//
//  QDIdentifyViewController.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/15.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDIdentifyViewController.h"
#import "IdentifyView.h"
@interface QDIdentifyViewController (){
    IdentifyView *_identifyView;
}

@end

@implementation QDIdentifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _identifyView = [[IdentifyView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
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
