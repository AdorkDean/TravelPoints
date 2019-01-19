//
//  SYSearchController.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/19.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "SYSearchController.h"

@interface SYSearchController ()

@end

@implementation SYSearchController
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2];
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)]];
        _maskView.hidden = YES;
    }
    return _maskView;
}

- (void)cancelKeyboard {
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.hidden = YES;
    }];
}

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController {
    if (self = [super initWithSearchResultsController:searchResultsController]) {
        self.hidesNavigationBarDuringPresentation = YES;
        self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x, self.searchBar.frame.origin.y, self.searchBar.frame.size.width, 44.0);
        self.searchBar.placeholder = @"输入城市名或者拼音查询";
        self.searchBar.returnKeyType = UIReturnKeyDone;
        //        self.searchBar.layer.cornerRadius = 15;
        //        self.searchBar.layer.masksToBounds = YES;
        //        [self.searchBar.layer setBorderWidth:8];
        //        UITextField *tf = [[self.searchBar.subviews.firstObject subviews] lastObject];
        //        tf.backgroundColor = SYBackgroundColor;
        //        [self.searchBar.layer setBorderColor:SYBackgroundColor.CGColor];
        //        self.searchBar.returnKeyType = UIReturnKeyDone;
        self.searchResultsController.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
        if ([searchResultsController isKindOfClass:[UITableViewController class]]) {
            UITableViewController *tb = (UITableViewController *)searchResultsController;
            tb.tableView.delegate = self;
            tb.tableView.dataSource = self;
        }
        [self.view addSubview:self.maskView];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *resultId = @"SYResultID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:resultId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resultId];
    }
    cell.textLabel.text = self.results[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.resultDelegate respondsToSelector:@selector(resultViewController:didSelectFollowCity:)]) {
        [self.resultDelegate resultViewController:self didSelectFollowCity:self.results[indexPath.row]];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

@end
