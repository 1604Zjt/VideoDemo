//
//  TuitorListViewController.m
//  NewOffice
//
//  Created by LXH on 2017/9/9.
//  Copyright © 2017年 shineyie. All rights reserved.
//

#import "TuitorListViewController.h"
#import "TuitorListCell.h"
#import "XZChatViewController.h"


@interface TuitorListViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic) UICollectionView *collectionView;

@end

@implementation TuitorListViewController

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (kScreenWidth - 40 - 13) / 2;
        layout.minimumLineSpacing = 13;
        layout.minimumInteritemSpacing = 13;
        layout.itemSize = CGSizeMake(width, width * 288 / width);
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        _collectionView = [[UICollectionView alloc]  initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.view addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TuitorListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSArray *imageArr = @[@"laoshi_1", @"laoshi_2", @"laoshi_3", @"laoshi_4"];
    cell.iconIV.image = [UIImage imageNamed:imageArr[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XZChatViewController *chatVc = [[XZChatViewController alloc] init];
    NSMutableArray *titleArr = @[@"吴老师", @"宋老师", @"甜丽老师", @"紫函老师"].mutableCopy;
    chatVc.naviTitle = titleArr[indexPath.row];
    NSMutableArray *imageArr = @[@"wode_banner", @"bg_me", @"bg_me", @"bg_me", @"bg_me"].mutableCopy;
    chatVc.imageStr = imageArr[indexPath.row];
    
    [self.navigationController pushViewController:chatVc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TuitorListCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}


@end













