
//
//  JTThreeWelComeCell.m
//  Piano
//
//  Created by 张俊涛 on 2018/8/15.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTThreeWelComeCell.h"

@implementation JTThreeWelComeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
}

- (IBAction)btnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(threeWelComeBtnClick:)]) {
        [self.delegate threeWelComeBtnClick:_index];
    }
}
@end
