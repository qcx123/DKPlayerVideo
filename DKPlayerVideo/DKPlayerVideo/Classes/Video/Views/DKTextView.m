//
//  DKTextView.m
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/11/22.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKTextView.h"

@interface DKTextView()
@property (nonatomic, strong) UITextView *placeholdView;
@property (nonatomic, assign) NSInteger textHigh;
@property (nonatomic, assign) NSInteger maxTextHigh;
@end

@implementation DKTextView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview:self.placeholdView];
    [self steupUI];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.placeholdView];
        [self steupUI];
    }
    return self;
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)steupUI {
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = YES;
    self.enablesReturnKeyAutomatically = YES;
    self.layer.cornerRadius = 5;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
    
}

- (void)textChange{
    self.placeholdView.hidden = self.text.length > 0;
    NSInteger high = ceil([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    if (high < self.minHight) {
        high = self.minHight;
    }
    if (_textHigh != high) {
        //超过设定的最大高度可以滚动
        self.scrollEnabled = high >_maxTextHigh && _maxTextHigh > 0;
        _textHigh = high;
        
        if (_textHighChangeBlock && self.scrollEnabled == NO) {
            _textHighChangeBlock(self.text,high);
            [self.superview layoutIfNeeded];
            self.placeholdView.frame = self.bounds;
        }
    }
}
#pragma mark - setter && getter
- (void)setMaxLine:(NSInteger)maxLine {
    
    _maxLine = maxLine;
    //计算最大高度 = （每行高度 *总行数 +文字上下距离）
    _maxTextHigh = ceilf(self.font.lineHeight *maxLine +self.textContainerInset.top +self.textContainerInset.bottom);
}

- (void)setMinLine:(NSInteger)minLine {
    
    _minLine = minLine;
    _minHight = ceilf(self.font.lineHeight *minLine +self.textContainerInset.top +self.textContainerInset.bottom);
}
- (void)setCornerRadius:(NSInteger)cornerRadius {
    
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    _placeholderColor = placeholderColor;
    self.placeholdView.textColor = placeholderColor;
}

-(void)setPlaceholder:(NSString *)placeholder {
    
    _placeholder = placeholder;
    self.placeholdView.text = placeholder;
}

-(void)setTextHighChangeBlock:(void (^)(NSString *, CGFloat))textHighChangeBlock {
    _textHighChangeBlock = textHighChangeBlock;
    [self textChange];
    
}

#pragma mark - lazy load
- (UITextView *)placeholdView {
    
    if (!_placeholdView) {
        _placeholdView = [[UITextView alloc] init];
        _placeholdView.scrollEnabled = NO;
        _placeholdView.showsVerticalScrollIndicator = NO;
        _placeholdView.showsHorizontalScrollIndicator = NO;
        _placeholdView.userInteractionEnabled = NO;
        _placeholdView.font = self.font;
        _placeholdView.textColor = [UIColor lightGrayColor];
        _placeholdView.backgroundColor = [UIColor clearColor];
        _placeholdView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _placeholdView;
}

@end
