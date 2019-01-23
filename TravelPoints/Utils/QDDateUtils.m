//
//  QDDateUtils.m
//  WXIOS
//
//  Created by 🐟猛 on 2018/7/28.
//  Copyright © 2018年 quantdo. All rights reserved.
//

#import "QDDateUtils.h"

@implementation QDDateUtils

+ (NSDateComponents*)dateComponentsWithDate:(NSDate*)date{
    NSDate *currentDate = date == nil ?  [NSDate date] : date;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
    return components;
}


+ (NSDateComponents*)dateComponentsWithTime:(NSString*)time{
    NSDate *date = [QDDateUtils getDateFromString:time format:@"yyyyMMddHH:mm:ss"] ;
    NSDate *currentDate = date == nil ?  [NSDate date] : date;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    return components;
}

+ (BOOL)isValidDate:(NSString *)time{
    return (long)[[QDDateUtils dateComponentsWithTime:time] year]  > 1970;
}


+ (NSString*)today{
    NSDateComponents *components = [self dateComponentsWithDate:[NSDate date]];
    return [NSString stringWithFormat:@"today=%ld",(long)[components day]];
}


+ (NSString*)tomorrow{
    int tomorrowTime = [[NSDate date] timeIntervalSince1970]+60*60*24;
    NSDate *tomorrowDate = [NSDate dateWithTimeIntervalSince1970:tomorrowTime];
    NSDateComponents *components = [self dateComponentsWithDate:tomorrowDate];
    return [NSString stringWithFormat:@"today=%ld",(long)[components day]];
}

/**
 *  格式化时间
 *
 *  @param formate 格式化的规则
 *  @param date    时间
 *
 *  @return 字符串类型的时间
 */
+(NSString*)dateFormate:(NSString*)formateStr WithDate:(NSDate*)date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formateStr];
    return [dateFormat stringFromDate:date];
}

/**
 *  将字符串时间转成NSDate
 *
 *  @param pstrDate 字符串时间
 *  @paramformat@"yyyy-MM-dd'T'HH:mm:ssZ"
 */
+(NSDate *)getDateFromString:(NSString *)pstrDate format:(NSString*)format{
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:format];
    NSDate *dtPostDate = [df1 dateFromString:pstrDate];
    return dtPostDate;
}


/**
 *  java时间戳格式化
 *
 */
+(NSString*)javaTimestamp:(NSString*)timestamp format:(NSString*)format{
    if (timestamp == nil || [timestamp isKindOfClass:[NSNull class]]||[timestamp doubleValue] == 0) {
        return @"";
    }
    double t = timestamp.doubleValue/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    return [QDDateUtils dateFormate:format WithDate:date];
}

+ (NSString *)getTimestamp:(NSString *)stringTime format:(NSString *)format {

    NSString *timeStamp = [QDDateUtils getSeconds:stringTime format:format];

    return [NSString stringWithFormat:@"%.f", [timeStamp doubleValue] * 1000.0];
}


+ (NSString*)getSeconds:(NSString *)stringTime format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:stringTime];
    double timeStamp = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.f", timeStamp];
}


/**
 *  当期时间和给定的java时间相差天数
 *
 *  @param javaDate java类型时间戳
 */
+(long)dayDiffrentNowBetweenWithJavaDate:(double)javaDate{
    float aDay = 86400.0;//60*60*24;
    
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:javaDate/1000.0];
    NSDate *date2 =  [NSDate date];
    NSString *formate = @"yyyy-MM-dd";
    NSString *ymd1= [QDDateUtils dateFormate:formate WithDate:date1];
    NSString *ymd2= [QDDateUtils dateFormate:formate WithDate:date2];
    
    NSTimeInterval time1 = [[QDDateUtils getDateFromString:ymd1 format:formate] timeIntervalSince1970];
    NSTimeInterval time2 = [[QDDateUtils getDateFromString:ymd2 format:formate] timeIntervalSince1970];
    
    CGFloat days = (time1-time2)/aDay;
    int absDay = ceil(ABS(days));
    
    if (days > 0) {
        return absDay;
    }else{
        return -absDay;
    }
}


//@"yyyyMMdd HH:mm:ss"
+ (NSString *)getSecondsWithTradingDay:(NSString *)tradingDay andTime:(NSString *)time{
    NSString *dateString = [NSString stringWithFormat:@"%@ %@",tradingDay,time];
    return [QDDateUtils getSeconds:dateString format:@"yyyyMMdd HH:mm:ss"];
}

+ (NSString *)noSecondsTime:(NSString *)completeTime{
   NSMutableArray *array = [[completeTime componentsSeparatedByString:@":"] mutableCopy];
    
    if (array.count == 3) {
        [array replaceObjectAtIndex:2 withObject:@"00"];
    }
    NSLog(@"%@",[array componentsJoinedByString:@":"]) ;
    return [array componentsJoinedByString:@":"];
}

+ (double)oneHoursSeconds{
    return 3600;
}

+ (double)oneDaySeconds{
    return [QDDateUtils oneHoursSeconds] * 24;
}

+ (double)oneWeekSeconds{
    return [QDDateUtils oneDaySeconds] * 7;
}


+ (NSString *)getTimeWithSeconds:(double)seconds{
    return [QDDateUtils javaTimestamp:[NSString stringWithFormat:@"%@", @(seconds * 1000)] format:@"HH:mm:ss"];
    
}


@end
