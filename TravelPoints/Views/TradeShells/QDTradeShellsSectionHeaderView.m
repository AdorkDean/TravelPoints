//
//  QDTradeShellsSectionHeaderView.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/15.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDTradeShellsSectionHeaderView.h"
#import "UIButton+ImageTitleStyle.h"
static char *const btnKey = "btnKey";

@interface QDTradeShellsSectionHeaderView()
{
    BOOL show;
}

@end

@implementation QDTradeShellsSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _amountBtn = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
        [_amountBtn setImage:[UIImage imageNamed:@"icon_shellDefault"] forState:UIControlStateNormal];
        [_amountBtn setTitle:@"数量" forState:UIControlStateNormal];
        [_amountBtn setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
        _amountBtn.titleLabel.font = QDFont(13);
        _amountBtn.tag = 101;
        [_amountBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_amountBtn];
        objc_setAssociatedObject(_amountBtn, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);

        _priceBtn = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
        [_priceBtn setImage:[UIImage imageNamed:@"icon_shellDefault"] forState:UIControlStateNormal];
        [_priceBtn setTitle:@"价格" forState:UIControlStateNormal];
        [_priceBtn setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
        _priceBtn.titleLabel.font = QDFont(13);
        _priceBtn.tag = 102;
        [_priceBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_priceBtn];
        objc_setAssociatedObject(_priceBtn, btnKey, @"2", OBJC_ASSOCIATION_ASSIGN);
        
        _filterBtn = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
        [_filterBtn setImage:[UIImage imageNamed:@"icon_filter"] forState:UIControlStateNormal];
        _filterBtn.titleLabel.font = QDFont(13);
        _filterBtn.tag = 103;
        [_filterBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [_filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
        [_filterBtn setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
        [self addSubview:_filterBtn];
    }
    return self;
}

- (void)selectClick:(UIButton *)btn{
//    if (btn.tag == 101) {
//        btn.selected = YES;
//        UIButton *button = [self viewWithTag:102];
//        button.selected = NO;
//    }
//    if (btn.tag == 102) {
//        btn.selected = YES;
//        UIButton *button = [self viewWithTag:101];
//        button.selected = NO;
//    }
//    if (btn.tag != 103) {//没点击全部分类，则让其他按钮回复默认状态
//        for (int i = 1; i<3 ;i++) {
//            UIButton *button = [self viewWithTag:i+100];
//            button.selected = NO;
//        }
//        btn.selected = YES;
//        [self toggleViewWith:nil];
//    }else{//当点击全部分类按钮，则
//
//        [self toggleViewWith:btn];
//    }
    
    
    ButtonClickType type = ButtonClickTypeNormal;
    
    if (btn.tag == 101) {
        [_priceBtn setImage:[UIImage imageNamed:@"icon_shellDefault"] forState:UIControlStateNormal];
        NSString *flag = objc_getAssociatedObject(btn, btnKey);
        if ([flag isEqualToString:@"1"]) {  //是数量按钮
            [btn setImage:[UIImage imageNamed:@"icon_shellpositive"] forState:UIControlStateNormal];
            objc_setAssociatedObject(btn, btnKey, @"2", OBJC_ASSOCIATION_ASSIGN);
            type = ButtonClickTypeUp;
            QDLog(@"priceUp");
        }else if ([flag isEqualToString:@"2"]){
            [btn setImage:[UIImage imageNamed:@"icon_shellreverse"] forState:UIControlStateNormal];
            objc_setAssociatedObject(btn, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
            type = ButtonClickTypeDown;
            QDLog(@"priceDown");
        }
    }else if (btn.tag == 102){
        [_amountBtn setImage:[UIImage imageNamed:@"icon_shellDefault"] forState:UIControlStateNormal];
        NSString *flag = objc_getAssociatedObject(btn, btnKey);
        if ([flag isEqualToString:@"1"]) {
            [btn setImage:[UIImage imageNamed:@"icon_shellpositive"] forState:UIControlStateNormal];
            objc_setAssociatedObject(btn, btnKey, @"2", OBJC_ASSOCIATION_ASSIGN);
            type = ButtonClickTypeUp;
            QDLog(@"amountUp");

        }else if ([flag isEqualToString:@"2"]){
            [btn setImage:[UIImage imageNamed:@"icon_shellreverse"] forState:UIControlStateNormal];
            objc_setAssociatedObject(btn, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
            type = ButtonClickTypeDown;
            QDLog(@"amountDown");
        }
    }else{
        //点击全部不复位价格
        if (btn.tag != 103) {
            UIButton *button = [self viewWithTag:102];
            [button setImage:[UIImage imageNamed:@"icon_shellDefault"] forState:UIControlStateNormal];
            objc_setAssociatedObject(button, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
            type = ButtonClickTypeNormal;
        }
    }
    
    
    if ([self.delegate respondsToSelector:@selector(selectTopButton:withIndex:withButtonType:)]) {
        [self.delegate selectTopButton:self withIndex:btn.tag withButtonType:type];
    }
}
- (void)toggleViewWith:(UIButton *)btn{
    
    if (!btn) {
        btn = [self viewWithTag:103];
        if (show) {
            show = NO;
        }else{
            return;
        }
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [_amountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.05);
        make.width.and.height.mas_equalTo(60);
    }];
    
    [_priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.25);
        make.width.and.height.mas_equalTo(60);
    }];
    
    [_filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.81);
        make.width.and.height.mas_equalTo(60);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self toggleViewWith:nil];
}
@end
