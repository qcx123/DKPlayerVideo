//
//  DKRegularVerifyUtil.h
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/12/13.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKRegularVerifyUtil : NSObject
//校验用户信息
+ (BOOL)checkIsUserName:(NSString *)userName;
+ (BOOL)checkIsPhoneNum:(NSString *)phoneNum;
+ (BOOL)checkPassWord:(NSString *)password;
+ (BOOL)checkPassWordSimple:(NSString *)password;
+ (BOOL)checkVerifyCode:(NSString *)verifyCode;
+ (BOOL)checkVerifyImgCode:(NSString *)verifyCode;

/**
 *   校验是否为存数字
 *
 *  @param originalString 检查字符串
 *  @param minlen         最小长度
 *  @param maxlen         最大长度
 *
 *  @return yes or no
 */
+ (BOOL)checkisNumber:(NSString *)originalString minlen:(NSUInteger)minlen maxlen:(NSUInteger)maxlen;

/**
 *  检验是否为字母和数字
 *
 *  @param originalString 检查字符串
 *  @param minlen         最小长度
 *  @param maxlen         最大长度
 *
 *  @return yes or no
 */
+ (BOOL)checkisLetterAndNumber:(NSString *)originalString minlen:(NSUInteger)minlen maxlen:(NSUInteger)maxlen;

+ (NSString*)changePhoneNumberToStar:(NSString*)phoneNumber;

+(BOOL)haveBlank:(NSString *)str;

+ (BOOL)allChinese:(NSString*)originalString;

+ (BOOL)includeChinese:(NSString*)originalString;

+ (BOOL)isNumText:(NSString *)str;

/**
 *  检验是否为NSNULL
 *
 *  @param originalString 检查字符串
 *
 *  @return 如果nsnull 返回空串, 否则返回正常字符串
 */
+ (NSString*)checkNullString:(NSString*)str;
@end
