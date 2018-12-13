//
//  DKVideoView.m
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/11/20.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKVideoView.h"
#import "DKBaseNetProtocol.h"

#import <MJExtension.h>



@interface DKVideoView ()<UICollectionViewDelegate,UICollectionViewDataSource,DKVideoCellDelegate>

@end

static NSString *cellId = @"cellId";

@implementation DKVideoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
        [self setFrame];
    }
    return self;
}

#pragma mark -UICollectionView-

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DKVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.delegate = self;
    _playerState = PlayerState_Init;
    DKVideoModel *model = _dataArr[indexPath.item];
    cell.model = model;
    if (!_currentCell) {
        _currentCell = cell;
        [cell play];
        _playerState = PlayerState_Play;
        _currentIndex = indexPath;
        NSLog(@"===_currentIndex = %ld",_currentIndex.item);
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    DKVideoCell * cell = (DKVideoCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    if ([cell isPlaying]) {
//        [cell pause];
//        _playerState = PlayerState_Pause;
//    }else{
//        [cell resume];
//        _playerState = PlayerState_Play;
//    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == self.dataArr.count - 1) {
        [self requestVideoListWithRequestType:(RequestType_More)];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_collectionView visibleCells].count > 1) {
        _visibleCellsArray = [_collectionView visibleCells];
    }
    //    NSLog(@"%@",_visibleCellsArray);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewDidEndScroll:scrollView];
    }
}

#pragma mark - scrollView 滚动停止
- (void)scrollViewDidEndScroll:(UIScrollView *)scrollView {
    NSLog(@"停止滚动了！！！");
    for (DKVideoCell *cell in _visibleCellsArray) {
        CGRect rect = [_collectionView convertRect:cell.frame toView:self];
        if (rect.origin.y == 0) {
            if ([cell isPlaying]) {
                NSLog(@"正在播放");
            }else{
                if (cell.progressView.progress == 0.0) {
                    [cell play];
                    NSLog(@"开始播放");
                }else{
                    [cell resume];
                    NSLog(@"继续播放");
                }
            }
            _currentCell = cell;
            [cell.progressView starLoading];
            _currentIndex = [_collectionView indexPathForCell:_currentCell];
            NSLog(@"===_currentIndex = %ld",_currentIndex.item);
        }else{
            [cell stopPlay];
            cell.progressView.progress = 0.0;
            _lastCell = cell;
            NSLog(@"停止播放");
        }
    }
}

#pragma mark - 下拉刷新

- (void)headRefresh{
    [self performSelector:@selector(waiting) withObject:nil afterDelay:5.0];
}

#pragma mark - 上拉加载

- (void)footerRefresh{
    [self performSelector:@selector(waiting) withObject:nil afterDelay:5.0];
}

- (void)waiting{
//    [self.collectionView.mj_header endRefreshing];
//    [self.collectionView.mj_footer endRefreshing];
}

- (void)addObserver{
    
}

- (void)removeObserver{
    
}

- (void)dealloc{
    [self removeObserver];
}

-(void) initUI
{
    [self bgView];
    [self addSubview:self.collectionView];
}

- (void)setFrame{
//    self.collectionView.scrollEnabled = KScreenW < KScreenH;
    self.frame = CGRectMake(0, 0, KScreenW, KScreenH);
    _collectionView.frame = self.frame;
    
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flow.itemSize = CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    self.collectionView.collectionViewLayout = flow;
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    NSLog(@"_currentIndex = %ld",self.currentIndex.item);
    // Keep the collection view centered by updating the content offset
    CGPoint newContentOffset = CGPointMake(0, self.currentIndex.item * KScreenH);
    self.collectionView.contentOffset = newContentOffset;
}

- (void)reloadData {
    [_collectionView reloadData];
}

- (void)setScrollEnabled:(BOOL)scrollEnabled{
    _collectionView.scrollEnabled = scrollEnabled;
}

#pragma mark -lazy-

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(KScreenW, KScreenH);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[DKVideoCell class] forCellWithReuseIdentifier:cellId];
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        //        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
        //
        //        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    }
    return _collectionView;
}

- (UIImageView *)bgView{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_noNet"]];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self);
        }];
    }
    return _bgView;
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self reloadData];
}

#pragma mark -DKVideoCellDelegate-

- (void)netSign{
    //3G或者4G，反正用的是流量
    if ([self.delegate respondsToSelector:@selector(netSign)]) {
        [self.delegate netSign];
    }
}

- (void)actionWithType:(ActionType)actionType model:(DKVideoModel *)model{
    if ([self.delegate respondsToSelector:@selector(actionWithType:model:)]) {
        [self.delegate actionWithType:actionType model:model];
    }
}

#pragma netWork

- (void)requestVideoListWithRequestType:(RequestType)requestType{
    NSMutableDictionary *parame = [DKBaseNetProtocol getBody];
//    _currentPageNum = requestType == RequestType_Refresh ? 1 : (_currentPageNum + 1);
//    [parame setValue:@(_currentPageNum) forKey:@"pageNum"];
//    [parame setValue:PageSize forKey:@"pageSize"];
    [NetworkRequest sendDataWithUrl:ListURL parameters:parame successResponse:^(id data) {
        if ([data[@"code"] isEqualToString:@"200"]) {
            NSArray *arr = data[@"result"];
            if (requestType == RequestType_Refresh) {
                [self.dataArr removeAllObjects];
                self.dataArr = nil;
                self.dataArr = [DKVideoModel mj_objectArrayWithKeyValuesArray:arr];
            }else{
                NSMutableArray *array = [DKVideoModel mj_objectArrayWithKeyValuesArray:arr];
                [self.dataArr addObjectsFromArray:array];
            }
//            NSLog(@"%@",self.dataArr);
            [self reloadData];
        }else{
            NSLog(@"失败");
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
