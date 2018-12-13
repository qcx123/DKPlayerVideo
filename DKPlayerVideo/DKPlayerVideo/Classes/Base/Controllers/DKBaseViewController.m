//
//  DKBaseViewController.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/13.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKBaseViewController.h"
#import <Masonry.h>

@interface DKBaseViewController ()
/**
 是否登录
 */
@property (nonatomic, assign) BOOL isLoadin;
/**
 吐司
 */
@property (nonatomic, strong) UILabel *toastLabel;
@end

@implementation DKBaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.view addSubview:self.naviView];
    _isLoadin = YES;
    
    [self addObserver];
//    [self.view bringSubviewToFront:self.naviView];
}

#pragma mark -lazy-

- (UIView *)naviView{
    if (!_naviView) {
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, 64)];
        _naviView.backgroundColor = [UIColor colorWithRed:249 green:249 blue:249 alpha:0.9];
        [_naviView addSubview:self.titleLabel];
        [_naviView addSubview:self.leftBtn];
        [_naviView addSubview:self.rightBtn];
    }
    return _naviView;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_leftBtn setTitle:@"左按钮" forState:(UIControlStateNormal)];
        [_leftBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _leftBtn.frame = CGRectMake(15, 30, 60, 20);
    }
    return _leftBtn;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_rightBtn setTitle:@"右按钮" forState:(UIControlStateNormal)];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _rightBtn.frame = CGRectMake(KScreenW - 15 - 60, 30, 60, 20);
    }
    return _rightBtn;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenW, 64)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    }
    return _tableView;
}

#pragma mark -按钮点击事件-
- (void)leftBtnAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnAction:(UIButton *)btn {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addObserver{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
