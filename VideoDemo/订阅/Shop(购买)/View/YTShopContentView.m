//
//  YTShopContentView.m
//  SYLessonDemo
//
//  Created by WYT on 2018/3/28.
//  Copyright © 2018年 Ijianji. All rights reserved.
//

#import "YTShopContentView.h"

@interface YTShopContentView ()

@property (nonatomic, strong) NSArray *idArray;


@end


@implementation YTShopContentView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    //修改约束
    if (IS_IPHONE_X) {
        self.naviHeightLayout.constant = 88;
    }else {
        self.naviHeightLayout.constant = 64;
    }
    
    
    _idArray = kProductIDArray;
}



-(void)setContentArr:(NSArray *)contentArr{
    _contentArr = contentArr;
    
}

// 返回
- (IBAction)backBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shopContentViewClickBackButton)]) {
        [self.delegate shopContentViewClickBackButton];
    }
}



// 立即购买
- (IBAction)shopBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shopContentViewClickBuyIdentifier:)]) {
        [self.delegate shopContentViewClickBuyIdentifier:_idArray[sender.tag]];
    }
}


// 恢复订阅
- (IBAction)clickRestoreButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shopContentViewClickRestoreButton)]) {
        [self.delegate shopContentViewClickRestoreButton];
    }
}



// 隐私政策
- (IBAction)clickPrivacyButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shopContentViewClickPrivacyButton)]) {
        [self.delegate shopContentViewClickPrivacyButton];
    }
}


// 使用条款
- (IBAction)clickUseItem:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shopContentViewClickUseItemButton)]) {
        [self.delegate shopContentViewClickUseItemButton];
    }
}






@end

















