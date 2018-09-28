//
//  JTAboutViewController.m
//  Sing
//
//  Created by 张俊涛 on 2018/8/6.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTAboutViewController.h"
#import "FeedbackViewController.h"
#import "PrivacyViewController.h"
#import "JTAboutCell.h"

@interface JTAboutViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIView *topView;
@property (nonatomic) UIImageView *logoIV;

@end

@implementation JTAboutViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self topView];
    [self logoIV];
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = kColor(242, 242, 242);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JTAboutCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        [self.view addSubview:_topView];
        
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(0);
            make.height.equalTo(kScreenWidth * 183 / kScreenWidth);
        }];
    }
    return _topView;
}

- (UIImageView *)logoIV {
    if (_logoIV == nil) {
        _logoIV = [[UIImageView alloc] init];
        _logoIV.image = [UIImage imageNamed:@"mine_logo"];
        _logoIV.backgroundColor = [UIColor redColor];
        [self.topView addSubview:_logoIV];
        
        [_logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _logoIV;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(self.topView.mas_bottom);
            make.height.equalTo(244);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.titleLB.text = @"版本号";
            cell.detailLB.text = @"1.0";
        }else {
            cell.titleLB.text = @"联系邮箱";
            cell.detailLB.text = @"fiveonewell51@163.com";
        }
    }else {
        if (indexPath.row == 0) {
            cell.titleLB.text = @"意见反馈";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else {
            cell.titleLB.text = @"给我们打分";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            FeedbackViewController *vc = [[FeedbackViewController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8", GoToAppleID];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 12)];
    headerView.backgroundColor = kColor(242, 242, 242);
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    footerView.backgroundColor = kColor(242, 242, 242);
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

@end
