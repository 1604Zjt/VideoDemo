//
//  JTOneDetailWelComeCell.m
//  Sing
//
//  Created by 张俊涛 on 2018/9/14.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTOneDetailWelComeCell.h"

@implementation JTOneDetailWelComeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.titleLB.textColor = [UIColor redColor];
        self.titleLB.alpha = 1;
    }else {
        self.titleLB.textColor = [UIColor blackColor];
        self.titleLB.alpha = 0.2;
    }
}

@end
