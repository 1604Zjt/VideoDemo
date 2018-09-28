//
//  DCPageBottomView.m
//  DCBooks
//
//  Created by cheyr on 2018/3/14.
//  Copyright © 2018年 cheyr. All rights reserved.
//

#import "DCPageBottomView.h"
#import "SDAutoLayout.h"

@interface DCPageBottomView()
//@property (nonatomic,strong) UIButton *listBtn;
//@property (nonatomic,strong) UIButton *nightModeBtn;
//@property (nonatomic,strong) UIButton *fontAddBtn;
//@property (nonatomic,strong) UIButton *fontSubtractBtn;


@property (nonatomic) UIButton *communityBtn;
@property (nonatomic) UIButton *brightnessBtn;
@property (nonatomic) UIButton *fontBtn;

@end


@implementation DCPageBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor darkGrayColor];
        [self setupUI];
        

    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat btnW = 24;
    CGFloat btnH = btnW;
    CGFloat btnY = 20;

    self.communityBtn.frame = CGRectMake(54, btnY, btnW, btnH);
    self.brightnessBtn.frame = CGRectMake((kScreenW - btnW) / 2, btnY, btnW, btnH);
    self.fontBtn.frame = CGRectMake(kScreenW - 54 - btnW, btnY, btnW, btnH);
}
-(void)setupUI
{
    [self addSubview:self.communityBtn];
    [self addSubview:self.brightnessBtn];
    [self addSubview:self.fontBtn];
}

- (UIButton *)communityBtn {
    if (_communityBtn == nil) {
        _communityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_communityBtn setImage:[UIImage imageNamed:@"book_pinglun"] forState:UIControlStateNormal];
        [_communityBtn addTarget:self action:@selector(communityBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _communityBtn;
}

- (UIButton *)brightnessBtn {
    if (_brightnessBtn == nil) {
        _brightnessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_brightnessBtn setImage:[UIImage imageNamed:@"book_liangdu"] forState:UIControlStateNormal];
        [_brightnessBtn addTarget:self action:@selector(brightnessBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _brightnessBtn;
}

- (UIButton *)fontBtn {
    if (_fontBtn == nil) {
        _fontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fontBtn setImage:[UIImage imageNamed:@"book_ziti"] forState:UIControlStateNormal];
        [_fontBtn addTarget:self action:@selector(fontBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fontBtn;
}

- (void)communityBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(communityBtnClick:)]) {
        [self.delegate communityBtnClick:sender];
    }
}

- (void)brightnessBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(brightnessBtnClick:)]) {
        [self.delegate brightnessBtnClick:sender];
    }
}

- (void)fontBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(fontBtnClick:)]) {
        [self.delegate fontBtnClick:sender];
    }
}



@end
