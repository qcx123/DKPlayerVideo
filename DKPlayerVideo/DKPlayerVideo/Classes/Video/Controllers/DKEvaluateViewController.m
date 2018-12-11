//
//  DKEvaluateViewController.m
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/11/20.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKEvaluateViewController.h"
#import <Masonry.h>

#import "DKEvaluateCell.h"
#import "DKReplyCell.h"
#import "DKTextView.h"

@interface DKEvaluateViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 backView
 */
@property (nonatomic, strong) UIView *backView;
/**
 closeBtn
 */
@property (nonatomic, strong) UIButton *closeBtn;
/**
 table
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 输入
 */
@property (nonatomic, strong) UIView *editView;
/**
 输入框
 */
@property (nonatomic, strong) DKTextView *textView;
/**
 表情按钮
 */
@property (nonatomic, strong) UIButton *enjoyBtn;
/**
 发送按钮
 */
@property (nonatomic, strong) UIButton *sendBtn;
/**
 键盘高度
 */
@property (nonatomic, assign) CGFloat keyBoardHigh;
/**
 输入框高度
 */
@property (nonatomic, assign) CGFloat editViewH;
@end

static NSString *EvaluateCellId = @"evaluateCellId";
static NSString *ReplyCellId    = @"replyCellId";

static CGFloat fontSize  = 14;// 输入框字体大小

@implementation DKEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _editViewH = [UIFont systemFontOfSize:fontSize].lineHeight + 20;
    [self setupUI];
    [self addObserver];
    if (KScreenW < KScreenH) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DKMediaPlayZoomChangeNotification object:@(-(KScreenH * EvaluateViewHeightMultipliedBy))];
    }
}

- (void)setupUI {
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.closeBtn];
    [self.backView addSubview:self.tableView];
    [self.backView addSubview:self.editView];
    [self layout];
    
    __weak DKEvaluateViewController *weakSelf = self;
    [self.textView setTextHighChangeBlock:^(NSString *text, CGFloat high) {
        if (weakSelf.keyBoardHigh != 0) {//不是第一次 就更新约束
            weakSelf.editViewH = high + 20;//45是上下边距+发送按钮高度
            [weakSelf.editView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(weakSelf.editViewH));
                make.bottom.equalTo(weakSelf.backView).with.offset(weakSelf.keyBoardHigh != 0 ? -weakSelf.keyBoardHigh:0);
            }];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        if (KScreenW > KScreenH) {
            [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.view);
            }];
        }
    }];
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)noti {
    
    CGRect keyBoardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyBoardHigh = keyBoardFrame.size.height;
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    __weak __typeof(self)weakSelf = self;
    
    float offsetOriginY = keyBoardFrame.origin.y != KScreenH ? -keyBoardFrame.size.height:0;
    [self.editView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.backView).with.offset(offsetOriginY);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        [weakSelf.view layoutIfNeeded];
        [self.view bringSubviewToFront:self.editView];
    }];
}

- (void)changeRotate:(NSNotification *)notification {
    [self closeBtnClick];
}

#pragma mark -table-

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DKBaseTableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:EvaluateCellId forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:ReplyCellId forIndexPath:indexPath];
    }
    cell.contentView.backgroundColor = RGBColor(32, 32, 32, 1);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.textView isFirstResponder]) {
        //结束编辑
        [self.view endEditing:YES];
    }else{
        [self closeBtnClick];
    }
}

- (void)closeBtnClick {
    [self.view endEditing:YES];
    if (KScreenW > KScreenH) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.view).mas_offset(self.backView.width);
            }];
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:DKMediaPlayZoomChangeNotification object:@(0)];// 0缩小，1放大
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}

#pragma mark -lazy-

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = RGBColor(32, 32, 32, 1);
    }
    return _backView;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_closeBtn setTitle:@"关闭" forState:(UIControlStateNormal)];
        _closeBtn.backgroundColor = RGBColor(22, 22, 22, 1);
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeBtn;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = RGBColor(32, 32, 32, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[DKEvaluateCell class] forCellReuseIdentifier:EvaluateCellId];
        [_tableView registerClass:[DKReplyCell class] forCellReuseIdentifier:ReplyCellId];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
    }
    return _tableView;
}

- (UIView *)editView{
    if (!_editView) {
        _editView = [[UIView alloc] init];
        _editView.backgroundColor = RGBColor(22, 22, 22, 1);
        [_editView addSubview:self.textView];
        [_editView addSubview:self.enjoyBtn];
        [_editView addSubview:self.sendBtn];
    }
    return _editView;
}

- (DKTextView *)textView{
    if (!_textView) {
        _textView = [[DKTextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _textView.backgroundColor = RGBColor(22, 22, 22, 1);
        _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _textView.textColor = [UIColor whiteColor];
        _textView.placeholder = @"优质评论将会优先展示";
        _textView.placeholderColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.maxLine = 5;
        _textView.minLine = 1;
    }
    return _textView;
}

- (UIButton *)enjoyBtn{
    if (!_enjoyBtn) {
        _enjoyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_enjoyBtn setTitle:@"表情" forState:(UIControlStateNormal)];
        _enjoyBtn.backgroundColor = RGBColor(22, 22, 22, 1);
        _enjoyBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return _enjoyBtn;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_sendBtn setTitle:@"发送" forState:(UIControlStateNormal)];
        _sendBtn.backgroundColor = RGBColor(22, 22, 22, 1);
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return _sendBtn;
}

- (void)layout{
    
    if (KScreenW > KScreenH) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.view);
            make.width.mas_equalTo(300);
            make.right.mas_equalTo(self.view).mas_offset(self.backView.width);
        }];
        
        [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.backView);
            make.height.mas_equalTo(self.editViewH);
        }];
        
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.editView);
            make.centerY.mas_equalTo(self.editView);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        [self.enjoyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.sendBtn.mas_left);
            make.centerY.mas_equalTo(self.editView);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self.editView).mas_offset(10);
            make.bottom.mas_equalTo(self.editView).mas_offset(-10);
            make.right.mas_equalTo(self.enjoyBtn.mas_left).mas_offset(0);
        }];
        
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(self.backView);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.backView);
            make.top.mas_equalTo(self.closeBtn.mas_bottom);
            make.bottom.mas_equalTo(self.backView).mas_offset(-self.editViewH);
            make.width.mas_equalTo(self.editView);
        }];
    }else{
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(self.view).multipliedBy(EvaluateViewHeightMultipliedBy);
        }];
        
        [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.backView);
            make.height.mas_equalTo(45);
        }];
        
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.editView);
            make.centerY.mas_equalTo(self.editView);
            make.size.mas_equalTo(CGSizeMake(0, 30));
        }];
        
        [self.enjoyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.sendBtn.mas_left);
            make.centerY.mas_equalTo(self.editView);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self.editView).mas_offset(10);
            make.bottom.mas_equalTo(self.editView).mas_offset(-10);
            make.right.mas_equalTo(self.enjoyBtn.mas_left).mas_offset(0);
        }];
        
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(self.backView);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.backView);
            make.bottom.mas_equalTo(self.backView).mas_offset(-self.editViewH);
            make.top.mas_equalTo(self.closeBtn.mas_bottom);
        }];
    }
}

- (void)updateLayout{
    
    if (KScreenW > KScreenH) {
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.view);
            make.width.mas_equalTo(300);
            make.right.mas_equalTo(self.view).mas_offset(self.backView.width);
        }];
        
        [self.editView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.backView);
            make.height.mas_equalTo(self.editViewH);
        }];
        
        [self.sendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.editView);
            make.centerY.mas_equalTo(self.editView);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        [self.enjoyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.sendBtn.mas_left);
            make.centerY.mas_equalTo(self.editView);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self.editView).mas_offset(10);
            make.bottom.mas_equalTo(self.editView).mas_offset(-10);
            make.right.mas_equalTo(self.enjoyBtn.mas_left).mas_offset(0);
        }];
        
        [self.closeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(self.backView);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.backView);
            make.top.mas_equalTo(self.closeBtn.mas_bottom);
            make.bottom.mas_equalTo(self.backView).mas_offset(-self.editViewH);
            make.width.mas_equalTo(self.editView);
        }];
    }else{
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(self.view).multipliedBy(EvaluateViewHeightMultipliedBy);
        }];
        
        [self.editView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.backView);
            make.height.mas_equalTo(45);
        }];
        
        [self.sendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.editView);
            make.centerY.mas_equalTo(self.editView);
            make.size.mas_equalTo(CGSizeMake(0, 30));
        }];
        
        [self.enjoyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.sendBtn.mas_left);
            make.centerY.mas_equalTo(self.editView);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self.editView).mas_offset(10);
            make.bottom.mas_equalTo(self.editView).mas_offset(-10);
            make.right.mas_equalTo(self.enjoyBtn.mas_left).mas_offset(0);
        }];
        
        [self.closeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(self.backView);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.backView);
            make.bottom.mas_equalTo(self.backView).mas_offset(-self.editViewH);
            make.top.mas_equalTo(self.closeBtn.mas_bottom);
        }];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
