//
//  JTCommunityDetailCell.h
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/25.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTCommunityDetailCellDelegate <NSObject>
- (void)btnIVClick:(NSInteger)index;

@end

@interface JTCommunityDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *timerLB;
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic) NSInteger btnCount;
@property (nonatomic) UIButton *btnIV;
@property (nonatomic, assign) id<JTCommunityDetailCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;

@end
