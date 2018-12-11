//
//  DKEvaluateCell.h
//  DKPlayerVideo
//
//  Created by 乔春晓 on 2018/11/20.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKBaseTableViewCell.h"

@interface DKEvaluateCell : DKBaseTableViewCell
/**
 data
 */
@property (nonatomic, strong) NSString *content;

- (CGFloat)heightForModel:(NSString *)message;
@end
