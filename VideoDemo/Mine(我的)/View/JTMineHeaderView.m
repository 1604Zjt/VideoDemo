//
//  JTMineHeaderView.m
//  Sing
//
//  Created by 张俊涛 on 2018/8/2.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTMineHeaderView.h"

@implementation JTMineHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClick:)];
    
    [self.backView addGestureRecognizer:tap];
    
    self.oneLB.font = self.twoLB.font = self.threeLB.font = self.fourLB.font = self.fiveLB.font = self.sixLB.font = [UIFont fontWithName:@"DINCondensed-Bold" size:32];
}

- (void)headerViewClick:(UITapGestureRecognizer *)sender {
    NSLog(@"点击headerView");
    
    if (self.loginBlock) {
        self.loginBlock();
    }
}

@end
