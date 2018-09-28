//
//  YTShopContentView.h
//  SYLessonDemo
//
//  Created by WYT on 2018/3/28.
//  Copyright © 2018年 dfssdfs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YTShopContentViewDelegate <NSObject>

- (void)shopContentViewClickBackButton;

- (void)shopContentViewClickBuyIdentifier:(NSString *)proIdentifier;

- (void)shopContentViewClickRestoreButton;

- (void)shopContentViewClickPrivacyButton;

- (void)shopContentViewClickUseItemButton;

@end

@interface YTShopContentView : UIView

@property (nonatomic,weak) id<YTShopContentViewDelegate> delegate;

@property (nonatomic,strong) NSArray *contentArr;
//一星期价格
@property (weak, nonatomic) IBOutlet UILabel *onePriceLB;
@property (weak, nonatomic) IBOutlet UILabel *twoPriceLB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviHeightLayout;




@end
