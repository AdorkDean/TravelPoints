//
//  QDRestaurantViewCell.h
//  TravelPoints
//
//  Created by 冉金 on 2019/1/19.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTravelDTO.h"
#import "AppDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface QDRestaurantViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *thePic;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *ftLab;
@property (nonatomic, strong) UILabel *rmbLab;

-(void)fillContentWithModel:(CustomTravelDTO *)infoModel andImgData:(NSData *)imgData;

@end

NS_ASSUME_NONNULL_END
