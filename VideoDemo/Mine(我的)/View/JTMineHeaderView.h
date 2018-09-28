//
//  JTMineHeaderView.h
//  Sing
//
//  Created by 张俊涛 on 2018/8/2.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteLoginBlock)(void);

@interface JTMineHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *userNameLB;
@property (weak, nonatomic) IBOutlet UILabel *signLB;
@property (weak, nonatomic) IBOutlet UIImageView *vipIV;

@property (nonatomic, copy) CompleteLoginBlock loginBlock;
@property (weak, nonatomic) IBOutlet UILabel *oneLB;
@property (weak, nonatomic) IBOutlet UILabel *twoLB;
@property (weak, nonatomic) IBOutlet UILabel *threeLB;
@property (weak, nonatomic) IBOutlet UILabel *fourLB;
@property (weak, nonatomic) IBOutlet UILabel *fiveLB;
@property (weak, nonatomic) IBOutlet UILabel *sixLB;














@end
