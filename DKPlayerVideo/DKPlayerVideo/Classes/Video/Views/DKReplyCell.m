//
//  DKReplyCell.m
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/11/20.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKReplyCell.h"

@interface DKReplyCell ()
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
 to_name
 */
@property (nonatomic, strong) UILabel *to_nameLabel;
/**
 to_content
 */
@property (nonatomic, strong) UILabel *to_contentLabel;
/**
 time
 */
@property (nonatomic, strong) UILabel *timeLabel;
/**
 like
 */
@property (nonatomic, strong) UIButton *likeBtn;
@end

@implementation DKReplyCell{
    UIView *lineView;
}

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

- (void)setupUI {
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:[self lineView]];
    [self.contentView addSubview:self.to_nameLabel];
    [self.contentView addSubview:self.to_contentLabel];
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
        make.height.mas_equalTo(8);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.right.mas_equalTo(self.likeBtn.mas_left).mas_offset(-10);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(3);
        make.height.lessThanOrEqualTo(@50);
    }];
    
    [self.to_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset(3);
        make.left.mas_equalTo(self.nameLabel).mas_offset(2);
        make.right.mas_equalTo(self.likeBtn.mas_left);
        make.height.mas_equalTo(8);
    }];
    
    [self.to_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.to_nameLabel);
        make.right.mas_equalTo(self.likeBtn.mas_left).mas_offset(-10);
        make.top.mas_equalTo(self.to_nameLabel.mas_bottom).mas_offset(3);
        make.height.lessThanOrEqualTo(@100);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.to_nameLabel);
        make.left.mas_equalTo(self.nameLabel);
        make.bottom.mas_equalTo(self.to_contentLabel);
        make.width.mas_equalTo(1);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.to_contentLabel.mas_bottom).mas_offset(3);
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
        _contentLabel.text = @"春晓";
        _contentLabel.numberOfLines = 3;
    }
    return _contentLabel;
}

- (UIView *)lineView{
    if (!lineView) {
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor grayColor];
    }
    return lineView;
}

- (UILabel *)to_nameLabel{
    if (!_to_nameLabel) {
        _to_nameLabel = [[UILabel alloc] init];
        _to_nameLabel.textColor = [UIColor whiteColor];
        _to_nameLabel.text = @"春晓";
    }
    return _to_nameLabel;
}

- (UILabel *)to_contentLabel{
    if (!_to_contentLabel) {
        _to_contentLabel = [[UILabel alloc] init];
        _to_contentLabel.textColor = [UIColor whiteColor];
        _to_contentLabel.numberOfLines = 3;
        _to_contentLabel.text = @"中新网4月17日电  据韩联社报道，韩国海洋水产部(简称“海水部”)“世越号”现场处理本部和负责世越号船体清理工作的韩国打捞局(Korea Salvage)为方便搜寻失踪者遗体的工作人员开展工作已于17日完成护栏安装，预计失踪者遗体搜寻工作有望于18日正式启动这是第三个,3月28日，在将“世越”号船体运往木浦新港前，工作人员也同样在半潜船甲板上发现过动物尸骨。本月2日，工作人员曾在半潜船甲板上发现9块动物尸骨、“世越”号船长李某的护照及手提包、信用卡、圆珠笔等物品，但截至目前仍未发现9名失踪者的遗体。,2014年4月16日，“世越”号在全罗南道珍岛郡附近水域沉没，共致295人遇难，迄今仍有9人下落不明，遇难者大多是学生。";
    }
    return _to_contentLabel;
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
