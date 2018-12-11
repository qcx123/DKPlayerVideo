//
//  DKEvaluateCell.m
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/11/20.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKEvaluateCell.h"


@interface DKEvaluateCell ()
/**
 header
 */
@property (nonatomic, strong) UIImageView *headerView;
/**
 name
 */
@property (nonatomic, strong) UILabel *nameLabel;
/**
 content
 */
@property (nonatomic, strong) UILabel *contentLabel;
/**
 time
 */
@property (nonatomic, strong) UILabel *timeLabel;
/**
 like
 */
@property (nonatomic, strong) UIButton *likeBtn;
@end

@implementation DKEvaluateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self layout];
    }
    return self;
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.contentLabel.text = _content;
}

- (CGFloat)heightForModel:(NSString *)message {
    [self setContent:message];
    [self layoutIfNeeded];
    
    CGFloat cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height+1;
    
    return cellHeight;
}

- (void)setupUI {
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.likeBtn];
}

- (void)layout {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.contentView).mas_offset(5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(3);
        make.right.mas_equalTo(self.contentView).mas_offset(-3);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView);
        make.left.mas_equalTo(self.headerView.mas_right).mas_offset(2);
        make.right.mas_equalTo(self.likeBtn.mas_left);
        make.width.mas_equalTo(8);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.right.mas_equalTo(self.likeBtn.mas_left).mas_offset(-10);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(3);
        make.height.lessThanOrEqualTo(@100);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset(3);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-5);
    }];
}

- (void)likeAction:(UIButton *)btn{
    NSLog(@"评论点赞");
}

#pragma mark -lazy-

- (UIImageView *)headerView{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.image = [UIImage imageNamed:@"btn_tx"];
    }
    return _headerView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = @"春晓";
    }
    return _nameLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.numberOfLines = 3;
        _contentLabel.text = @"春晓";
    }
    return _contentLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.text = @"刚刚";
    }
    return _timeLabel;
}

- (UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_likeBtn setImage:[UIImage imageNamed:@"btn_dianz"] forState:(UIControlStateNormal)];
        [_likeBtn setTitle:@"666" forState:(UIControlStateNormal)];
        _likeBtn.frame = CGRectMake(0, 0, 50, 50);
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:8];
        [_likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self setButtonContentCenter:_likeBtn];
    }
    return _likeBtn;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
