//
//  DKTextView.h
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/11/22.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKTextView : UITextView

/**
 textView 最大行数
 */
@property (nonatomic, assign) NSInteger maxLine;

/**
 默认显示的最小行数
 */
@property (nonatomic, assign) NSInteger minLine;

/**
 最小行高（此属性 不要赋值，有最小行数计算得出）
 */
@property (nonatomic, assign) CGFloat minHight;

/**
 文字高度改变block，文字高度会自动调用
 */
@property (nonatomic, copy) void(^textHighChangeBlock)(NSString *text,CGFloat textHigh);

/**
 边框圆角
 */
@property (nonatomic, assign) NSInteger cornerRadius;

/**
 占位文字
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 占位文字颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
