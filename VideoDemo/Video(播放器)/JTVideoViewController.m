//
//  JTVideoViewController.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/17.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTVideoViewController.h"
#import "JTFindCommunityViewController.h"
#import "JTNetworking.h"
#import "JTVideoHeaderView.h"
#import "JTVideoCell.h"
#import "AppDelegate.h"

@interface JTVideoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIWebView *webView;
@property (nonatomic) UIView *bottomView;
@property (nonatomic) UIButton *bottomBtn;

@end

@implementation JTVideoViewController

- (NSMutableArray<JTVideoAppPlaysModel *> *)dataList {
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UIWebView
    _webView = [[UIWebView alloc] init];
    [self.view addSubview:_webView];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(kScreenWidth * 9 / 16);
    }];
    
    //加载内容
    NSURL *url = [NSURL URLWithString:self.dataList[0].vvurl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JTVideoCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

/******************** tableView ********************/
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kScreenWidth * 9 / 16);
            make.left.right.equalTo(0);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.countLB.text = [NSString stringWithFormat:@"%02ld", indexPath.row + 1];
    cell.titleLB.text = self.dataList[indexPath.row].vtitle;
    cell.timerLB.text = [NSString stringWithFormat:@"%@分钟", self.dataList[indexPath.row].videoTime];
    
    cell.playsLB.text = [NSString stringWithFormat:@"%@人学习过", self.dataList[indexPath.row].plays];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

//切换播放源
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //加载内容
    NSURL *url = [NSURL URLWithString:self.dataList[indexPath.row].vvurl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

/******************** tableViewHeader ********************/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JTVideoHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"JTVideoHeaderView" owner:nil options:nil].firstObject;
    [headerView.playsBtn addTarget:self action:@selector(communityBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView.communityBtn addTarget:self action:@selector(communityBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return headerView;
}

//评论
- (void)communityBtnClick {
    JTFindCommunityViewController *vc = [[JTFindCommunityViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 218;
}

//去掉tableview的footView高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

/******************** 底部视图 ********************/
- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = SYBgColor;
        [self.view addSubview:_bottomView];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(0);
            make.height.equalTo(60);
        }];
        
        [self bottomBtn];
    }
    return _bottomView;
}

- (UIButton *)bottomBtn {
    if (_bottomBtn == nil) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_bottomBtn setTitle:@"加入学习" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _bottomBtn.backgroundColor = SYBgColor;
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_bottomBtn];
        
        [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _bottomBtn;
}


- (void)bottomBtnClick:(UIButton *)sender {
    NSLog(@"加入学习");
}










@end
