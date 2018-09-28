//
//  JTThreeWelComeCell.h
//  Piano
//
//  Created by 张俊涛 on 2018/8/15.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTThreeWelComeCellDelegate <NSObject>

- (void)threeWelComeBtnClick:(NSInteger)index;

@end

@interface JTThreeWelComeCell : UICollectionViewCell
@property (nonatomic, assign) id<JTThreeWelComeCellDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
@property (weak, nonatomic) IBOutlet UIButton *beginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *contentIV;

@end
