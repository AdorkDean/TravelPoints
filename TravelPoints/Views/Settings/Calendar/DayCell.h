//
//  DayCell.h
//  DFCalendar
//
//  Created by Macsyf on 16/12/7.
//  Copyright © 2016年 ZhouDeFa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MouthModel.h"

@interface DayCell : UICollectionViewCell



-(void)fullCellWithModel:(DayModel *)model;

-(void)setTodayText:(BOOL )isHaveToday;

@end
