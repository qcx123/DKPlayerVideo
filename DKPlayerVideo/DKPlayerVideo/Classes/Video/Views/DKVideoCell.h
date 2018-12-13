//
//  DKVideoCell.h
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/16.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXVodPlayer.h>
#import "DKVideoModel.h"

#import "DKProgramView.h"

typedef enum : NSUInteger {
    ActionType_Share,       // 分享
    ActionType_Like,        // 点赞
    ActionType_DownLoad,    // 下载
    ActionType_Evaluate,    // 评论
    ActionType_Orientation  // 方向
} ActionType;

@protocol DKVideoCellDelegate <NSObject>
- (void)netSign;
- (void)playStateChange:(NSInteger)state;

- (void)actionWithType:(ActionType)actionType model:(DKVideoModel *)model;
@end

@interface DKVideoCell : UICollectionViewCell
@property (nonatomic, strong) TXVodPlayer *player;
@property (nonatomic, weak) id<DKVideoCellDelegate> delegate;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) DKVideoModel *model;
/**
 是否预加载
 */
@property (nonatomic, assign) BOOL isAutoPlay;
/**
 背景图
 */
@property (nonatomic, strong) UIImageView *bgImgView;
/**
 进度条
 */
@property (nonatomic, strong) DKProgramView *progressView;

- (int)startPlay:(NSString *)url;

- (int)play;

/* stopPlay 停止播放音视频流
 * 返回: 0 = OK
 */
- (int)stopPlay;

/* isPlaying 是否正在播放
 * 返回： YES 拉流中，NO 没有拉流
 */
- (bool)isPlaying;

/* pause 暂停播放
 *
 */
- (void)pause;

/* resume 继续播放
 *
 */
- (void)resume;

/**
 * 播放跳转到音视频流某个时间
 * @param time 流时间，单位为秒
 * @return 0 = OK
 */
- (int)seek:(float)time;

/**
 * 获取当前播放时间
 */
- (float)currentPlaybackTime;

/**
 * 获取视频总时长
 */
- (float)duration;

/**
 * 可播放时长
 */
- (float)playableDuration;

/**
 * 视频宽度
 */
- (int)width;

/**
 * 视频高度
 */
- (int)height;
@end
