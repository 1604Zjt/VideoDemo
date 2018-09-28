//
//  JTOneWelComeCell.h
//  Piano
//
//  Created by 张俊涛 on 2018/8/15.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTOneWelComeCellDelegate <NSObject>

- (void)oneWelComeBtnClick:(NSInteger)index;

@end


@interface JTOneWelComeCell : UICollectionViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, assign) id<JTOneWelComeCellDelegate> delegate;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic) UICollectionView *collectionView;

@end
