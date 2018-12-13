//
//  DKRegularVerifyUtil.m
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/12/13.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKRegularVerifyUtil.h"

@implementation DKRegularVerifyUtil

+ (BOOL)checkIsUserName:(NSString *)userName
{
    NSString* Regex = @"^[A-Za-z0-9_]{4,14}$";
    NSPredicate* check = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    if([check evaluateWithObject:userName]) {
        NSString* Regex = @"1\\d{10}";
        NSPredicate* check = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
        
        return [check evaluateWithObject:userName]? NO :YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)checkIsPhoneNum:(NSString *)phoneNum
{
    if (phoneNum.length == 0) {
        return NO;
    }
    
    //    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(170))\\d{8}$";
    NSString *regex = @"^[1]+\\d{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phoneNum];
    
    if (!isMatch) {
        return NO;
    }
    
    return YES;
}


// 检测密码 6-16位 字母,数字,符号组合
+ (BOOL)checkPassWord:(NSString *)password
{
    NSString* Regex = @"^[A-Za-z0-9!@#$%^&*()_+-=\x22]{6,16}$";
    //    NSString* Regex = @"\\w{6,16}";
    NSPredicate* check = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    if([check evaluateWithObject:password]) {
        return YES;
    } else {
        return NO;
    }
}

// 检测密码 6-16位简单规则
+ (BOOL)checkPassWordSimple:(NSString *)password
{
    NSString* Regex = @"\\w{6,16}";
    NSPredicate* check = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    if([check evaluateWithObject:password]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)checkVerifyCode:(NSString *)verifyCode
{
    NSString* Regex = @"^(\\d{6})";// 6位数字
    NSPredicate* check = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    if([check evaluateWithObject:verifyCode]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)checkVerifyImgCode:(NSString *)verifyCode
{
    NSString* Regex = @"^(\\w{4})";// 4位
    NSPredicate* check = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    if([check evaluateWithObject:verifyCode]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)checkisNumber:(NSString *)originalString minlen:(NSUInteger)minlen maxlen:(NSUInteger)maxlen
{
    NSString* Regex = [NSString stringWithFormat:@"^(\\d{%lu,%lu})", (unsigned long)minlen, (unsigned long)maxlen];
    NSPredicate* check = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    return [check evaluateWithObject:originalString];
}

+ (BOOL)checkisLetterAndNumber:(NSString *)originalString minlen:(NSUInteger)minlen maxlen:(NSUInteger)maxlen
{
    NSString* Regex = [NSString stringWithFormat:@"^[A-Za-z0-9]{%lu,%lu}$", (unsigned long)minlen, (unsigned long)maxlen];
    NSPredicate* check = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [check evaluateWithObject:originalString];
}

+ (NSString*)changePhoneNumberToStar:(NSString*)phoneNumber{
    NSString* result = @"";
    if (phoneNumber.length == 11) {
        NSString *string = [phoneNumber substringWithRange:NSMakeRange(4,4)];
        result = [phoneNumber stringByReplacingOccurrencesOfString:string withString:@"****"];
    }
    return result;
}

+(BOOL)haveBlank:(NSString *)str{
    NSRange _range = [str rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}

+ (BOOL)allChinese:(NSString*)originalString
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:originalString];
}

+ (BOOL)includeChinese:(NSString*)originalString
{
    for(int i=0; i< [originalString length];i++)
    {
        int a =[originalString characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isNumText:(NSString *)str{
    
    //    NSString * regex        = @"(/^[0-9]*$/)";
    NSString * regex = @"^[0-9]*$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

+ (NSString*)checkNullString:(NSString*)str{
    NSString* result = [str isKindOfClass:[NSNull class]] ? @"" : str;
    return result;
}

@end
