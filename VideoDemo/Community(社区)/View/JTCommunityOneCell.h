//
//  JTCommunityOneCell.h
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/24.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTCommunityOneCellDelegate <NSObject>
- (void)btnIVClick:(NSInteger)index;
- (void)gotoCommunityDetailVC;

@end

@interface JTCommunityOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic) NSInteger btnCount;
@property (nonatomic) UIButton *btnIV;
@property (nonatomic, assign) id<JTCommunityOneCellDelegate> delegate;

@property (nonatomic, assign) BOOL zanBOOL;   
@property (weak, nonatomic) IBOutlet UILabel *timerLB;
@property (weak, nonatomic) IBOutlet UIImageView *zanIV;
@property (weak, nonatomic) IBOutlet UILabel *zanLB;
@property (weak, nonatomic) IBOutlet UILabel *pinlunLB;
@property (weak, nonatomic) IBOutlet UIView *pinlunView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;

@end
