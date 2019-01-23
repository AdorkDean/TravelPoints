//
//  HYCalendarCollectionViewCell.m
//  HYCalendar
//
//  Created by 王厚一 on 16/11/14.
//  Copyright © 2016年 why. All rights reserved.
//

#import "HYCalendarCollectionViewCell.h"


@implementation HYCalendarCollectionViewCell

- (void)drawRect:(CGRect)rect {
    self.day.font = [UIFont systemFontOfSize:16];
    self.status.font = [UIFont systemFontOfSize:12];
    
    //当形状为圆形时更换frame
    if (self.type == HYCalendarItemTypeRectAlone || self.type == HYCalendarItemTypeRectCollected) {
        
        CGRect rect = CGRectMake((CGRectGetWidth(self.day.frame) - 32) / 2.0, (CGRectGetHeight(self.day.frame) - 32) / 2.0, 32, 32);
        self.day.layer.cornerRadius = 16;
        self.day.layer.masksToBounds = YES;
        self.day.frame = rect;
    }
    
}

- (void)reloadCellWithFirstDay:(NSArray *)firstDay andLastDay:(NSArray *)lastDay andCurrentDay:(NSArray *)currentDay andSelectedColor:(UIColor *)selectedColor andNormalColor:(UIColor *)normalColor andMiddleColor:(UIColor *)middleColor {
    
    //当前日期小于1,隐藏
    if ([currentDay[2] integerValue] > 0) {
        self.hidden = NO;
    }else {
        self.hidden = YES;
    }
    
    //当图形是圆形时状态标签换颜色
    self.status.textColor = self.type == HYCalendarItemTypeRectCollected || self.type == HYCalendarItemTypeRectAlone ? selectedColor : normalColor;
    
    if (firstDay.count == 0) {//数据中没有数据则颜色全部初始化
        self.day.backgroundColor = normalColor;
        self.day.textColor = [UIColor blackColor];
        self.status.text = @"";
    }else if (lastDay.count == 0) {//当只有一个出发时间时，等于当前时间则变色，否则初始颜色
        if ([firstDay isEqual:currentDay]) {
            self.day.backgroundColor = selectedColor;
            self.day.textColor = [UIColor whiteColor];
            self.status.text = @"出发";
        }else {
            self.day.backgroundColor = normalColor;
            self.day.textColor = [UIColor blackColor];
            self.status.text = @"";
        }
    }else {//当出发和返回都是当前时间，说明两次点击同一个，否则出发和返回各不同，如果都不同则没状态表示
        if ([firstDay isEqual:currentDay]) {
            if ([lastDay isEqual:currentDay]) {
                self.day.backgroundColor = selectedColor;
                self.day.textColor = [UIColor whiteColor];
                self.status.text = @"出发 返回";
            }else {
                self.day.backgroundColor = selectedColor;
                self.day.textColor = [UIColor whiteColor];
                self.status.text = @"出发";
            }
        }else {
            if ([lastDay isEqual:currentDay]) {
                self.day.backgroundColor = selectedColor;
                self.day.textColor = [UIColor whiteColor];
                self.status.text = @"返回";
            }else {
                self.day.backgroundColor = normalColor;
                self.day.textColor = [UIColor blackColor];
                self.status.text = @"";
            }
        }
        
        //当不需要连接色时返回
        if (self.type == HYCalendarItemTypeRectAlone || self.type == HYCalendarItemTypeSquartAlone) {
            return;
        }
        
        NSInteger currentTime = [currentDay[0] integerValue] * 12 + [currentDay[1] integerValue] * 31 + [currentDay[2] integerValue];
        NSInteger firstTime = [firstDay[0] integerValue] * 12 + [firstDay[1] integerValue] * 31 + [firstDay[2] integerValue];
        NSInteger lastTime = [lastDay[0] integerValue] * 12 + [lastDay[1] integerValue] * 31 + [lastDay[2] integerValue];
        
        //中间色的出现情况为当前时间在出发和返回时间之间
        if ((currentTime < firstTime && currentTime > lastTime) || (currentTime > firstTime && currentTime < lastTime)) {
            self.day.backgroundColor = middleColor;
            self.day.textColor = [UIColor whiteColor];
            self.status.text = @"";
        }
        
    }
    
}

@end
