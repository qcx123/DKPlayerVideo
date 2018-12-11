//
//  DKVideoViewController.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/13.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKVideoViewController.h"
#import "DKViaWWANViewController.h"
#import "DKGameMainViewController.h"
#import "DKEvaluateViewController.h"
#import "GKNavigationBarViewController.h"
#import "DKLoginViewController.h"

#import "DKVideoView.h"
#import "DKVideoLeftView.h"

#import "VideoDataModel.h"
#import "VideoInfoModel.h"

#import <MJRefresh.h>
#import "UIImage+DKImage.h"
#import "UIColor+Extension.h"
#import "UIViewController+InteractivePushGesture.h"
#import <TXVodDownloadManager.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <StoreKit/StoreKit.h>

@interface DKVideoViewController ()<UIViewControllerInteractivePushGestureDelegate,DKVideoLeftViewDelegate,DKVideoViewDelegate,UIGestureRecognizerDelegate,SKStoreProductViewControllerDelegate,GKViewControllerPushDelegate>
@property (nonatomic, strong) MPVolumeView    *mpVolumeView;
@property (nonatomic, strong) DKVideoView     *videoView;
@property (nonatomic, strong) NSMutableArray  *dataArr;
@property (nonatomic, strong) DKVideoCell     *currentCell;
@property (nonatomic, strong) DKVideoLeftView *leftView;
@property (nonatomic, strong) UIImageView     *noNetView;
@property (nonatomic, strong) NSArray         *visibleCellsArray;
@property (nonatomic, assign) float       currentPlaybackTime;
@end

static NSString *cellId = @"cellId";

@implementation DKVideoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.3] size:CGSizeMake(KScreenW,TabBar_HEIGHT)];
    [self.tabBarController.tabBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(KScreenW,0.5)]];
    
    if (self.videoView.currentCell && self.videoView.playerState == PlayerState_Play) {
        [self.videoView.currentCell resume];
    }
    self.gk_pushDelegate = self;
    [self requestVideoList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = KScreenW > KScreenH;
    self.naviView.hidden = KScreenW > KScreenH;
    self.navigationController.gk_openScrollLeftPush = KScreenW < KScreenH;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.videoView.currentCell pause];
    self.gk_pushDelegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self proportyData];
    [self addObserver];
}

- (void)setFrame{
    if (self.leftView && self.leftView.isHidden == NO) {
        [self touchLeftView:self.leftView byType:DKTouchItemCoverView];
    }
    [self.videoView setFrame];
    self.naviView.frame = CGRectMake(0, 0, KScreenW, 64);
    self.leftBtn.frame = CGRectMake(15, 44, 60, 20);
    self.rightBtn.frame = CGRectMake(KScreenW - 15 - 60, 44, 60, 20);
    self.tabBarController.tabBar.hidden = KScreenW > KScreenH;
    self.naviView.hidden = KScreenW > KScreenH;
    self.navigationController.gk_openScrollLeftPush = KScreenW < KScreenH;
}

- (void)addObserver{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    //注册程序进入前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (enterForeground) name: UIApplicationWillEnterForegroundNotification object:nil];
    //注册程序进入后台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (enterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityStatusViaWWAN:) name:@"netWorkChangeEventNotification" object:nil];// 网络检测变化
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];// 系统声音变化
}

- (void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    //解除程序进入前台通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIApplicationWillEnterForegroundNotification object:nil];
    //解除程序进入后台通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netWorkChangeEventNotification" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

- (void)dealloc{
    [self removeObserver];
}

-(void) initUI
{
    [self notReachableView];
    [self setUpLeftMenuView];
    self.noNetView.hidden = YES;
    [self.view addSubview:self.videoView];
    [self setNavigation];
//    [self volumeView];
}

- (void)volumeView{
    if (_mpVolumeView == nil) {
        _mpVolumeView = [[MPVolumeView alloc] init];
        [_mpVolumeView setFrame:CGRectMake(-100, -100, 40, 40)];
        [_mpVolumeView setShowsVolumeSlider:YES];
        [_mpVolumeView sizeToFit];
    }
    [self.view addSubview:_mpVolumeView];
}

#pragma mark -lazy-

- (DKVideoView *)videoView{
    if (!_videoView) {
        _videoView = [[DKVideoView alloc] initWithFrame:self.view.bounds];
        _videoView.delegate = self;
    }
    return _videoView;
}

- (void)setNavigation{
    [self.view bringSubviewToFront:self.naviView];
    self.naviView.backgroundColor = [UIColor clearColor];
    [self.leftBtn setImage:[UIImage imageNamed:@"btn_cbl"] forState:(UIControlStateNormal)];
    [self.leftBtn setTitle:@"" forState:(UIControlStateNormal)];
    self.leftBtn.frame = CGRectMake(15, 44, 60, 20);
    [self.rightBtn setImage:[UIImage imageNamed:@"btn_phb"] forState:(UIControlStateNormal)];
    [self.rightBtn setTitle:@"" forState:(UIControlStateNormal)];
    self.rightBtn.frame = CGRectMake(KScreenW - 15 - 60, 44, 60, 20);
    self.titleLabel.text = @"";
}

#pragma mark -按钮点击事件-
- (void)leftBtnAction:(UIButton *)btn {
    [super leftBtnAction:btn];
    self.leftView.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        [self.leftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
        }];
        [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    
    //设置颜色渐变动画
    [self.leftView startCoverViewOpacityWithAlpha:0.5 withDuration:0.35];
}

- (void)rightBtnAction:(UIButton *)btn {
    NSLog(@"右按钮点击事件");
}

#pragma mark -左抽屉-
- (void)setUpLeftMenuView{
    //获取到的个人信息
    NSString *account = @"test";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"account"] = account;
    dic[@"icon"] = @"left_setting";
    
    if (!_leftView) {
        _leftView = [[DKVideoLeftView alloc] initWithFrame:CGRectZero];
        [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor clearColor];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_leftView];
        _leftView.delegate = self;
        _leftView.hidden = YES;
        [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(0);
            make.left.mas_equalTo(-KScreenW);
            make.width.mas_equalTo(KScreenW);
        }];
    }
}

//收回左侧侧边栏
- (void)hideLeftMenuView{
    [self.leftView cancelCoverViewOpacity];
    [UIView animateWithDuration:0.35 animations:^{
        [self.leftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(-KScreenW);
        }];
        
        [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        self.leftView.hidden = YES;
    }];
}

#pragma mark - DKVideoLeftViewDelegate
- (void)touchLeftView:(DKVideoLeftView *)leftView byType:(DKTouchItem)type{
    
    [self hideLeftMenuView];
    
    UIViewController *vc = nil;
    
    switch (type) {
        case DKTouchItemUserInfo:
        {
            
        }
            break;
        case DKTouchItemMineAttention:
        {
            
        }
            break;
        case DKTouchItemMineCollecttion:
        {
            
        }
            break;
        case DKTouchItemMineMsg:
        {
            
        }
            break;
        case DKTouchItemAccountBound:
        {
            
        }
            break;
        case DKTouchItemOpinionBack:
        {
            
        }
            break;
        case DKTouchItemSetting:
        {
            
        }
            break;
        case DKTouchItemQuit:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    if (vc == nil) {
        return;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - GKViewControllerPushDelegate
- (void)pushToNextViewController {
    DKGameMainViewController *personalVC = [DKGameMainViewController new];
    //隐藏tabBar
    personalVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalVC animated:YES];
}

#pragma mark -DKVideoCellDelegate-

- (void)netSign{
    //3G或者4G，反正用的是流量
    self.videoView.hidden = NO;
    self.noNetView.hidden = YES;
    [self ViaWWAN];
}

- (void)actionWithType:(ActionType)actionType model:(VideoInfoModel *)model{
    if (actionType == ActionType_Share) {// 分享
        NSLog(@"分享");
    }else if (actionType == ActionType_Like) {// 点赞
        NSLog(@"点赞");
        DKLoginViewController *loginVC = [[DKLoginViewController alloc] init];
        //把当前控制器作为背景
        self.definesPresentationContext = YES;
        //设置模态视图弹出样式
        loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:loginVC animated:NO completion:nil];
    }else if (actionType == ActionType_DownLoad) {// 下载
        NSLog(@"下载");
        [self showStoreWithId:@"1253342277"];
    }else if (actionType == ActionType_Orientation) {// 方向
        NSLog(@"方向");
        if (KScreenW > KScreenH) {
            self.appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
            //切换到竖屏
            [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
        }else {
            self.appDelegate.allowRotation = YES;//仅允许横屏关闭竖屏
            //切换到横屏
            [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
        }
    }else if (actionType == ActionType_Evaluate) {// 评论
        NSLog(@"评论");
        DKEvaluateViewController *evaluateVC = [[DKEvaluateViewController alloc] init];
        //把当前控制器作为背景
        self.definesPresentationContext = YES;
        //设置模态视图弹出样式
        evaluateVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:evaluateVC animated:NO completion:nil];
        
    }
}

#pragma mark -下载-
- (void)showStoreWithId:(NSString *)Id {
    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
    storeProductVC.delegate = self;
    NSDictionary *dic = @{SKStoreProductParameterITunesItemIdentifier: Id};
    [storeProductVC loadProductWithParameters:dic completionBlock:^(BOOL result, NSError * _Nullable error) {
        if (!error) {
            if (self.videoView.playerState == PlayState_play) {
                [self.videoView.currentCell pause];
            }
            [self presentViewController:storeProductVC animated:YES completion:^{
                
            }];
        }else{
            NSLog(@"ERROR:%@",error);
        }
    }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    if (self.videoView.playerState == PlayState_play) {
        [self.videoView.currentCell resume];
    }
}

#pragma mark -无网络界面-

- (void)notReachableView{
    if (!_noNetView) {
        _noNetView = [[UIImageView alloc] init];
        _noNetView.image = [UIImage imageNamed:@"bg_noNet"];
        _noNetView.userInteractionEnabled = YES;
        [self.view addSubview:_noNetView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_noNetView addGestureRecognizer:tap];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_wlgz"];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [_noNetView addSubview:imgView];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"网络错误，点击重新加载";
        label.font = [UIFont systemFontOfSize:PXTOPT(28)];
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.textAlignment = NSTextAlignmentCenter;
        [_noNetView addSubview:label];
        
        [_noNetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.view);
        }];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.noNetView);
            make.centerY.mas_equalTo(self.noNetView).mas_offset(-50);
            make.height.mas_equalTo(PXTOPT(144));
            make.width.mas_equalTo(PXTOPT(182));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.noNetView);
            make.top.mas_equalTo(imgView.mas_bottom).mas_equalTo(20);
            make.height.mas_equalTo(PXTOPT(30));
        }];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    NSLog(@"重新加载");
}

#pragma mark -通知-
#pragma mark -网络状态-

- (void)reachabilityStatusViaWWAN:(NSNotification *)noti{// 流量的提示
    int networkState = [[noti object] intValue];
    switch (networkState) {
        case -1:
            //未知网络状态
            self.videoView.hidden = NO;
            self.noNetView.hidden = YES;
            break;
            
        case 0:
            //没有网络
            self.videoView.hidden = YES;
            self.noNetView.hidden = NO;
            if ([self.videoView.currentCell isPlaying]) {
                [self.videoView.currentCell pause];
            }
            break;
            
        case 1:
            //3G或者4G，反正用的是流量
            self.videoView.hidden = NO;
            self.noNetView.hidden = YES;
            [self ViaWWAN];
            break;
            
        case 2:
            //WIFI网络
            self.videoView.hidden = NO;
            self.noNetView.hidden = YES;
            if (self.isViewLoaded && self.view.window) {
                NSLog(@"屏幕上");
                [self.videoView.currentCell resume];
            }
            break;
            
        default:
            break;
    }
}

- (void)ViaWWAN{
    [self.videoView.currentCell pause];
    DKViaWWANViewController *vc = [[DKViaWWANViewController alloc] initWith:^(PlayState state) {
        if (state == PlayState_play) {
            NSLog(@"继续播放");
            [self.videoView.currentCell resume];
        }else{
            NSLog(@"暂停播放");
            [self.videoView.currentCell pause];
        }
    }];
    //把当前控制器作为背景
    self.definesPresentationContext = YES;
    
    //设置模态视图弹出样式
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    //创建动画
    CATransition * transition = [CATransition animation];
    
    //设置动画类型（这个是字符串，可以搜索一些更好看的类型）
    transition.type = @"moveOut";
    
    //动画出现类型
    transition.subtype = @"fromCenter";
    
    //动画时间
    transition.duration = 0.3;
    
    //移除当前window的layer层的动画
    [self.view.window.layer removeAllAnimations];
    
    //将定制好的动画添加到当前控制器window的layer层
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self presentViewController:vc animated:NO completion:nil];
}

#pragma mark -进入前台-

- (void)enterForeground{
    if (self.videoView.currentCell && self.videoView.playerState == PlayerState_Play) {
        [self.videoView.currentCell seek:_currentPlaybackTime - 1];
//        [self.videoView.currentCell resume];
    }
}

#pragma mark -进入后台-

- (void)enterBackground{
    _currentPlaybackTime = [self.videoView.currentCell currentPlaybackTime];
//    [self.videoView.currentCell pause];
}

#pragma mark -音量显示控制-

- (void)volumeChanged:(NSNotification *)notification
{
    CGFloat volumeValue = [notification.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    [self.videoView.currentCell.progressView changeVolume:volumeValue];
}

- (void)changeRotate:(NSNotification *)notification {
    [UIView animateWithDuration:0.5 animations:^{
        [self setFrame];
    }];
}

- (void)proportyData{
    
    NSMutableArray* tempAry = [NSMutableArray array];
    NSMutableArray* mutableAry = [NSMutableArray array];
    _dataArr = [NSMutableArray array];
    __block DKVideoView *blockVideoView = _videoView;
    NSString *str = @"";
    __block NSString *blockStr = str;
    [VideoDataModel getHomePageVideoDataWithBlock:^(NSArray *dateAry, NSError *error) {
        [tempAry addObjectsFromArray:dateAry];
        NSLog(@"-----------------------");
        for (VideoDataModel* model in tempAry) {
            VideoInfoModel * item = [[VideoInfoModel alloc] init];
            item.VideoAddress = model.video_url;
            NSLog(@"%@",item.VideoAddress);
            item.coverImageAddress = model.cover_url;
            [mutableAry addObject:item];
            //        [str stringByAppendingString:[NSString stringWithFormat:@"%@,",item.VideoAddress]];
            //        str = [NSString stringWithFormat:@"@\"%@\",@\"%@\"",str,item.VideoAddress];
            blockStr = [NSString stringWithFormat:@"@\"%@\",@\"%@\"",blockStr,item.VideoAddress];
        }
        NSLog(@"%@",blockStr);
        NSLog(@"-----------------------");
        [self.dataArr addObjectsFromArray:mutableAry];
        dispatch_async(dispatch_get_main_queue(), ^{
            blockVideoView.dataArr = self.dataArr;
        });
    }];
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;// 返回YES表示隐藏，返回NO表示显示
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma netWork

- (void)requestVideoList{
    NSDictionary *parame = @{@"pageNum":@1,@"pageSize":@20};
    [NetworkRequest sendDataWithUrl:AddAdminRecommendURL parameters:parame successResponse:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
