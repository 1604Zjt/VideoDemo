//
//  JTFaBuViewController.h
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/25.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "XWPublishBaseController.h"

@interface JTFaBuViewController : XWPublishBaseController
//背景
@property (nonatomic, strong) UIView *noteTextBackgroundView;
//备注
@property (nonatomic, strong) UITextView *noteTextView;
//文字个数提示label
@property (nonatomic, strong) UILabel *textNumberLabel;
//textViewLB
@property (nonatomic) UILabel *textLB;   


@end
