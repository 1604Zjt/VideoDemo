//
//  JTOneWelComeCell.m
//  Piano
//
//  Created by 张俊涛 on 2018/8/15.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTOneWelComeCell.h"
#import "JTOneDetailWelComeCell.h"

@implementation JTOneWelComeCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self.collectionView registerNib:[UINib nibWithNibName:@"JTOneDetailWelComeCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    }
    return self;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
}

- (IBAction)btnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(oneWelComeBtnClick:)]) {
        [self.delegate oneWelComeBtnClick:_index];
    }
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(300, 70);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]  initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.contentView addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.centerY.equalTo(60);
            make.size.equalTo(CGSizeMake(300, 350));
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTOneDetailWelComeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.titleLB.text = @[@"初学者", @"基础级", @"中等", @"中上等", @"高级"][indexPath.row];
    
    return cell;
}


@end
