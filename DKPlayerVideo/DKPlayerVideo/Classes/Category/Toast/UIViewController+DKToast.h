//
//  UIViewController+DKToast.h
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/12/13.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PositionType_Top,
    PositionType_Center,
    PositionType_Bottom
} PositionType;

#define Time  5

@interface UIViewController (DKToast)

- (void)makeToastWithMessage:(NSString *)msg duration:(NSTimeInterval)time position:(PositionType)positionType;

@end
