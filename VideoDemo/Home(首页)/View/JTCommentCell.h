//
//  JTCommentCell.h
//  Sing
//
//  Created by 张俊涛 on 2018/7/30.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *flowImage;
@property (weak, nonatomic) IBOutlet UILabel *flowName;
@property (weak, nonatomic) IBOutlet UILabel *timerLB;
@property (weak, nonatomic) IBOutlet UILabel *flowTitle;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UILabel *zanLB;


@end
