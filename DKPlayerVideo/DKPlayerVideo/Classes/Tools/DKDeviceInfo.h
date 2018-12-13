//
//  DKDeviceInfo.h
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/12/12.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKDeviceInfo : NSObject

@property (nonatomic, strong)NSString *systemVersion;//系统版本
@property (nonatomic, strong)NSString *model;        //e.g. "iPhone" "iPod" "iPad"
@property (nonatomic, strong)NSString *name;         //.e.g."my phone"
@property (nonatomic, strong)NSString *mcc;
@property (nonatomic, strong)NSString *mnc;
@property (nonatomic, strong)NSString *imsi;
@property (nonatomic, strong)NSString *imei;
@property (nonatomic, strong)NSString *mac;
@property (nonatomic, strong)NSString *iccid;
@property (nonatomic, strong)NSString *deviceid;

+ (DKDeviceInfo *)instance;
@end
