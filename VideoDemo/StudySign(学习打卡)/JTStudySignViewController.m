//
//  JTStudySignViewController.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/18.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTStudySignViewController.h"
#import "JTStudySignCell.h"
#import "JTNetworking.h"

@interface JTStudySignViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *timerLB;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *SignBtn;

@end

@implementation JTStudySignViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *path = [NSString stringWithFormat:@"http://sp.goodboybighsnsd3e.com/video/punchCard"];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:2];
    muDic[@"userId"] = [[NSUserDefaults standardUserDefaults] objectForKey:kUserID];
    muDic[@"appId"] = @"13";
    [JTNetworking postSignDay:path parameters:muDic CompletionHandler:^(id responseObj, NSError *error) {
        
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JTStudySignCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    [self reloadSignTimer];
}

//点击打卡
- (IBAction)StudySignBtn:(UIButton *)sender {
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLoginKey];
    //判断是否登录
    if (isLogin) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *agoDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"nowDate"];
        NSString *nowDay = [formatter stringFromDate:[NSDate date]];
        NSString *agoStr = [formatter stringFromDate:agoDate];
        
        if (agoStr == nil) {
            agoStr = @"";
        }
        //判断今天有没有打卡
        if ([agoStr isEqualToString:nowDay]) {
            [MBProgressHUD showSuccess:@"您已经打过卡了，明天再来吧!" toView:kWindow];
            [self.SignBtn setImage:[UIImage imageNamed:@"dakachenggong_btn"] forState:UIControlStateNormal];
        }else {
            //获取打卡时间
            [JTNetworking getStudySign:[NSString stringWithFormat:@"http://sp.goodboybighsnsd3e.com/video/punchCard?userId=%@&appId=12", [[NSUserDefaults standardUserDefaults] objectForKey:kUserID]] parameters:nil CompletionHandler:^(id responseObj, NSError *error) {
                NSLog(@"");
            }];
            NSDate *nowDate = [NSDate date];
            NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
            [dataUser setObject:nowDate forKey:@"nowDate"];
            [dataUser synchronize];
            [self DaKaShiJian];
            
            [MBProgressHUD showSuccess:@"打卡成功!" toView:kWindow];
            [self.SignBtn setImage:[UIImage imageNamed:@"dakachenggong_btn"] forState:UIControlStateNormal];
            
            //结束当天打卡时间
            [JTNetworking getStudySign:[NSString stringWithFormat:@"http://sp.goodboybighsnsd3e.com/video/punchCard/end?id=%@", [[NSUserDefaults standardUserDefaults] objectForKey:kUserID]] parameters:nil CompletionHandler:^(id responseObj, NSError *error) {
            }];
        }
        
    }else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"请先登录!" message:@"登录才能进行打卡哦!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *alert2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            JTLoginViewController *vc = [[JTLoginViewController alloc] init];
            JTBaseNaviController *navi = [[JTBaseNaviController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:navi animated:YES completion:nil];
        }];
        [alertC addAction:alert1];
        [alertC addAction:alert2];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (void)DaKaShiJian {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"打卡时间%@", dateStr] forKey:kSignTimer];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kIsLoginKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginStateChangedNotificationKey object:nil];
    self.timerLB.text = [[NSUserDefaults standardUserDefaults] objectForKey:kSignTimer];
}

- (void)reloadSignTimer {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *agoDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"nowDate"];
    NSString *nowDay = [formatter stringFromDate:[NSDate date]];
    NSString *agoStr = [formatter stringFromDate:agoDate];
    
    if (agoStr == nil) {
        agoStr = @"";
    }
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLoginKey];
    if (isLogin) {
        //判断今天有没有打卡
        if ([agoStr isEqualToString:nowDay]) {
            self.timerLB.text = [[NSUserDefaults standardUserDefaults] objectForKey:kSignTimer];
            [self.SignBtn setImage:[UIImage imageNamed:@"dakachenggong_btn"] forState:UIControlStateNormal];
        }else {
            self.timerLB.text = @"把掌声送给自己的坚持！";
            [self.SignBtn setImage:[UIImage imageNamed:@"dakaxuexi_btn"] forState:UIControlStateNormal];
        }
    }else {
        self.timerLB.text = @"把掌声送给自己的坚持！";
        [self.SignBtn setImage:[UIImage imageNamed:@"dakaxuexi_btn"] forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [self.contentView addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTStudySignCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.dayLB.text = @"今天";
    }else if (indexPath.row == 1) {
        cell.dayLB.text = @"星期一";
    }else if (indexPath.row == 2) {
        cell.dayLB.text = @"星期二";
    }else if (indexPath.row == 3) {
        cell.dayLB.text = @"星期三";
    }else if (indexPath.row == 4) {
        cell.dayLB.text = @"星期四";
    }else if (indexPath.row == 5) {
        cell.dayLB.text = @"星期五";
    }else {
        cell.dayLB.text = @"星期六";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 83;
}

@end
