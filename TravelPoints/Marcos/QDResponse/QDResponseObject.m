//
//  QDResponseObject.m
//  QDINFI
//
//  Created by ZengTark on 2017/10/24.
//  Copyright © 2017年 quantdo. All rights reserved.
//

#import "QDResponseObject.h"

@implementation QDResponseObject

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *dataString = dic[@"data"];
    if (![dataString isKindOfClass:[NSString class]] || [dataString isEqualToString:@""])
    {
        _data = @{};
        return YES;
    }
    NSData *jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id dataDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        QDLog(@"YYModel——JSON类型{data}转换失败");
        _data = @{};
        return YES;
    }
    _data = dataDict;
    return YES;
}

@end
