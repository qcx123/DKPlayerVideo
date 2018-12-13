//
//  DKDeviceInfo.m
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/12/12.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKDeviceInfo.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation DKDeviceInfo

+ (DKDeviceInfo *)instance
{
    static dispatch_once_t pred=0;
    static DKDeviceInfo *instance=nil;
    dispatch_once(&pred,^{
        instance=[[self alloc]init];
        [instance initData];
    });
    return instance;
}

- (void)initData
{
    UIDevice *device=[UIDevice currentDevice];
    self.systemVersion = device.systemVersion;
    self.model         = device.model;
    self.name          = device.name;
    
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    self.mcc = [carrier mobileCountryCode];
    self.mnc = [carrier mobileNetworkCode];
    self.imsi = [NSString stringWithFormat:@"%@%@", self.mcc, self.mnc];
    self.imei = @"";
    self.mac = @"";
    self.iccid = @"";
    self.deviceid = [[NSUUID UUID] UUIDString];
}


@end
