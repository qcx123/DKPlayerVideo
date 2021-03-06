//
//  AppDelegate.m
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/10/11.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "AppDelegate.h"
#import "DKTabBarViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "DKNetInfo.h"

@interface AppDelegate ()<UITabBarControllerDelegate>
/**
 是否登录
 */
@property (nonatomic, assign) BOOL isLogin;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _isLogin = NO;
    
    DKTabBarViewController *tabVC = [[DKTabBarViewController alloc]init];
    tabVC.tabBar.tintColor = [UIColor blackColor];
    tabVC.delegate = self;
    self.window.rootViewController = tabVC;
    [self.window makeKeyAndVisible];
    
    [self netWorkChangeEvent];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 检测网络状态变化
-(void)netWorkChangeEvent
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //2.监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
                
            case AFNetworkReachabilityStatusUnknown:
                [DKNetInfo shareInstance].netType = NetType_Unknown;
                [DKNetInfo shareInstance].net = @"unknown";
                NSLog(@"未知");
                
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                [DKNetInfo shareInstance].netType = NetType_No;
                [DKNetInfo shareInstance].net = @"no";
                NSLog(@"没有网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [DKNetInfo shareInstance].netType = NetType_3G4G;
                [DKNetInfo shareInstance].net = @"3G/4G";
                NSLog(@"3G|4G");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [DKNetInfo shareInstance].netType = NetType_WIFI;
                [DKNetInfo shareInstance].net = @"wifi";
                NSLog(@"WiFi");
                
                break;
                
            default:
                [DKNetInfo shareInstance].netType = NetType_Unknown;
                [DKNetInfo shareInstance].net = @"unknown";
                break;
                
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NetWorkChangeEventNotification object:@(status)];
    }];
    
    [manager startMonitoring];//开始监听
}

/**
 *  TabBarController代理
 */
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (!_isLogin) {
        if ([viewController.tabBarItem.title isEqualToString:@"我的"]) {
            return NO;
        }
    }
    return YES;
}

- (void)logSelect:(NSNotification *)text{
//    _tabbarVC.selectedIndex = [text.userInfo[@"logSelect"] integerValue];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window{
    if (self.allowRotation == YES) {
        //横屏
        return UIInterfaceOrientationMaskLandscape;
    }else{
        //竖屏
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
