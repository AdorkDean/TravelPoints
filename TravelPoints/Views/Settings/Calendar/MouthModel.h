//
//  MouthModel.h
//  DFCalendar
//
//  Created by Macsyf on 16/12/7.
//  Copyright © 2016年 ZhouDeFa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DayModelStateNormal = 0,
    DayModelStateStart,
    DayModelStateEnd,
    DayModelStateSelected,
} DayModelState;




typedef enum : NSUInteger {
    Sunday = 1,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
} DayModelOfTheWeek;


@interface DayModel : NSObject

@property(nonatomic,assign)NSInteger day;
@property(nonatomic,assign)DayModelState state;
@property(nonatomic,assign)DayModelOfTheWeek dayOfTheWeek;
@property(nonatomic,strong)NSDate *dayDate;

@end






@interface MouthModel : NSObject


@property(nonatomic,assign)NSInteger year;
@property(nonatomic,assign)NSInteger mouth;
@property(nonatomic,strong)NSArray<DayModel *> * days;
@property(nonatomic,assign)CGFloat cellHight;


@end
