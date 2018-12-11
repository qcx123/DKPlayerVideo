//
//  DKLoginViewController.m
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/11/29.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKLoginViewController.h"

@interface DKLoginViewController ()
/**
 backView
 */
@property (nonatomic, strong) UIImageView *backView;
/**
 closeBtn
 */
@property (nonatomic, strong) UIButton *closeBtn;
/**
 手机号输入框
 */
@property (nonatomic, strong) UITextField *phoneTextField;
/**
 验证码输入框
 */
@property (nonatomic, strong) UITextField *codeTextField;
/**
 倒计时按钮
 */
@property (nonatomic, strong) UIButton *countdownBtn;
/**
 登录注册按钮
 */
@property (nonatomic, strong) UIButton *loginAndRegisteredBtn;
/**
 微信按钮
 */
@property (nonatomic, strong) UIButton *winxinBtn;
/**
 QQ按钮
 */
@property (nonatomic, strong) UIButton *QQBtn;
/**
 键盘高度
 */
@property (nonatomic, assign) CGFloat keyBoardHigh;
@end

@implementation DKLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self addObserver];
    if (KScreenW < KScreenH) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DKMediaPlayZoomChangeNotification object:@(-(KScreenH * EvaluateViewHeightMultipliedBy))];
    }
}

- (void)setupUI {
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.closeBtn];
    [self.backView addSubview:self.phoneTextField];
    [self.backView addSubview:self.codeTextField];
    [self.backView addSubview:self.countdownBtn];
    [self.backView addSubview:self.loginAndRegisteredBtn];
    [self layout];
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
    
//    CGRect keyBoardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    self.keyBoardHigh = keyBoardFrame.size.height;
//    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    __weak __typeof(self)weakSelf = self;
//
//    float offsetOriginY = keyBoardFrame.origin.y != KScreenH ? -keyBoardFrame.size.height:0;
//    [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(weakSelf.view).with.offset(offsetOriginY);
//    }];
//
//    [UIView animateWithDuration:duration animations:^{
//        [weakSelf.view layoutIfNeeded];
//    }];
}

- (void)changeRotate:(NSNotification *)notification {
    [self closeBtnClick];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.phoneTextField isFirstResponder] || [self.codeTextField isFirstResponder]) {
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
        _backView = [[UIImageView alloc] init];
        _backView.backgroundColor = RGBColor(32, 32, 32, 1);
        _backView.userInteractionEnabled = YES;
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

- (UITextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _phoneTextField.backgroundColor = RGBColor(22, 22, 22, 1);
        _phoneTextField.textColor = [UIColor whiteColor];
        _phoneTextField.placeholder = @"优质评论将会优先展示";
//        _phoneTextField.placeholderColor = [UIColor whiteColor];
        _phoneTextField.font = [UIFont systemFontOfSize:14];
    }
    return _phoneTextField;
}

- (UITextField *)codeTextField{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _codeTextField.backgroundColor = RGBColor(22, 22, 22, 1);
        _codeTextField.textColor = [UIColor whiteColor];
        _codeTextField.placeholder = @"优质评论将会优先展示";
        //        _codeTextField.placeholderColor = [UIColor whiteColor];
        _codeTextField.font = [UIFont systemFontOfSize:14];
    }
    return _codeTextField;
}

- (UIButton *)countdownBtn{
    if (!_countdownBtn) {
        _countdownBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_countdownBtn setTitle:@"60s" forState:(UIControlStateNormal)];
        _countdownBtn.backgroundColor = RGBColor(22, 22, 22, 1);
        _countdownBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_countdownBtn addTarget:self action:@selector(countdownBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _countdownBtn;
}

- (UIButton *)loginAndRegisteredBtn{
    if (!_loginAndRegisteredBtn) {
        _loginAndRegisteredBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_loginAndRegisteredBtn setTitle:@"登录/注册" forState:(UIControlStateNormal)];
        _loginAndRegisteredBtn.backgroundColor = RGBColor(22, 22, 22, 1);
        _loginAndRegisteredBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_loginAndRegisteredBtn addTarget:self action:@selector(loginAndRegisteredBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _loginAndRegisteredBtn;
}

- (UIButton *)winxinBtn{
    if (!_winxinBtn) {
        _winxinBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_winxinBtn setTitle:@"微信登录" forState:(UIControlStateNormal)];
        _winxinBtn.backgroundColor = RGBColor(22, 22, 22, 1);
        _winxinBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return _winxinBtn;
}

- (UIButton *)QQBtn{
    if (!_QQBtn) {
        _QQBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_QQBtn setTitle:@"QQ登录" forState:(UIControlStateNormal)];
        _QQBtn.backgroundColor = RGBColor(22, 22, 22, 1);
        _QQBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return _QQBtn;
}

#pragma mark -click-

- (void)countdownBtnClick:(UIButton *)btn {
    
}

- (void)loginAndRegisteredBtnClick:(UIButton *)btn {
    
//    [NetworkRequest sendDataWithUrl:MobileURL parameters:<#(id)#> successResponse:<#^(id data)success#> failure:<#^(NSError *error)failure#>];
}

- (void)layout{
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(self.view).multipliedBy(EvaluateViewHeightMultipliedBy);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.backView);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView).mas_offset(40);
        make.left.mas_equalTo(self.backView).mas_offset(20);
        make.right.mas_equalTo(self.backView).mas_offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    [self.countdownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneTextField.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.phoneTextField);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneTextField.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(self.phoneTextField);
        make.right.mas_equalTo(self.countdownBtn.mas_left).mas_offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    [self.loginAndRegisteredBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeTextField.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(self.phoneTextField);
        make.right.mas_equalTo(self.phoneTextField);
        make.height.mas_equalTo(40);
    }];
    /*
    if (KScreenW > KScreenH) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.view);
            make.width.mas_equalTo(300);
            make.right.mas_equalTo(self.view).mas_offset(self.backView.width);
        }];
        
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(self.backView);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView).mas_offset(20);
            make.left.mas_equalTo(self.backView).mas_offset(20);
            make.right.mas_equalTo(self.backView).mas_offset(20);
            make.height.mas_equalTo(40);
        }];
        
        [self.countdownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.phoneTextField.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(self.phoneTextField);
            make.height.mas_equalTo(60);
            make.height.mas_equalTo(30);
        }];
        
        [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.phoneTextField.mas_bottom).mas_offset(0);
            make.left.mas_equalTo(self.phoneTextField);
            make.right.mas_equalTo(self.countdownBtn.mas_left).mas_offset(-10);
            make.height.mas_equalTo(40);
        }];
        
        [self.loginAndRegisteredBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.codeTextField).mas_offset(5);
            make.left.mas_equalTo(self.phoneTextField);
            make.right.mas_equalTo(self.phoneTextField);
            make.height.mas_equalTo(40);
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
     */
}

- (void)updateLayout{
    /*
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
     */
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
