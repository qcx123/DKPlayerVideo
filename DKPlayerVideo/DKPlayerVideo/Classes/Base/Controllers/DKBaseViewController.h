//
//  DKBaseViewController.h
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/13.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIDevice+DKDevice.h"


@interface DKBaseViewController : UIViewController
///**
// 导航栏
// */
@property (nonatomic, strong) UIView *naviView;
/**
 左按钮
 */
@property (nonatomic, strong) UIButton *leftBtn;
/**
 右按钮
 */
@property (nonatomic, strong) UIButton *rightBtn;
/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 标题
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 标题
 */
@property (nonatomic, strong) AppDelegate *appDelegate;

- (void)leftBtnAction:(UIButton *)btn;

- (void)rightBtnAction:(UIButton *)btn;



@end
