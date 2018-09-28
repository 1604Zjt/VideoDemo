//
//  DCPageBottomView.h
//  DCBooks
//
//  Created by cheyr on 2018/3/14.
//  Copyright © 2018年 cheyr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DCPageBottomViewDelegate<NSObject>

- (void)communityBtnClick:(UIButton *)btn;
- (void)brightnessBtnClick:(UIButton *)btn;
- (void)fontBtnClick:(UIButton *)btn;


@end


@interface DCPageBottomView : UIView
@property (nonatomic,weak) id<DCPageBottomViewDelegate> delegate;
@end
