//
//  JTCommunityViewController.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/24.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTCommunityViewController.h"
#import "JTFaBuViewController.h"
#import "JTCommunityOneCell.h"
#import "JTCommunityDetailVC.h"

@interface JTCommunityViewController ()<UITableViewDelegate, UITableViewDataSource, JTCommunityOneCellDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIButton *fabuBtn;
@property (nonatomic) JTCommunityOneCell *oneCell;

@end

@implementation JTCommunityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (UIButton *)fabuBtn {
    if (_fabuBtn == nil) {
        _fabuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fabuBtn setImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateNormal];
        [self.view addSubview:_fabuBtn];
        
        [_fabuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-20);
            make.bottom.equalTo(-80);
            make.size.equalTo(58);
        }];
        [_fabuBtn addTarget:self action:@selector(fabuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fabuBtn;
}

- (void)fabuBtnClick:(UIButton *)sender {
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLoginKey];
    if (isLogin) {
        JTFaBuViewController *vc = [[JTFaBuViewController alloc] init];
        
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        UIAlertController *alerC = [UIAlertController alertControllerWithTitle:@"登录才可以评论哦!" message:@"要先登录才能发表评论" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentViewController:[[JTLoginViewController alloc] init] animated:YES completion:nil];
        }];
        UIAlertAction *alert2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            return ;
        }];
        [alerC addAction:alert1];
        [alerC addAction:alert2];
        [self presentViewController:alerC animated:YES completion:nil];
    }
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _oneCell = [tableView dequeueReusableCellWithIdentifier:@"oneCell" forIndexPath:indexPath];
    _oneCell.delegate = self;
    _oneCell.btnCount = 0;
    [_oneCell btnIV];
    _oneCell.headerIV.image = [UIImage imageNamed:@"fabu"];
    _oneCell.titleLB.text = @"陈涛是哈皮";
    _oneCell.contentLB.text = @"陈涛是哈皮陈涛是哈皮陈涛是哈皮陈涛是哈皮陈涛是哈皮陈涛是哈皮陈涛是哈皮陈涛是哈皮陈涛是哈皮陈涛是哈皮陈涛是哈皮陈涛是哈皮陈涛是哈皮";
    
        
    return _oneCell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
//图片点击事件
- (void)btnIVClick:(NSInteger)index {
    NSLog(@"%ld", index);
}

//去评论
- (void)gotoCommunityDetailVC {

    JTCommunityDetailVC *vc = [[JTCommunityDetailVC alloc] init];
        
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"有问必答";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JTCommunityOneCell" bundle:nil] forCellReuseIdentifier:@"oneCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JTCommunityTwoCell" bundle:nil] forCellReuseIdentifier:@"twoCell"];
    [self fabuBtn];
}

















@end
