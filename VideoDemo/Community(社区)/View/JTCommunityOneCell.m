//
//  JTCommunityOneCell.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/24.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTCommunityOneCell.h"

@implementation JTCommunityOneCell

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
    //赞
    UITapGestureRecognizer *zanIVTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zanIVTap:)];
    self.zanIV.userInteractionEnabled = YES;
    [self.zanIV addGestureRecognizer:zanIVTap];
    self.zanBOOL = YES;
    //评论
    UITapGestureRecognizer *pinlunTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pinlunTap)];
    self.pinlunView.userInteractionEnabled = YES;
    [self.pinlunView addGestureRecognizer:pinlunTap];
}

- (void)zanIVTap:(UITapGestureRecognizer *)tap {
    if (self.zanBOOL == YES) {
        self.zanLB.text = @"31231";
        self.zanIV.image = [UIImage imageNamed:@"dianzan_xuanzhong"];
        self.zanBOOL = NO;
    }else {
        self.zanLB.text = @"21";
        self.zanIV.image = [UIImage imageNamed:@"dianzan_weixuanzhong"];
        self.zanBOOL = YES;
    }
}

- (void)pinlunTap {
    if ([self.delegate respondsToSelector:@selector(gotoCommunityDetailVC)]) {
        [self.delegate gotoCommunityDetailVC];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
