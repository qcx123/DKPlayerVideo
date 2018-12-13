//
//  DKVideoCell.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/16.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKVideoCell.h"
#import "UIColor+Extension.h"
#import "DKNetInfo.h"
#import "YPDouYinLikeAnimation.h"
#import <UIImageView+WebCache.h>

@interface DKVideoCell ()<TXVodPlayListener>
/**
 playerView
 */
@property (nonatomic, strong) UIView *playerView;
/**
 控制view
 */
@property (nonatomic, strong) UIView *controlView;
/**
 暂停按钮
 */
@property (nonatomic, strong) UIImageView *playImgView;
/**
 头像
 */
@property (nonatomic, strong) UIImageView *authorIcon;
/**
 方向按钮
 */
@property (nonatomic, strong) UIButton *directionBtn;
/**
 分享按钮
 */
@property (nonatomic, strong) UIButton *shareBtn;
/**
 点赞按钮
 */
@property (nonatomic, strong) UIButton *likeBtn;
/**
 评论按钮
 */
@property (nonatomic, strong) UIButton *evaluateBtn;
/**
 下载
 */
@property (nonatomic, strong) UIButton *downloadBtn;
/**
 @label
 */
@property (nonatomic, strong) UILabel *authorNameLabel;
/**
 描述
 */
@property (nonatomic, strong) UILabel *descriptionLabel;
/**
 游戏底部半透明背景
 */
@property (nonatomic, strong) UIImageView *backView;
/**
 游戏icon
 */
@property (nonatomic, strong) UIImageView *gameIcon;
/**
 游戏名字
 */
@property (nonatomic, strong) UILabel *gameNameLabel;
/**
 游戏描述
 */
@property (nonatomic, strong) UILabel *gameDescriptionLabel;
@end

@implementation DKVideoCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self initPlayer];
        [self addObserver];
    }
    return self;
}

- (void)dealloc{
    [self removeObserver];
}

- (void)addObserver{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeZoom:) name:DKMediaPlayZoomChangeNotification object:nil];
}

- (void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DKMediaPlayZoomChangeNotification object:nil];
}

- (void)changeRotate:(NSNotification *)notification {
    [UIView animateWithDuration:0.5 animations:^{
        [self updateLayout];
    }];
}

- (void)changeZoom:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView).mas_offset([notification.object integerValue]);
        }];
        self.bgImgView.hidden = [notification.object integerValue] != 0;
    }];
}

- (void)initPlayer{
    if(!_player){
        _player = [[TXVodPlayer alloc] init];
        [_player setupVideoWidget:self.playerView insertIndex:0];
        _player.loop = YES;
        [_player setRenderMode:RENDER_MODE_FILL_EDGE];
        _player.vodDelegate = self;
    }
}

- (void)setIsAutoPlay:(BOOL)isAutoPlay{
    _isAutoPlay = isAutoPlay;
    _player.isAutoPlay = _isAutoPlay;
}

#pragma mark -setup-

- (void)setupUI{
    [self.contentView addSubview:self.bgImgView];
    [self.contentView addSubview:self.playerView];
    [self.contentView addSubview:self.controlView];
    [self layout];
}



// 设置按钮和图片垂直居中
-(void)setButtonContentCenter:(UIButton *) btn{
    CGSize imgViewSize,titleSize,btnSize;
    UIEdgeInsets imageViewEdge,titleEdge;
    CGFloat heightSpace = 10.0f;
    //设置按钮内边距
    imgViewSize = btn.imageView.bounds.size;
    titleSize = btn.titleLabel.bounds.size;
    btnSize = btn.bounds.size;
    imageViewEdge = UIEdgeInsetsMake(heightSpace,0.0, btnSize.height -imgViewSize.height - heightSpace, - titleSize.width);
    [btn setImageEdgeInsets:imageViewEdge];
    titleEdge = UIEdgeInsetsMake(imgViewSize.height +heightSpace, - imgViewSize.width, 0.0, 0.0);
    [btn setTitleEdgeInsets:titleEdge];
}

#pragma mark -跟踪进度-
-(void) onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary*)param {
    if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
        // 加载进度, 单位是秒, 小数部分为毫秒
        //        float playable = [param[EVT_PLAYABLE_DURATION] floatValue];
        //        [_loadProgressBar setValue:playable];

        // 播放进度, 单位是秒, 小数部分为毫秒
        float progress = [param[EVT_PLAY_PROGRESS] floatValue];
        //        [_seekProgressBar setValue:progress];

        // 视频总长, 单位是秒, 小数部分为毫秒
        float duration = [param[EVT_PLAY_DURATION] floatValue];
        // 可以用于设置时长显示等等
        self.progressView.progress = progress / duration;
//        NSLog(@"%lf",self.progressView.progress);
//        [_progressView stopLoading];
    }else if (EvtID == PLAY_EVT_PLAY_LOADING){// 视频开始loading
        NSLog(@"视频开始loading");
        [_progressView starLoading];
    }else if (EvtID == PLAY_EVT_VOD_LOADING_END || EvtID == PLAY_EVT_VOD_PLAY_PREPARED || EvtID == PLAY_EVT_PLAY_BEGIN){// 视频loading结束
        NSLog(@"视频loading结束");
        [_progressView stopLoading];
    }else if (EvtID == PLAY_EVT_PLAY_END){
        
    }
}

- (void)setModel:(DKVideoModel *)model{
    _model = model;
    _progressView.progress = 0.0;
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:_model.coverUrl] placeholderImage:[UIImage imageNamed:@"bg_noNet"]];
    [self.authorIcon sd_setImageWithURL:[NSURL URLWithString:_model.authorIcon]];
    [self.gameIcon sd_setImageWithURL:[NSURL URLWithString:_model.icon]];
    self.authorNameLabel.text = _model.author;
    self.descriptionLabel.text = _model.content;
    self.gameNameLabel.text = _model.gameName;
    [self.likeBtn setTitle:[self showTimes:_model.praiseTimes] forState:(UIControlStateNormal)];
    [self.shareBtn setTitle:[self showTimes:_model.forwardTimes] forState:(UIControlStateNormal)];
    [self.evaluateBtn setTitle:[self showTimes:_model.commentTimes] forState:(UIControlStateNormal)];
    self.directionBtn.hidden = _model.horizontal == 1 ? YES : NO;
    if ([_player isPlaying]) {
        [_player stopPlay];
    }
}

#pragma mark -启动播放-

- (int)startPlay:(NSString *)url{
    self.playImgView.hidden = YES;
    return [self.player startPlay:url];
}

- (int)play{
    self.playImgView.hidden = YES;
    if (_model) {
        int isSuccess = [self.player startPlay:_model.videoUrl];
        
        if ([DKNetInfo shareInstance].netType == NetType_3G4G && [DKNetInfo shareInstance].isAllow3G4GPlay == NO) {
            [_player pause];
            if (_delegate && [_delegate respondsToSelector:@selector(netSign)]) {
                [_delegate netSign];
            }
        }
        return isSuccess;
    }else{
        NSLog(@"url为空");
        return 0;
    }
}

/* stopPlay 停止播放音视频流
 * 返回: 0 = OK
 */
- (int)stopPlay{
    self.playImgView.hidden = YES;
    //    [_bgImgView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"bg_noNet"]];
//    self.progressView.progress = 0.0;
    return [_player stopPlay];
}

/* isPlaying 是否正在播放
 * 返回： YES 拉流中，NO 没有拉流
 */
- (bool)isPlaying{
    return [_player isPlaying];
}

/* pause 暂停播放
 *
 */
- (void)pause{
    self.playImgView.hidden = NO;
    [_player pause];
}

/* resume 继续播放
 *
 */
- (void)resume{
    self.playImgView.hidden = YES;
    [_player resume];
}

/**
 * 播放跳转到音视频流某个时间
 * @param time 流时间，单位为秒
 * @return 0 = OK
 */
- (int)seek:(float)time{
    return [_player seek:time];
}

/**
 * 获取当前播放时间
 */
- (float)currentPlaybackTime{
    return [_player currentPlaybackTime];
}

/**
 * 获取视频总时长
 */
- (float)duration{
    return [_player duration];
}

/**
 * 可播放时长
 */
- (float)playableDuration{
    return [_player playableDuration];
}

/**
 * 视频宽度
 */
- (int)width{
    return [_player width];
}

/**
 * 视频高度
 */
- (int)height{
    return [_player height];
}

#pragma mark -按钮点击事件-

- (void)directionAction:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(actionWithType:model:)]) {
        [_delegate actionWithType:ActionType_Orientation model:_model];
    }
}

- (void)shareAction:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(actionWithType:model:)]) {
        [_delegate actionWithType:ActionType_Share model:_model];
    }
}

- (void)likeAction:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(actionWithType:model:)]) {
        [_delegate actionWithType:ActionType_Like model:_model];
    }
}

- (void)evaluateAction:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(actionWithType:model:)]) {
        [_delegate actionWithType:ActionType_Evaluate model:_model];
    }
}

- (void)downLoadAction:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(actionWithType:model:)]) {
        [_delegate actionWithType:ActionType_DownLoad model:_model];
    }
}

#pragma mark -点击事件-

- (void)doubleTapAction:(UITapGestureRecognizer *)tap{
    [[YPDouYinLikeAnimation shareInstance] createAnimationWithTap:tap];
}

- (void)singleTapAction:(UITapGestureRecognizer *)tap{
    if ([self isPlaying]) {
        [self pause];
//        _playerState = PlayerState_Pause;
    }else{
        [self resume];
//        _playerState = PlayerState_Play;
    }
}

#pragma mark -lazy-

- (UIView *)playerView{
    if (!_playerView) {
        _playerView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _playerView;
}

- (UIView *)controlView{
    if (!_controlView) {
        _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
        _controlView.backgroundColor = [UIColor clearColor];
        _controlView.userInteractionEnabled = YES;
        
//        [self.controlView addSubview:self.progressView];
        [_controlView addSubview:self.backView];
        [_controlView addSubview:self.directionBtn];
        [_controlView addSubview:self.shareBtn];
        [_controlView addSubview:self.likeBtn];
        [_controlView addSubview:self.evaluateBtn];
        [_controlView addSubview:self.authorIcon];
        [_controlView addSubview:self.downloadBtn];
        [_controlView addSubview:self.authorNameLabel];
        [_controlView addSubview:self.descriptionLabel];
        [_controlView addSubview:self.playImgView];
        
        self.playImgView.hidden = YES;
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        doubleTap.numberOfTapsRequired = 2; // 双击
        [_controlView addGestureRecognizer:doubleTap];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        singleTap.numberOfTapsRequired = 1; // 单击
        [_controlView addGestureRecognizer:singleTap];
    }
    return _controlView;
}

- (DKProgramView *)progressView{
    if (!_progressView) {
        _progressView = [[DKProgramView alloc] initWithFrame:CGRectMake(0, KScreenH - TabBar_HEIGHT - 1, KScreenW, 1)];
    }
    return _progressView;
}

- (UIImageView *)authorIcon{
    if (!_authorIcon) {
        _authorIcon = [[UIImageView alloc] init];
        _authorIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _authorIcon;
}

- (UIButton *)directionBtn{
    if (!_directionBtn) {
        _directionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_directionBtn setImage:[UIImage imageNamed:@"btn_tx"] forState:(UIControlStateNormal)];
        [_directionBtn setBackgroundImage:[UIImage imageNamed:@"btn_bjy"] forState:(UIControlStateNormal)];
        _directionBtn.frame = CGRectMake(0, 0, 50, 50);
        [_directionBtn addTarget:self action:@selector(directionAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _directionBtn;
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_shareBtn setImage:[UIImage imageNamed:@"btn_zf"] forState:(UIControlStateNormal)];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:@"btn_bjy"] forState:(UIControlStateNormal)];
        [_shareBtn setTitle:@"666" forState:(UIControlStateNormal)];
        _shareBtn.frame = CGRectMake(0, 0, 50, 50);
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        [_shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self setButtonContentCenter:_shareBtn];
    }
    return _shareBtn;
}

- (UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_likeBtn setImage:[UIImage imageNamed:@"btn_dianz"] forState:(UIControlStateNormal)];
        [_likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_bjy"] forState:(UIControlStateNormal)];
        [_likeBtn setTitle:@"666" forState:(UIControlStateNormal)];
        _likeBtn.frame = CGRectMake(0, 0, 50, 50);
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:8];
        [_likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self setButtonContentCenter:_likeBtn];
    }
    return _likeBtn;
}

- (UIButton *)evaluateBtn{
    if (!_evaluateBtn) {
        _evaluateBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_evaluateBtn setImage:[UIImage imageNamed:@"btn_dianz"] forState:(UIControlStateNormal)];
        [_evaluateBtn setBackgroundImage:[UIImage imageNamed:@"btn_bjy"] forState:(UIControlStateNormal)];
        [_evaluateBtn setTitle:@"评论" forState:(UIControlStateNormal)];
        _evaluateBtn.frame = CGRectMake(0, 0, 50, 50);
        _evaluateBtn.titleLabel.font = [UIFont systemFontOfSize:8];
        [_evaluateBtn addTarget:self action:@selector(evaluateAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self setButtonContentCenter:_evaluateBtn];
    }
    return _evaluateBtn;
}

- (UIButton *)downloadBtn{
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_downloadBtn setImage:[UIImage imageNamed:@"btn_xz"] forState:(UIControlStateNormal)];
        [_downloadBtn addTarget:self action:@selector(downLoadAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _downloadBtn;
}

- (UILabel *)authorNameLabel{
    if (!_authorNameLabel) {
        _authorNameLabel = [[UILabel alloc] init];
        _authorNameLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _authorNameLabel.font = [UIFont systemFontOfSize:16];
        _authorNameLabel.text = @"春晓";
    }
    return _authorNameLabel;
}

- (UILabel *)descriptionLabel{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _descriptionLabel.font = [UIFont systemFontOfSize:11];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.text = @"\"这里有好多鱼啊\n\"不，这里只有一条鱼，其他都是木头\"";
    }
    return _descriptionLabel;
}

- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFit;
        //        [_bgImgView sd_setImageWithURL:[NSURL URLWithString:@"http://p3.pstatp.com/large/3a340011ef33f75dd8aa.jpg"]];
        //        [_bgImgView sd_setImageWithURL:[NSURL URLWithString:@"http://p3.pstatp.com/large/3a340011ef33f75dd8aa.jpg"] placeholderImage:[UIImage imageNamed:@"bg_noNet"]];
    }
    return _bgImgView;
}

- (UIImageView *)backView{
    if (!_backView) {
        _backView = [[UIImageView alloc] init];
        _backView.image = [UIImage imageNamed:@"bj_tmk"];
        _backView.userInteractionEnabled = YES;
        [_backView addSubview:self.gameIcon];
        [_backView addSubview:self.gameNameLabel];
        [_backView addSubview:self.gameDescriptionLabel];
        
    }
    return _backView;
}

- (UIImageView *)gameIcon{
    if (!_gameIcon) {
        _gameIcon = [[UIImageView alloc] init];
        _gameIcon.image = [UIImage imageNamed:@"btn_tx"];
    }
    return _gameIcon;
}

- (UILabel *)gameNameLabel{
    if (!_gameNameLabel) {
        _gameNameLabel = [[UILabel alloc] init];
        _gameNameLabel.text = @"游戏名字";
        _gameNameLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _gameNameLabel.font = [UIFont systemFontOfSize:18];
    }
    return _gameNameLabel;
}

- (UILabel *)gameDescriptionLabel{
    if (!_gameDescriptionLabel) {
        _gameDescriptionLabel = [[UILabel alloc] init];
        _gameDescriptionLabel.text = @"游戏描述";
        _gameDescriptionLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
        _gameDescriptionLabel.font = [UIFont systemFontOfSize:11];
    }
    return _gameDescriptionLabel;
}

- (UIImageView *)playImgView{
    if (!_playImgView) {
        _playImgView = [[UIImageView alloc] init];
        _playImgView.image = [UIImage imageNamed:@"icon_zt"];
    }
    return _playImgView;
}

- (void)layout{
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.contentView);
    }];
    
    if (KScreenW > KScreenH) {
        NSLog(@"layout横屏布局 W = %lf,H = %lf",KScreenW,KScreenH);
        [self.playImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.controlView);
            make.width.height.mas_equalTo(70);
        }];
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.controlView).mas_offset(0);
        }];
        
        [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.controlView);
            make.bottom.mas_equalTo(self.controlView);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.evaluateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.downloadBtn.mas_left).mas_offset(-10);
            make.bottom.mas_equalTo(self.controlView).mas_offset(-10);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.evaluateBtn.mas_left).mas_offset(-10);
            make.bottom.mas_equalTo(self.controlView).mas_offset(-10);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.shareBtn.mas_left).mas_offset(-10);
            make.bottom.mas_equalTo(self.controlView).mas_offset(-10);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.directionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.controlView);
            make.top.mas_equalTo(self.controlView);
        }];
        
        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.controlView).mas_offset(10);
            make.bottom.equalTo(self.backView.mas_top).mas_offset(-12.5f);
            make.height.lessThanOrEqualTo(@45);
        }];
        
        [self.authorIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.controlView).mas_offset(10);
            make.bottom.equalTo(self.descriptionLabel.mas_top).mas_offset(-8);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.authorIcon.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.authorIcon);
            make.height.mas_equalTo(15);
        }];
        
        [self.gameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backView).mas_offset(10);
            make.centerY.mas_equalTo(self.backView);
            make.width.height.mas_equalTo(35);
        }];
        
        [self.gameNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.gameIcon.mas_right).mas_offset(10);
            make.top.mas_equalTo(self.gameIcon);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(self.backView).mas_offset(-10);
        }];
        
        [self.gameDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.gameIcon.mas_right).mas_offset(10);
            make.top.equalTo(self.gameNameLabel.mas_bottom).mas_offset(2);
            make.height.mas_equalTo(13);
            make.right.mas_equalTo(self.backView).mas_offset(-10);
        }];
    }else {
        NSLog(@"layout竖屏布局 W = %lf,H = %lf",KScreenW,KScreenH);
        
        [self.playImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.controlView);
            make.width.height.mas_equalTo(70);
        }];
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.controlView).offset(10);
            make.right.mas_equalTo(self.controlView).offset(-10);
            make.bottom.equalTo(self.controlView).mas_offset(-(TabBar_HEIGHT + 10));
            make.height.mas_equalTo(55);
        }];
        
        [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.controlView).mas_offset(-10);
            make.bottom.equalTo(self.controlView).mas_offset(-(TabBar_HEIGHT + 5));
            make.width.height.mas_equalTo(50);
        }];
        
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.controlView).mas_offset(-10);
            make.bottom.equalTo(self.backView.mas_top).mas_offset(-15);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.evaluateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.controlView).mas_offset(-10);
            make.bottom.equalTo(self.shareBtn.mas_top).mas_offset(-10);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.controlView).mas_offset(-10);
            make.bottom.equalTo(self.evaluateBtn.mas_top).mas_offset(-10);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.directionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.controlView).mas_offset(-10);
            make.bottom.equalTo(self.likeBtn.mas_top).mas_offset(-10);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.controlView).mas_offset(10);
            make.bottom.equalTo(self.backView.mas_top).mas_offset(-12.5f);
            make.height.lessThanOrEqualTo(@45);
        }];
        
        [self.authorIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.controlView).mas_offset(10);
            make.bottom.equalTo(self.descriptionLabel.mas_top).mas_offset(-8);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.authorIcon.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.authorIcon);
            make.height.mas_equalTo(15);
        }];
        
        [self.gameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backView).mas_offset(10);
            make.centerY.mas_equalTo(self.backView);
            make.width.height.mas_equalTo(35);
        }];
        
        [self.gameNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.gameIcon.mas_right).mas_offset(10);
            make.top.mas_equalTo(self.gameIcon);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(self.backView).mas_offset(-10);
        }];
        
        [self.gameDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.gameIcon.mas_right).mas_offset(10);
            make.top.equalTo(self.gameNameLabel.mas_bottom).mas_offset(2);
            make.height.mas_equalTo(13);
            make.right.mas_equalTo(self.backView).mas_offset(-10);
        }];
    }
    //    [super updateConstraints];
    
}

- (void)updateLayout {
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [self.bgImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.controlView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.contentView);
    }];
    
    if (KScreenW > KScreenH) {
        NSLog(@"updateLayout横屏布局 W = %lf,H = %lf",KScreenW,KScreenH);
        [self.playImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.controlView);
            make.width.height.mas_equalTo(70);
        }];
        
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.controlView).offset(0);
            make.right.mas_equalTo(self.controlView).offset(0);
            make.bottom.equalTo(self.controlView).mas_offset(0);
            make.height.mas_equalTo(55);
        }];
        
        [self.downloadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.controlView);
            make.bottom.mas_equalTo(self.controlView);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.evaluateBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.downloadBtn.mas_left).mas_offset(-10);
            make.bottom.mas_equalTo(self.controlView).mas_offset(-10);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.shareBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.evaluateBtn.mas_left).mas_offset(-10);
            make.bottom.mas_equalTo(self.controlView).mas_offset(-10);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.likeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.shareBtn.mas_left).mas_offset(-10);
            make.bottom.mas_equalTo(self.controlView).mas_offset(-10);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.directionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.controlView);
            make.top.mas_equalTo(self.controlView);
        }];
        
        [self.descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.controlView).mas_offset(10);
            make.bottom.equalTo(self.backView.mas_top).mas_offset(-12.5f);
            make.height.lessThanOrEqualTo(@45);
        }];
        
        [self.authorIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.controlView).mas_offset(10);
            make.bottom.equalTo(self.descriptionLabel.mas_top).mas_offset(-8);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.authorNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.authorIcon.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.authorIcon);
            make.height.mas_equalTo(15);
        }];
        
        [self.gameIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backView).mas_offset(10);
            make.centerY.mas_equalTo(self.backView);
            make.width.height.mas_equalTo(35);
        }];
        
        [self.gameNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.gameIcon.mas_right).mas_offset(10);
            make.top.mas_equalTo(self.gameIcon);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(self.backView).mas_offset(-10);
        }];
        
        [self.gameDescriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.gameIcon.mas_right).mas_offset(10);
            make.top.equalTo(self.gameNameLabel.mas_bottom).mas_offset(2);
            make.height.mas_equalTo(13);
            make.right.mas_equalTo(self.backView).mas_offset(-10);
        }];
    }else {
        NSLog(@"updateLayout竖屏布局 W = %lf,H = %lf",KScreenW,KScreenH);
        
        [self.playImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.controlView);
            make.width.height.mas_equalTo(70);
        }];
        
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.controlView).offset(10);
            make.right.mas_equalTo(self.controlView).offset(-10);
            make.bottom.equalTo(self.controlView).mas_offset(-(TabBar_HEIGHT + 10));
            make.height.mas_equalTo(55);
        }];
        
        [self.downloadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.controlView).mas_offset(-10);
            make.bottom.equalTo(self.controlView).mas_offset(-(TabBar_HEIGHT + 5));
            make.width.height.mas_equalTo(50);
        }];
        
        [self.shareBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.controlView).mas_offset(-10);
            make.bottom.equalTo(self.backView.mas_top).mas_offset(-15);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.evaluateBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.controlView).mas_offset(-10);
            make.bottom.equalTo(self.shareBtn.mas_top).mas_offset(-10);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.likeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.controlView).mas_offset(-10);
            make.bottom.equalTo(self.evaluateBtn.mas_top).mas_offset(-10);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.directionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.controlView).mas_offset(-10);
            make.bottom.equalTo(self.likeBtn.mas_top).mas_offset(-10);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.controlView).mas_offset(10);
            make.bottom.equalTo(self.backView.mas_top).mas_offset(-12.5f);
            make.height.lessThanOrEqualTo(@45);
        }];
        
        [self.authorIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.controlView).mas_offset(10);
            make.bottom.equalTo(self.descriptionLabel.mas_top).mas_offset(-8);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.authorNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.authorIcon.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.authorIcon);
            make.height.mas_equalTo(15);
        }];
        
        [self.gameIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backView).mas_offset(10);
            make.centerY.mas_equalTo(self.backView);
            make.width.height.mas_equalTo(35);
        }];
        
        [self.gameNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.gameIcon.mas_right).mas_offset(10);
            make.top.mas_equalTo(self.gameIcon);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(self.backView).mas_offset(-10);
        }];
        
        [self.gameDescriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.gameIcon.mas_right).mas_offset(10);
            make.top.equalTo(self.gameNameLabel.mas_bottom).mas_offset(2);
            make.height.mas_equalTo(13);
            make.right.mas_equalTo(self.backView).mas_offset(-10);
        }];
    }
}

- (NSString *)showTimes:(NSInteger)times{
    NSString *timesStr;
    if (times >= 10000) {
        timesStr = [NSString stringWithFormat:@"%.2lf",times / 10000.0];
    }else{
        timesStr = [NSString stringWithFormat:@"%ld",times];
    }
    return timesStr;
}

@end
