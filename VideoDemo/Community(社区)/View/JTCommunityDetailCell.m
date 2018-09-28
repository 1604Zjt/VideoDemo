//
//  JTCommunityDetailCell.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/25.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTCommunityDetailCell.h"

@implementation JTCommunityDetailCell

- (UIButton *)btnIV {
    if (_btnIV == nil) {
        if (self.btnCount == 0) {
            self.heightLayout.constant = 1000;
            return _btnIV;
        }
        float x = 20;   //第一个按钮的X坐标
        float y = 15;   //第一个按钮的Y坐标
        float space_w = 5.5;    //第二个按钮之间的横间距
        float space_h = 5.5;    //第二个按钮之间的竖间距
        //每个按钮的宽度
        float width = (kScreenW - 2 * space_w - x * 2) / 3;
        float height = width;
        
        for (int i = 0; i < self.btnCount; i++) {
            _btnIV = [[UIButton alloc] init];
            [self.backView addSubview:_btnIV];
            [_btnIV setBackgroundColor:[UIColor redColor]];
            _btnIV.tag = i;
            NSInteger index = i % 3;    //一行三个
            NSInteger page = i / 3;     //列数
            _btnIV.frame = CGRectMake(index * (width + space_w) + x, page * (height + space_h) + y, width, height);
            //按钮事件
            [_btnIV addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    return _btnIV;
}

- (void)btn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(btnIVClick:)]) {
        [self.delegate btnIVClick:sender.tag];
    }
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
