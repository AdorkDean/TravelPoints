//
//  DayCell.m
//  DFCalendar
//
//  Created by Macsyf on 16/12/7.
//  Copyright © 2016年 ZhouDeFa. All rights reserved.
//

#import "DayCell.h"

#define NormalColor [UIColor whiteColor]
#define StartAndEndColor [UIColor redColor]
#define SelectedColor [UIColor orangeColor]

@interface DayCell ()

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;

@property (nonatomic,strong)DayModel *model;

@end

@implementation DayCell

-(void)fullCellWithModel:(DayModel *)model
{
    _model = model;
    if (model == nil) {
        self.dayLabel.text = @"";
        self.colorView.backgroundColor = NormalColor;
    }
    if (model.day) {
        self.dayLabel.text = [NSString stringWithFormat:@"%02ld",model.day];
    }else{
        self.dayLabel.text = @"";
    }
    switch (model.state) {
        case DayModelStateNormal:
        {
            self.colorView.backgroundColor = NormalColor;
            self.dayLabel.textColor = [UIColor blackColor];
            self.actionLabel.text = [self lunarWith:model.dayDate];
            NSArray *arr = @[@"除夕",@"春节",@"元宵节",@"端午节",@"七夕节",@"中元节",@"中秋节",@"重阳节",@"腊八节",@"北方小年",@"南方小年"];
            BOOL isJieRi = NO;
            for (NSString *str  in arr) {
                if ([self.actionLabel.text isEqualToString:str]) {
                    isJieRi = YES;
                    break;
                }
            }
            if (isJieRi) {
                self.actionLabel.textColor = [UIColor colorWithRed:65/255.0 green:207/255.0 blue:246/255.0 alpha:1];
            }else{
                self.actionLabel.textColor = [UIColor blackColor];
            }
            
            
            NSString *jieRi = [self getJieJiaRiWith:model.dayDate string:self.actionLabel.text];
            if ([jieRi isEqualToString:self.actionLabel.text]) {
//                self.actionLabel.textColor = [UIColor blackColor];
            }else{
                self.actionLabel.textColor = [UIColor colorWithRed:65/255.0 green:207/255.0 blue:246/255.0 alpha:1];
            }
            self.actionLabel.text = jieRi;
            break;
        }
        case DayModelStateStart:
            self.colorView.backgroundColor = StartAndEndColor;
            self.dayLabel.textColor = [UIColor whiteColor];
            self.actionLabel.text = @"入住";
            self.actionLabel.textColor = [UIColor whiteColor];
            break;
        case DayModelStateEnd:
            self.colorView.backgroundColor = StartAndEndColor;
            self.dayLabel.textColor = [UIColor whiteColor];
            self.actionLabel.text = @"离店";
            self.actionLabel.textColor = [UIColor whiteColor];
            break;
        case DayModelStateSelected:
        {
            self.colorView.backgroundColor = SelectedColor;
            self.dayLabel.textColor = [UIColor whiteColor];
            self.actionLabel.text = [self lunarWith:model.dayDate];
            
//            NSArray *arr = @[@"除夕",@"春节",@"元宵节",@"端午节",@"七夕节",@"中元节",@"中秋节",@"重阳节",@"腊八节",@"北方小年",@"南方小年"];
//            BOOL isJieRi = NO;
//            for (NSString *str  in arr) {
//                if ([self.actionLabel.text isEqualToString:str]) {
//                    isJieRi = YES;
//                    break;
//                }
//            }
            self.actionLabel.textColor = [UIColor whiteColor];
//            if (isJieRi) {
//                self.actionLabel.textColor = [UIColor colorWithRed:65/255.0 green:207/255.0 blue:246/255.0 alpha:1];
//            }else{
//                self.actionLabel.textColor = [UIColor whiteColor];
//            }
            
            NSString *jieRi = [self getJieJiaRiWith:model.dayDate string:self.actionLabel.text];
//            if ([jieRi isEqualToString:self.actionLabel.text]) {
////                self.actionLabel.textColor = [UIColor blackColor];
//            }else{
//                self.actionLabel.textColor = [UIColor colorWithRed:0/255.0 green:207/255.0 blue:246/255.0 alpha:1];
//            }
            self.actionLabel.text = jieRi;
            break;
        }
        default:
            break;
    }

}

-(NSString *)getJieJiaRiWith:(NSDate *)date string:(NSString *)string
{
    if (date == nil) {
        return string;
    }
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; //获得系统的时区
    
    NSTimeInterval time = [zone secondsFromGMTForDate:date];//以秒为单位返回当前时间与系统格林尼治时间的差
    
    NSDate *toDayDate = [date dateByAddingTimeInterval:time];//然后把差的时间加上,就是当前系统准确的时间
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:toDayDate];
//    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    if (month == 1 && day == 1) {
        return @"元旦节";
    }
    if (month == 2 && day == 14) {
        return @"情人节";
    }
    if (month == 3 && day == 8) {
        return @"妇女节";
    }
    if (month == 3 && day == 12) {
        return @"植树节";
    }
    if (month == 4 && day == 1) {
        return @"愚人节";
    }
    if (month == 4 && day == 5) {
        return @"清明节";
    }
    if (month == 5 && day == 1) {
        return @"劳动节";
    }
    if (month == 5 && day == 4) {
        return @"青年节";
    }
    if (month == 5 && day == 12) {
        return @"护士节";
    }

    if (month == 6 && day == 1) {
        return @"儿童节";
    }
    if (month == 7 && day == 1) {
        return @"建党节";
    }
    if (month == 8 && day == 1) {
        return @"建军节";
    }
    if (month == 9 && day == 10) {
        return @"教师节";
    }
    if (month == 10 && day == 1) {
        return @"国庆节";
    }
    if (month == 11 && day == 11) {
        return @"光棍节";
    }
    if (month == 12 && day == 24) {
        return @"平安夜";
    }
    if (month == 12 && day == 25) {
        return @"圣诞节";
    }
    return string;
}



-(NSString *)lunarWith:(NSDate *)date
{
//    NSLog(@"%@",date);
    if (date == nil) {
        return @"";
    }
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; //获得系统的时区
    
    NSTimeInterval time = [zone secondsFromGMTForDate:date];//以秒为单位返回当前时间与系统格林尼治时间的差
    
    NSDate *toDayDate = [date dateByAddingTimeInterval:time];//然后把差的时间加上,就是当前系统准确的时间
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:toDayDate];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSDictionary *lunarDic = [self LunarForSolarYear:(int )year Month:(int )month Day:(int )day];
    
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"腊月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"三十"]) {
        return @"除夕";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"正月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"初一"]) {
        return @"春节";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"正月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"十五"]) {
        return @"元宵节";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"五月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"初五"]) {
        return @"端午节";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"七月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"初七"]) {
        return @"七夕节";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"七月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"十五"]) {
        return @"中元节";
    }
    
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"八月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"十五"]) {
        return @"中秋节";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"九月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"初九"]) {
        return @"重阳节";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"腊月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"初八"]) {
        return @"腊八节";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"腊月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"廿三"]) {
        return @"北方小年";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"腊月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"廿四"]) {
        return @"南方小年";
    }
    
    if ([[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"初一"]) {
        return [lunarDic objectForKey:@"szNongliMonth"];
    }
    return [lunarDic objectForKey:@"szNongliDay"];
    
}






-(NSDictionary *)LunarForSolarYear:(int)wCurYear Month:(int)wCurMonth Day:(int)wCurDay{

    //农历日期名
    NSArray *cDayName =  [NSArray arrayWithObjects:@"*",
                          @"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                          @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                          @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",
                          nil];
    
    //农历月份名
    NSArray *cMonName =  [NSArray arrayWithObjects:@"*",@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"腊月",nil];
    
    //公历每月前面的天数
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
        
        ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
        
        ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
        
        ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
        
        ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
        
        ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
        
        ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
        
        ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
        
        ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
        
        ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    
    static int nTheDate,nIsEnd,m,k,n,i,nBit;
    
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
    
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    
    nIsEnd = 0;
    
    m = 0;
    
    while(nIsEnd != 1)
        
    {
        
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0)
        {
            //获取wNongliData(m)的第n个二进制位的值
            
            nBit = wNongliData[m];
            
            for(i=1;i < n+1;i++)
                
                nBit = nBit/2;
            
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit))
            {
                nIsEnd = 1;
                break;
            }
            
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        
        if(nIsEnd)
            
            break;
        
        m = m + 1;
        
    }
    
    wCurYear = 1921 + m;
    
    wCurMonth = k - n + 1;
    
    wCurDay = nTheDate;
    
    if (k == 12)
        
    {
        
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            
            wCurMonth = 1 - wCurMonth;
        
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            
            wCurMonth = wCurMonth - 1;
        
    }
    
    
    //生成农历月
    
    NSString *szNongliMonth;
    
    if (wCurMonth < 1){
        
        szNongliMonth = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
        
    }else{
        szNongliMonth = (NSString *)[cMonName objectAtIndex:wCurMonth];
    }
    
    //生成农历日
    NSString *szNongliDay = [cDayName objectAtIndex:wCurDay];
    
    //合并
    
//    NSString *lunarDate = [NSString stringWithFormat:@"%@-%@",szNongliMonth,szNongliDay];
//    return lunarDate;
    
    NSMutableDictionary *lunarDateDic = [[NSMutableDictionary alloc]init];
    [lunarDateDic setValue:szNongliMonth forKey:@"szNongliMonth"];
    [lunarDateDic setValue:szNongliDay forKey:@"szNongliDay"];
    
    return lunarDateDic;
    
}



-(void)setTodayText:(BOOL )isHaveToday
{
    if (isHaveToday) {
        self.dayLabel.text = @"今天";
        self.dayLabel.textColor = [UIColor orangeColor];
        self.actionLabel.textColor = [UIColor orangeColor];
        if (self.model) {
            if (self.model.state == DayModelStateStart) {
                self.dayLabel.textColor = [UIColor whiteColor];
                self.actionLabel.textColor = [UIColor whiteColor];
            }else{
                self.dayLabel.textColor = [UIColor orangeColor];
                self.actionLabel.textColor = [UIColor orangeColor];
            }
        }
    }else if(self.model){
        [self fullCellWithModel:self.model];
    }else{
        self.dayLabel.text = @"";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.colorView.layer.cornerRadius = 4;
    self.colorView.layer.masksToBounds = YES;
    self.actionLabel.adjustsFontSizeToFitWidth = YES;
}

@end
