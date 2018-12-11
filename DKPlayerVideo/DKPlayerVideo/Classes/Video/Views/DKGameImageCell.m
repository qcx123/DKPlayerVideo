//
//  DKGameImageCell.m
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/10/15.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKGameImageCell.h"

@implementation DKGameImageCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        [self initPlayer];
//        [self setupUI];
//        [self layout];
    }
    return self;
}

- (void)setupUI {
    _gameImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_gameImageView];
    _gameImageView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
