//
//  JTTwoWelComeCell.h
//  Piano
//
//  Created by 张俊涛 on 2018/8/15.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTTwoWelComeCellDelegate <NSObject>

- (void)twoWelComeBtnClick:(NSInteger)index;
- (void)gotoOneWelComeBtnClick:(NSInteger)index;

@end

@interface JTTwoWelComeCell : UICollectionViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, assign) id<JTTwoWelComeCellDelegate> delegate;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic) UICollectionView *collectionView;



@end
