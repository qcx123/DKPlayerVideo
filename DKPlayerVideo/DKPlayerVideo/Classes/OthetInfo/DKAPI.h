//
//  DKAPI.h
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/11/29.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#ifndef DKAPI_h
#define DKAPI_h

#ifdef DEBUG
#define ServerAddress @"http://192.168.16.170:8480/"
#else
#define ServerAddress @"http://192.168.16.170:8480/"
#endif

// 公共字段
#define API @"api/"
// 子公共字段
#define Content @"content/"
#define Login @"login/"

// 内容
#define AddAdminRecommendURL [NSString stringWithFormat:@"%@%@%@addAdminRecommend",ServerAddress,API,Content]// 添加进推荐列表
#define AdminListURL [NSString stringWithFormat:@"%@%@%@adminList",ServerAddress,API,Content]// 获取首页内容卡片（运营推荐）
#define ListURL      [NSString stringWithFormat:@"%@%@%@list",ServerAddress,API,Content]//获取首页内容卡片
#define VideoListURL [NSString stringWithFormat:@"%@%@%@video/list",ServerAddress,API,Content]// 游戏详情页相关视频

// api/login : 注册、登录、验证码
#define MobileURL [NSString stringWithFormat:@"%@%@%@mobile",ServerAddress,API,Login]// 手机号注册/登录
#define QuitURL   [NSString stringWithFormat:@"%@%@%@quit",ServerAddress,API,Login]// 退出登录
#define SendCodeURL      [NSString stringWithFormat:@"%@%@%@sendcode",ServerAddress,API,Login]//发送短信验证码
#define ThirdURL  [NSString stringWithFormat:@"%@%@%@video/third",ServerAddress,API,Login]// (微信、QQ)


#endif /* DKAPI_h */
