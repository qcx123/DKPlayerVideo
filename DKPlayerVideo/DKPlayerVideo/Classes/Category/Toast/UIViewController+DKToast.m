//
//  UIViewController+DKToast.m
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/12/13.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "UIViewController+DKToast.h"

@implementation UIViewController (DKToast)

- (void)makeToastWithMessage:(NSString *)msg duration:(NSTimeInterval)time position:(PositionType)positionType{
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *toastLabel = [[UILabel alloc] init];
        toastLabel.text = msg;
        toastLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:toastLabel];
        [self.view bringSubviewToFront:toastLabel];
        [self performSelector:@selector(removeToastLabel:) withObject:toastLabel afterDelay:time];
        switch (positionType) {
            case PositionType_Top:{
                [toastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.view).mas_offset(50);
                    make.height.mas_equalTo(30);
                    make.centerX.mas_equalTo(self.view);
                }];
            }
                break;
            case PositionType_Center:{
                [toastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(30);
                    make.center.mas_equalTo(self.view);
                }];
            }
                break;
            case PositionType_Bottom:{
                [toastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.view).mas_offset(-50);
                    make.height.mas_equalTo(30);
                    make.centerX.mas_equalTo(self.view);
                }];
            }
                break;
                
            default:{
                [toastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.view).mas_offset(-50);
                    make.height.mas_equalTo(30);
                    make.centerX.mas_equalTo(self.view);
                }];
            }
                break;
        }
    });
}

- (void)removeToastLabel:(UILabel *)toastLabel{
    [toastLabel removeFromSuperview];
    toastLabel = nil;
}
@end
