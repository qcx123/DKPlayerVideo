//
//  DKUser.h
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/12/13.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKUser : NSObject
/**
 登录状态
 */
@property (nonatomic, assign) BOOL isLogin;// YES : 登录状态
/**
 accessToken
 */
@property (nonatomic, strong) NSString *accessToken;
/**
 newUser
 */
@property (nonatomic, assign) NSInteger newUser;


+ (instancetype)shareDKUser;
@end
