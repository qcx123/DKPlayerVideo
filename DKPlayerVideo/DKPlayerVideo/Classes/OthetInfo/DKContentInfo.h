//
//  DKContentInfo.h
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/11/27.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#ifndef DKContentInfo_h
#define DKContentInfo_h

// 视频通知
// Posted when first video/audio render
#define MPMoviePlayerFirstVideoFrameRenderedNotification @"MPMoviePlayerFirstVideoFrameRenderedNotification"
// Posted when the prepared state changes of an object conforming to the MPMediaPlayback protocol changes.
// This supersedes MPMoviePlayerContentPreloadDidFinishNotification.
#define MPMediaPlaybackIsPreparedToPlayDidChangeNotification @"MPMediaPlaybackIsPreparedToPlayDidChangeNotification"
// 视频缩放通知
#define DKMediaPlayZoomChangeNotification @"DKMediaPlayZoomChangeNotification"
// 网络通知
#define NetWorkChangeEventNotification    @"netWorkChangeEventNotification"



#import "NetworkRequest.h"
#import <Masonry.h>
#import "UIView+Frame.h"
#import "UIColor+Extension.h"

#define RGBColor(r, g, b, c) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:c]
#define PXTOPT(x) (x / 2.0)

#define KScreenW ([UIScreen mainScreen].bounds.size.width)
#define KScreenH ([UIScreen mainScreen].bounds.size.height)
#define TabBar_HEIGHT 49.0f
#define EvaluateViewHeightMultipliedBy 0.6  // 评论页高度相对于整个屏幕的百分比


#ifdef DEBUG
#define NSLog(...) printf("%s\n",[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#else
#define NSLog(format, ...)
#endif

#endif /* DKContentInfo_h */
