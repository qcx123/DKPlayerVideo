//
//  UIDevice+DKDevice.m
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/12/11.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "UIDevice+DKDevice.h"

@implementation UIDevice (DKDevice)

+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation{
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    NSNumber *orientationTarget = [NSNumber numberWithInt:interfaceOrientation];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}
@end
