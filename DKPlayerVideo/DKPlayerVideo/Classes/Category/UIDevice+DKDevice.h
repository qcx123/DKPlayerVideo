//
//  UIDevice+DKDevice.h
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/12/11.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (DKDevice)
/**
 * @interfaceOrientation 输入要强制转屏的方向
 */
+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation;
@end
