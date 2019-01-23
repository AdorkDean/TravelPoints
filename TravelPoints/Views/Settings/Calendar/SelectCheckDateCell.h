//
//  SelectCheckDateCell.h
//  DFCalendar
//
//  Created by Macsyf on 16/12/7.
//  Copyright © 2016年 ZhouDeFa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MouthModel.h"

typedef void(^SelectedDay)(NSInteger day);

@interface SelectCheckDateCell : UITableViewCell

-(void)fullCellWithModel:(MouthModel *)model;

@property(nonatomic,copy)SelectedDay selectedDay;

-(void)selectedDay:(SelectedDay)selectedDay;

-(void)setToday:(BOOL )isToday;

@end
