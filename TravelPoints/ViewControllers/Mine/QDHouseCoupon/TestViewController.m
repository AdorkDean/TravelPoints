/*
 **
 * @file: ViewController
 * @brief:视图控制器
 * Copyright: Copyright © 2018
 * Company:岚家小红担
 * @author: 岚家小红担
 * @version: V1.0
 * @date: 2018-10-17
 **/

#import "TestViewController.h"
#import "closeCell.h"
#import "openCell.h"
#import "openOrCloseModel.h"
#import "BaseCell.h"
@interface TestViewController ()<UITableViewDelegate,UITableViewDataSource,BaseCellDelegate>
/**
 主tableview
 */
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger isOpen;

@property (nonatomic,assign) NSInteger cellIndex;

@property (nonatomic,strong) NSMutableArray *StatusArray;


@end

@implementation TestViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APP_WHITECOLOR;
    [self.view addSubview:self.tableView];
}

#pragma mark lazy
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = 0;
        
        
    }
    return _tableView;
}


- (NSMutableArray *)StatusArray{
    if (!_StatusArray) {
        _StatusArray = [NSMutableArray array];
    }
    return _StatusArray;
    
}

#pragma mark dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseCell *cell = nil;
    //如果有网络请求数据，更改model
    openOrCloseModel *model = nil;
    cell.userInteractionEnabled = YES;
    NSString *cellIdentifier;
    
    NSString *row = [NSString stringWithFormat:@"%ld",indexPath.row];
    //是用来判断有没用被打开// YES (BOOL)1// NO  (BOOL)0
    BOOL isbool = [self.StatusArray containsObject: row];
    if (isbool == NO){
        
        cellIdentifier = @"unOpen";
        
    }else{
        
        cellIdentifier = @"open";
        
    }
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        if (isbool == NO){
            
            cell = [[closeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }else{
            
            cell = [[openCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }
    else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.delegate = self;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setView:model];
    cell.index = (int)indexPath.row;
    
    cell.indexArr = self.StatusArray;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *row = [NSString stringWithFormat:@"%ld",indexPath.row];
    BOOL isbool = [self.StatusArray containsObject: row];
    if (isbool == NO){
        return 136+30;
    }else{
        return 176+30;
    }
    return indexPath.row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
    
}


/**
 卡片上按钮的点击事件
 
 @param baseCell 点击的cell
 @param btnType 按钮的状态
 @param index 点的是哪一个按钮
 */
- (void)baseCell:(BaseCell *)baseCell btnType:(BtnType)btnType WithIndex:(int)index withArr:(nonnull NSMutableArray *)array{
    
    self.isOpen = btnType;
    self.cellIndex = index;
    self.StatusArray = array;
    
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    
}

@end
