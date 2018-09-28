//
//  MineViewController.m
//  Sing
//
//  Created by 张俊涛 on 2018/8/2.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "MineViewController.h"
#import "JTMineSectionZeroCell.h"
#import "JTMineHeaderView.h"
#import "CSLNetworkState.h"
#import "JTUserViewController.h"

#import "ShopViewController.h"
#import "JTHistoryViewController.h"
#import "JTCourseViewController.h"
#import "JTSetUPViewController.h"

#import "JTBaseNaviController.h"
#import "JTBaseRequset.h"
#import "JTNetworking.h"

#import "JTNotBookViewController.h"

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) JTMineHeaderView *headerView;
@property (nonatomic) UITableView *tableView;

@property (nonatomic, strong) CSLNetworkState *networkStatus;

@property (nonatomic, strong) JTBaseRequset *request;

@property (nonatomic, strong) UIButton *vipBtn;

@property (nonatomic) JTMineSectionZeroCell *zeroCell;

@property (nonatomic) NSMutableArray<JTBuyModel *> *dataList;

@property (nonatomic) NSString *detailStr;

@end

@implementation MineViewController

//判断是否是VIP
- (BOOL)needJumpToPurchaseVC {
    
    BOOL isSubscription = [[[NSUserDefaults standardUserDefaults] objectForKey:YTSubscription] boolValue];
    
    if (isSubscription) {
        return NO;
    }else{
        return YES;
    }
}

- (NSMutableArray<JTBuyModel *> *)dataList {
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

//状态栏黑色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self isLogin];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [JTNetworking getBuy:[NSString stringWithFormat:@"%@appAudit/get/appId/%@/location/1", PORTURL, switchID] parameters:nil CompletionHandler:^(JTBuyModel *model, NSError *error) {
        if (error) {
            
        }else {
            [self.dataList removeAllObjects];
            [self.dataList addObject:model];
            [self mianfei];
            [self.tableView reloadData];
        }
    }];
    
    [self.networkStatus startMonitoringNetworkState];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JTMineSectionZeroCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (void)mianfei {
    if ([self.dataList[0].auditPass isEqualToString:@"1"]) {
        self.detailStr = @"唱歌会员免费体验";
    }
}

- (JTMineHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = _headerView = [[NSBundle mainBundle] loadNibNamed:@"JTMineHeaderView" owner:nil options:nil].firstObject;
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenW * 406 / kScreenW);
    }
    return _headerView;
}

- (void)isLogin {
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLoginKey];
    if (isLogin) {
        NSString *imageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPic];
        [self.headerView.headerIV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default pic"]];
        self.headerView.userNameLB.text = [[NSUserDefaults standardUserDefaults] objectForKey:kEMailKey];
        self.headerView.signLB.text = [[NSUserDefaults standardUserDefaults] objectForKey:kZuoYouMing];
        if ([self needJumpToPurchaseVC]) {
            self.headerView.vipIV.image = [UIImage imageNamed:@"vip_nor"];
        }else {
            self.headerView.vipIV.image = [UIImage imageNamed:@"VIP_select"];
        }
    } else {
        self.headerView.headerIV.image = [UIImage imageNamed:@"default pic"];
        self.headerView.userNameLB.text = @"请登录";
        self.headerView.signLB.text = @"支持邮箱验证码登录";
        self.headerView.vipIV.image = [UIImage imageNamed:@""];
    }
}

- (CSLNetworkState *)networkStatus {
    if (!_networkStatus) {
        _networkStatus = [CSLNetworkState share];
    }
    return _networkStatus;
}

/******************** tableView ********************/
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        
        CGFloat top = 0;
        if (IS_IPHONE_X) {
            top = -44;
        }else {
            top = -20;
        }
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.top.equalTo(top);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _zeroCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    _zeroCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        _zeroCell.titleLB.text = @"课程订阅";
    }else if (indexPath.row == 1) {
        _zeroCell.titleLB.text = @"历史记录";
    }else if (indexPath.row == 2) {
        _zeroCell.titleLB.text = @"关于我们";
    }else if (indexPath.row == 3) {
        _zeroCell.titleLB.text = @"我的备忘录";
    }else {
        _zeroCell.titleLB.text = @"VIP会员";
        _zeroCell.detailLB.text = self.detailStr;
        _zeroCell.lineView.backgroundColor = [UIColor whiteColor];
    }
    return _zeroCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        JTCourseViewController *vc = [[JTCourseViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
        JTHistoryViewController *vc = [[JTHistoryViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2) {
        JTSetUPViewController *setUPVC = [[JTSetUPViewController alloc] init];
        
        [self.navigationController pushViewController:setUPVC animated:YES];
    }else if (indexPath.row == 3) {
        JTNotBookViewController *vc = [[JTNotBookViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        ShopViewController *shopVC = [[ShopViewController alloc] init];
        
        [self presentViewController:shopVC animated:YES completion:nil];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        //判断是否已登录
        __weak typeof(self) weakSelf = self;
        _headerView.loginBlock = ^{
            BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLoginKey];
            if (isLogin) {
                JTUserViewController *userVC = [[JTUserViewController alloc] init];
                NSString *imageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPic];
                userVC.userHeader = imageUrl;
                userVC.userName= weakSelf.headerView.userNameLB.text;
                userVC.userZuoYouMing= weakSelf.headerView.signLB.text;
                userVC.userSex = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UserSex];
                [weakSelf.navigationController pushViewController:userVC animated:YES];
            } else {
                JTLoginViewController *vc = [[JTLoginViewController alloc] init];
                JTBaseNaviController *navi = [[JTBaseNaviController alloc] initWithRootViewController:vc];
                [weakSelf.navigationController presentViewController:navi animated:YES completion:nil];
            }
        };
        return _headerView;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kScreenW * 406 / kScreenW;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 24)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 24;
}

@end
