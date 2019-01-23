//
//  QDHotelVC.h
//  TravelPoints
//
//  Created by 冉金 on 2019/1/17.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDSegmentControl.h"
NS_ASSUME_NONNULL_BEGIN

@interface QDHotelVC : UIViewController

@property (nonatomic, strong) QDSegmentControl *segmentControl;

@property (nonatomic, strong) NSArray * firstDate;

@property (nonatomic, strong) NSArray * lastDate;

@property (nonatomic, strong) NSArray * singleDate;


@end

NS_ASSUME_NONNULL_END
