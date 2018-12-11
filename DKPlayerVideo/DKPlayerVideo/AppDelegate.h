//
//  AppDelegate.h
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/10/11.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 * 是否允许转向
 */
@property(nonatomic,assign)BOOL allowRotation;
@end

