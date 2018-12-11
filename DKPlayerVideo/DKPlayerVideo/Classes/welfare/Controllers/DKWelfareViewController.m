//
//  DKWelfareViewController.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/16.
//  Copyright © 2018年 乔春晓. All rights reserved.
//


#import "DKWelfareViewController.h"

@interface DKWelfareViewController ()

@end

@implementation DKWelfareViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.backgroundImage = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
}

@end
