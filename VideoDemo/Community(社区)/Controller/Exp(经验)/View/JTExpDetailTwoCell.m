//
//  JTExpDetailTwoCell.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/28.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTExpDetailTwoCell.h"

@implementation JTExpDetailTwoCell

- (UILabel *)contentLB {
    if (_contentLB == nil) {
        _contentLB = [[UILabel alloc] init];
        [self.contentView addSubview:_contentLB];
        _contentLB.numberOfLines = 0;
        _contentLB.textColor = kColor(135, 135, 135);
        _contentLB.font = [UIFont fontWithName:kPingFangSCLight size:16];
        
        [_contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.right.equalTo(-20);
            make.top.equalTo(0);
        }];
        
    }
    return _contentLB;
}

- (UIImageView *)contentIV {
    if (_contentIV == nil) {
        _contentIV = [[UIImageView alloc] init];
        _contentIV.contentMode = UIViewContentModeScaleAspectFill;
        _contentIV.clipsToBounds = YES;
        [self.contentView addSubview:_contentIV];
        
        [_contentIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLB.mas_bottom).equalTo(10);
            make.bottom.equalTo(-10);
            make.left.right.equalTo(0);
        }];
    }
    return _contentIV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
