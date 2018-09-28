//
//  JTPageDetailViewController.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/27.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTPageDetailViewController.h"
#import "JTVideoCollectionViewCell.h"
#import "JTVideoViewController.h"
#import "JTNetworking.h"

@interface JTPageDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSMutableArray<JTVideoDataInfoModel *> *dataList;

@end

@implementation JTPageDetailViewController

- (NSMutableArray<JTVideoDataInfoModel *> *)dataList {
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = ((kScreenW - 15 - 10 - 16) / 2);
        layout.minimumLineSpacing = 24;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake(width, width + 65);
        layout.sectionInset = UIEdgeInsetsMake(16, 15, 16, 16);
        _collectionView = [[UICollectionView alloc]  initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.view addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //网络请求
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithCapacity:2];
    mutDict[@"appId"] = kVideoAppId;
    mutDict[@"firstId"] = @"1";
    NSString *urlStr = [NSString stringWithFormat:@"%@appVideoController/getFristVideo", PORTURL];
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView addHeaderRefresh:^{
        [JTNetworking postVideoList:urlStr parameters:mutDict CompletionHandler:^(JTVideoModel *model, NSError *error) {
            [weakSelf.dataList removeAllObjects];
            
            [weakSelf.dataList addObjectsFromArray:model.dataInfo];
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView endHeaderRefresh];
            //        0 - 3 A
            //        4 - 7 K
            //        8 - 10 P
            //        11 - 14 S
        }];
    }];
    [self.collectionView beginHeaderRefresh];
    [self.collectionView registerNib:[UINib nibWithNibName:@"JTVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.index == 0) {
        return self.dataList.count - 22;
    }else if (self.index == 1) {
        return self.dataList.count - 22;
    }else if (self.index == 2) {
        return self.dataList.count - 23;
    }else {
        return self.dataList.count - 22;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (self.index == 0) {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@", kIPURL, self.dataList[indexPath.row].videoImage];
        [cell.iconIV sd_setImageWithURL:imageUrl.zjt_URL];
        cell.titleLB.text = self.dataList[indexPath.row].videoName;
        cell.countLB.text = [NSString stringWithFormat:@"%ld课时", self.dataList[indexPath.row].appPlays.count];
    }else if (self.index == 1) {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@", kIPURL, self.dataList[indexPath.row +4].videoImage];
        [cell.iconIV sd_setImageWithURL:imageUrl.zjt_URL];
        cell.titleLB.text = self.dataList[indexPath.row + 4].videoName;
        cell.countLB.text = [NSString stringWithFormat:@"%ld课时", self.dataList[indexPath.row + 4].appPlays.count];
    }else if (self.index == 2) {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@", kIPURL, self.dataList[indexPath.row + 8].videoImage];
        [cell.iconIV sd_setImageWithURL:imageUrl.zjt_URL];
        cell.titleLB.text = self.dataList[indexPath.row + 8].videoName;
        cell.countLB.text = [NSString stringWithFormat:@"%ld课时", self.dataList[indexPath.row + 8].appPlays.count];
    }else {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@", kIPURL, self.dataList[indexPath.row + 11].videoImage];
        [cell.iconIV sd_setImageWithURL:imageUrl.zjt_URL];
        cell.titleLB.text = self.dataList[indexPath.row + 11].videoName;
        cell.countLB.text = [NSString stringWithFormat:@"%ld课时", self.dataList[indexPath.row + 11].appPlays.count];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JTVideoViewController *vc = [[JTVideoViewController alloc] init];
    if (self.index == 0) {
        [vc.dataList addObjectsFromArray:self.dataList[indexPath.row].appPlays];
        vc.videoTitle = self.dataList[indexPath.row].videoTitle;
    }else if (self.index == 1) {
        [vc.dataList addObjectsFromArray:self.dataList[indexPath.row + 4].appPlays];
    }else if (self.index == 1) {
        [vc.dataList addObjectsFromArray:self.dataList[indexPath.row + 8].appPlays];
    }else {
        [vc.dataList addObjectsFromArray:self.dataList[indexPath.row + 11].appPlays];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
