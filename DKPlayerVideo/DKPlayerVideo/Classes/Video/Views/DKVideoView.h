//
//  DKVideoView.h
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/11/20.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKVideoCell.h"

typedef enum {// 播放状态
    PlayerState_Init, // 初始化
    PlayerState_Play, // 播放
    PlayerState_Pause,// 暂停
    PlayerState_Stop  // 结束
}PlayerState;

@protocol DKVideoViewDelegate <NSObject>
- (void)netSign;
- (void)playStateChange:(NSInteger)state;

- (void)actionWithType:(ActionType)actionType model:(VideoInfoModel *)model;
@end

@interface DKVideoView : UIView
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, strong) DKVideoCell *currentCell;
@property (nonatomic, strong) DKVideoCell *lastCell;
@property (nonatomic, strong) NSIndexPath *currentIndex;
@property (nonatomic, strong) NSArray *visibleCellsArray;
@property (nonatomic, assign) PlayerState playerState;
@property (nonatomic, assign) float currentPlaybackTime;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, weak)   id<DKVideoViewDelegate> delegate;

- (void)reloadData;
- (void)setFrame;
@end
