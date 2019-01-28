//
//  QDHotelTableViewCell.h
//  TravelPoints
//
//  Created by 冉金 on 2019/1/17.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDHotelListInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QDHotelTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *hotelImg;
@property (nonatomic, strong) UILabel *hotelName;
@property (nonatomic, strong) UILabel *starLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *priceRMBLab;
@property (nonatomic, strong) UILabel *locationLab;


-(void)fillContentWithModel:(QDHotelListInfoModel *)infoModel andImgData:(NSData *)imgData;
@end

NS_ASSUME_NONNULL_END
