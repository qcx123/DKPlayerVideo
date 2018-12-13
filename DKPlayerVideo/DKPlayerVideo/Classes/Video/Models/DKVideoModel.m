//
//  DKVideoModel.m
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/12/12.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKVideoModel.h"
#import <MJExtension.h>

@implementation DKVideoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id"};// 前边的是你想用的key，后边的是返回的key
}

- (NSString *)description{
    return self.Id;
}

@end
