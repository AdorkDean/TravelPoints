//
//  SelectCheckDateCell.m
//  DFCalendar
//
//  Created by Macsyf on 16/12/7.
//  Copyright © 2016年 ZhouDeFa. All rights reserved.
//

#import "SelectCheckDateCell.h"
#import "DayCell.h"

@interface SelectCheckDateCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)UILabel *dateLabel;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,assign)NSInteger count;

@property(nonatomic,assign)BOOL isHaveToday;

@end

@implementation SelectCheckDateCell

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array ];
    }
    return _dataArray;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 9)];
        lineView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
        [self addSubview:lineView];
        
//        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 48  )];
//        _dateLabel.textAlignment = NSTextAlignmentCenter;
//        _dateLabel.font = [UIFont systemFontOfSize:20];
//        [self addSubview:_dateLabel];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 59, [UIScreen mainScreen].bounds.size.width, 1)];
        lineView1.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:lineView1];
        
        _count = 0;
        [self addSubview:self.collectionView];
    }
    return self;
}







-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 500) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces = NO;
        _collectionView.scrollEnabled = NO;
//        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];

        [_collectionView registerNib:[UINib nibWithNibName:@"DayCell" bundle:nil] forCellWithReuseIdentifier:@"DayCell"];
        
    }
    return _collectionView;
}

-(void)fullCellWithModel:(MouthModel *)model
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frame = self.collectionView.frame;
        frame.size.height = model.cellHight - 60;
        self.collectionView.frame = frame;
    });
//    self.dateLabel.text = [NSString stringWithFormat:@"%04ld年%02ld月",model.year ,model.mouth];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    DayModel *m = model.days.firstObject;
    
    
    if (m.dayOfTheWeek == 1) {
        _count = 6;
    }else{
        _count =  m.dayOfTheWeek - 2;
    }
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:model.days];
    [self.collectionView reloadData];
}

-(void)setToday:(BOOL )isToday
{
    _isHaveToday = isToday;
    [self.collectionView reloadData];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    _isHaveToday = NO;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ((self.dataArray.count + _count)%7 == 0) {
        return (self.dataArray.count + _count) / 7 * 7;
    }
    
    return ((self.dataArray.count + _count)/7 + 1)*7;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayCell" forIndexPath:indexPath];
    
    if (indexPath.row < _count || indexPath.row >= self.dataArray.count + _count) {
        [cell fullCellWithModel:nil];
    }else{
        DayModel *m = self.dataArray[indexPath.row - _count];
        [cell fullCellWithModel:m];
    }
    
    if (_isHaveToday && indexPath.row == _count) {
        [cell setTodayText:YES];
    }else{
        [cell setTodayText:NO];

    }

    
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

-(CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 16)/7, 60);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row < _count || indexPath.row >= self.dataArray.count + _count) {
        return ;
        
    }else{
        DayModel *m = self.dataArray[indexPath.row - _count];
        if (self.selectedDay) {
            self.selectedDay(m.day);
        }
    }
    
}

-(void)selectedDay:(SelectedDay)selectedDay
{
    _selectedDay = selectedDay;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
