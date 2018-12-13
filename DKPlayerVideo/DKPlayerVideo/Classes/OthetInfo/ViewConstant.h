//
//  ViewConstant.h
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/12/13.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#ifndef ViewConstant_h
#define ViewConstant_h

// video
static const NSInteger ColumnCount = 3;    // 列数
static const CGFloat ColumnMargin  = 5.0; // 列间距
static const CGFloat RowMargin     = 5.0; // 行间距
static const NSInteger EdgeLeftRight = 15;  // 左右边距
static const NSInteger EdgeTopBottom = 10;  // 上下边距
#define RowHeight  ((KScreenW - (EdgeLeftRight * 2) - (ColumnMargin * 2)) / 3.0 * 1.5)  // 行高
#define PageSize = @(10)  // 视频列表每页视频个数

// toast
static const NSInteger kCommonToastDurationTime = 5;

#endif /* ViewConstant_h */
