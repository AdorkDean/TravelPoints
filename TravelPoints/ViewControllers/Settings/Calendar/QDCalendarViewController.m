//
//  RangePickerViewController.m
//  FSCalendar
//
//  Created by dingwenchao on 5/8/16.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "QDCalendarViewController.h"
#import "FSCalendar.h"
#import "RangePickerCell.h"
#import "FSCalendarExtensions.h"
#import "QDCalendarTopView.h"
#import "QDDateUtils.h"
@interface QDCalendarViewController () <FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (weak, nonatomic) FSCalendar *calendar;
@property (nonatomic, strong) QDCalendarTopView *calendarTopView;
@property (weak, nonatomic) UILabel *eventLabel;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

// The start date of the range
@property (strong, nonatomic) NSDate *date1;
// The end date of the range
@property (strong, nonatomic) NSDate *date2;
// The start date of the range
@property (strong, nonatomic) NSString *date1Str;
// The end date of the range
@property (strong, nonatomic) NSString *date2Str;

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;

@end

@implementation QDCalendarViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)loadView
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.294, SCREEN_WIDTH, SCREEN_HEIGHT*0.586)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    self.view = view;
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.294, SCREEN_WIDTH, SCREEN_HEIGHT*0.586)];
    
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.pagingEnabled = NO;
    calendar.allowsMultipleSelection = YES;
    calendar.rowHeight = 40;
    calendar.placeholderType = FSCalendarPlaceholderTypeFillHeadTail;
    [view addSubview:calendar];
    self.calendar = calendar;
    
//    calendar.appearance.tit
    
    calendar.calendarHeaderView.backgroundColor = [UIColor redColor];
    calendar.appearance.titleDefaultColor = [UIColor blackColor];
    calendar.appearance.headerTitleColor = [UIColor blackColor];
    calendar.appearance.headerTitleFont = QDBoldFont(15);
    calendar.appearance.titleFont = [UIFont systemFontOfSize:15];
    calendar.weekdayHeight = 0;
    calendar.firstWeekday = 1;
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    calendar.swipeToChooseGesture.enabled = YES;
    calendar.appearance.headerDateFormat = @"yyyy-MM";
    calendar.today = nil; // Hide the today circle
    [calendar registerClass:[RangePickerCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)dismissVC:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _calendarTopView = [[QDCalendarTopView alloc] initWithFrame:CGRectMake(0, 0
                                                                           , SCREEN_WIDTH, SCREEN_HEIGHT*0.294)];
    
    [_calendarTopView.cancelBtn addTarget:self action:@selector(dismissVC:) forControlEvents:UIControlEventTouchUpInside];
    _calendarTopView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F7"];
    [self.view addSubview:_calendarTopView];
    //中国农历
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    //公历(常用)
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    // For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    confirmBtn.backgroundColor = APP_GREENCOLOR;
    [confirmBtn setTitle:@"选择此日期" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = QDFont(17);
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-(SCREEN_HEIGHT*0.03));
        make.width.mas_equalTo(SCREEN_WIDTH*0.89);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.075);
    }];
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    // 设置日期格式 为了转换成功
    NSString *currentDateStr = [QDDateUtils dateFormate:@"yyyy-MM-dd" WithDate:[NSDate date]];
    format.dateFormat = @"yyyy-MM-dd";
    return [format dateFromString:currentDateStr];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:10 toDate:[NSDate date] options:0];
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @"今天";
    }
    return nil;
}

//- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
//    return @"132123123";
//}
- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    RangePickerCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

#pragma mark - FSCalendarDelegate

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return NO;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSString *dateStr = [self.dateFormatter stringFromDate:date];
    NSLog(@"dateStr = %@", dateStr);

    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
//    NSString *ss = [self.dateFormatter stringFromDate:date];
//    NSLog(@"ss = %@", ss);
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];// 设置日期格式
//    format.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
//    format.dateFormat = @"yyyy-MM-dd";// NSString * ->
//    NSDate *currentData = [format dateFromString:ss];
    QDLog(@"currentData = %@",localeDate);
    if (calendar.swipeToChooseGesture.state == UIGestureRecognizerStateChanged) {
        // If the selection is caused by swipe gestures
        if (!self.date1) {
            self.date1 = localeDate;
            self.date1Str = dateStr;
        } else {
            if (self.date2) {
                [calendar deselectDate:self.date2];
            }
            self.date2 = localeDate;
            self.date2Str = dateStr;
        }
    } else {
        if (self.date2) {
            [calendar deselectDate:self.date1];
            [calendar deselectDate:self.date2];
            self.date1 = localeDate;
            self.date1Str = dateStr;
            self.date2 = nil;
        } else if (!self.date1) {
            self.date1 = localeDate;
            self.date1Str = dateStr;
        } else {
            self.date2 = localeDate;
            self.date2Str = dateStr;
        }
    }
    if (self.date1 != nil && self.date2 != nil) {
        QDLog(@"self.date1 = %@, self.date2 = %@", self.date1, self.date2);
        NSInteger aa = [QDDateUtils compareDate:[NSString stringWithFormat:@"%@", self.date1] withDate:[NSString stringWithFormat:@"%@", self.date2]];
        
        NSInteger i = [QDDateUtils getDaysFrom:self.date1 To:self.date2];
        NSInteger j = [QDDateUtils calcDaysFromBegin:self.date1 end:self.date2];
        QDLog(@"i = %ld, j = %ld", (long)i, (long)j);
        int totalDays = abs((int)j);
        
        _calendarTopView.totalDaysLab.text = [NSString stringWithFormat:@"%d晚", totalDays];
        NSString *str3 = [QDDateUtils weekdayStringFromDate:self.date1];
        NSString *str4 = [QDDateUtils weekdayStringFromDate:self.date2];
        QDLog(@"aa = %ld, str3 = %@, str4 = %@", (long)aa, str3, str4);
        if (aa > 0) {
            [_calendarTopView.roomInBtn setTitle:[NSString stringWithFormat:@"%@ %@", self.date1Str, str3] forState:UIControlStateNormal];
            [_calendarTopView.roomOutBtn setTitle: [NSString stringWithFormat:@"%@ %@", self.date2Str, str4] forState:UIControlStateNormal];
        }else if(aa < 0){
            [_calendarTopView.roomInBtn setTitle:[NSString stringWithFormat:@"%@ %@", self.date2Str, str4] forState:UIControlStateNormal];
            [_calendarTopView.roomOutBtn setTitle:[NSString stringWithFormat:@"%@ %@", self.date1Str, str3] forState:UIControlStateNormal];
        }
    }
    [self configureVisibleCells];
}




- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @[[UIColor orangeColor]];
    }
    return @[appearance.eventDefaultColor];
}

#pragma mark - Private methods

- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position
{
    RangePickerCell *rangeCell = cell;
    if (position != FSCalendarMonthPositionCurrent) {
        rangeCell.middleLayer.hidden = YES;
        rangeCell.selectionLayer.hidden = YES;
        return;
    }
    if (self.date1 && self.date2) {
        // The date is in the middle of the range
        BOOL isMiddle = [date compare:self.date1] != [date compare:self.date2];
        rangeCell.middleLayer.hidden = !isMiddle;
    } else {
        rangeCell.middleLayer.hidden = YES;
    }
    BOOL isSelected = NO;
    isSelected |= self.date1 && [self.gregorian isDate:date inSameDayAsDate:self.date1];
    isSelected |= self.date2 && [self.gregorian isDate:date inSameDayAsDate:self.date2];
    rangeCell.selectionLayer.hidden = !isSelected;
}


@end
