//
//  JTFindCommunityViewController.m
//  Piano
//
//  Created by 张俊涛 on 2018/8/15.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTFindCommunityViewController.h"
#import "JTNetworking.h"
#import "JTCommentCell.h"

@interface JTFindCommunityViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) UIView *bottomView;
@property (nonatomic) UIView *lineView;
@property (nonatomic) UITextField *bottomTF;
@property (nonatomic) UIButton *bottomBtn;


@property (nonatomic) UIImageView *backIV;
@property (nonatomic) UIImageView *communityIV;

@property (nonatomic) JTCommentCell *cell;


@property (nonatomic) NSMutableArray<JTCommentDataInfoModel *> *dataModel;

@end

@implementation JTFindCommunityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"JTCommentCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self data];
    
    [self bottomView];
    [self bottomTF];
    [self bottomBtn];
    [self lineView];
}

- (void)data {
    
    //获取评论数据
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderRefresh:^{
        [JTNetworking get:[NSString stringWithFormat:@"http://119.23.38.106:80/video/appCommentWeb/%@", commentID] parameters:nil CompletionHandler:^(JTCommentModel *model, NSError *error) {
            if (error) {
                [weakSelf.dataModel removeAllObjects];
                [weakSelf.tableView endHeaderRefresh];
                [weakSelf.tableView reloadData];
                weakSelf.backIV = [[UIImageView alloc] init];
                [weakSelf.tableView addSubview:weakSelf.backIV];
                
                [weakSelf.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.equalTo(0);
                    make.size.equalTo(CGSizeMake(kScreenWidth, kScreenHeight));
                }];
                weakSelf.backIV.image = [UIImage imageNamed:@"NOWiFi"];
            }else {
                [weakSelf.dataModel removeAllObjects];
                [weakSelf.dataModel addObjectsFromArray:model.dataInfo];
                [weakSelf.tableView endHeaderRefresh];
                [weakSelf.tableView reloadData];
                
                if (weakSelf.dataModel.count == 0) {
                    weakSelf.communityIV = [[UIImageView alloc] init];
                    [weakSelf.tableView addSubview:weakSelf.communityIV];
                    
                    [weakSelf.communityIV mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.left.equalTo(0);
                        make.size.equalTo(CGSizeMake(kScreenWidth, kScreenHeight));
                    }];
                    weakSelf.communityIV.image = [UIImage imageNamed:@"NOCommunity"];
                }
            }
        }];
    }];
    [self.tableView beginHeaderRefresh];
}

- (NSMutableArray<JTCommentDataInfoModel *> *)dataModel {
    if (_dataModel == nil) {
        _dataModel = [[NSMutableArray alloc] init];
    }
    return _dataModel;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
        
        CGFloat height = 0;
        if (IS_IPHONE_X) {
            height = 80;
        }else {
            height = 60;
        }
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(0);
            make.bottom.equalTo(-height);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 60;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_tableView addGestureRecognizer:tap];
    }
    return _tableView;
}

- (void)tap {
    [self.view endEditing:YES];
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        CGFloat height = 0;
        if (IS_IPHONE_X) {
            height = 80;
        }else {
            height = 60;
        }
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - height - height, kScreenW, height)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.5)];
        _lineView.backgroundColor = [UIColor blackColor];
        _lineView.alpha = 0.1;
        [_bottomView addSubview:_lineView];
    }
    return _lineView;
}

- (UITextField *)bottomTF {
    if (_bottomTF == nil) {
        _bottomTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, kScreenW - 98, 40)];
        _bottomTF.layer.cornerRadius = 20;
        _bottomTF.layer.masksToBounds = YES;
        _bottomTF.placeholder = @"  说点什么吧～";
        _bottomTF.backgroundColor = kColor(242, 242, 242);
        _bottomTF.delegate = self;
        [self.bottomView addSubview:_bottomTF];
        
        [[NSNotificationCenter
          defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:)
         name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return _bottomTF;
}

- (UIButton *)bottomBtn {
    if (_bottomBtn == nil) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_bottomBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_bottomBtn setBackgroundColor:SYBgColor];
        _bottomBtn.layer.cornerRadius = 17.5;
        _bottomBtn.layer.masksToBounds = YES;
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _bottomBtn.backgroundColor = SYBgColor;
        _bottomBtn.frame = CGRectMake(kScreenW - 68, 7.5, 58, 35);
        [self.bottomView addSubview:_bottomBtn];
        
        [_bottomBtn addTarget:self action:@selector(ceacllBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            self.bottomView.y = self.view.height - self.bottomView.height;//这里的<span style="background-color: rgb(240, 240, 240);">self.toolbar就是我的输入框。</span>
            
        } else {
            self.bottomView.y = keyboardF.origin.y - self.bottomView.height - self.bottomView.height;
        }
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2 animations:^{
        
        CGFloat height = 0;
        if (IS_IPHONE_X) {
            height = 80;
        }else {
            height = 60;
        }
        self.bottomView.frame = CGRectMake(0, kScreenH - 296 + height, kScreenW, height);
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self ceacllBtn:nil];
    
    return YES;
}

- (void)ceacllBtn:(id)sender {
    
    if ([self.bottomTF isFirstResponder]) {
        [self.bottomTF resignFirstResponder];
    }
    
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLoginKey];
    if (isLogin) {
        
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
        return;
    }
    
    [_bottomTF resignFirstResponder];
    if (_bottomTF.text.length > 0) {
        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:2];
        muDic[@"flowImage"] = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPic];
        muDic[@"flowName"] = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
        muDic[@"userId"] = [[NSUserDefaults standardUserDefaults] objectForKey:kUserID];
        muDic[@"flowTitle"] = self.bottomTF.text;
        muDic[@"appId"] = commentID;
        
        NSString *url = [NSString stringWithFormat:@"%@appCommentWeb/insert", PORTURL];
        
        [[JTNetworking shareManager] POST:url paramters:muDic success:^(NSURLSessionDataTask *task, id responseObject) {
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else {
        UIAlertController *alerC = [UIAlertController alertControllerWithTitle:@"提示" message:@"评论不可以为空哦！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *alert2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alerC addAction:alert1];
        [alerC addAction:alert2];
        [self presentViewController:alerC animated:YES completion:nil];
        return;
    }
    self.bottomTF.text = @"";
    [self data];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    _cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSInteger count = self.dataModel.count - 1 - indexPath.row;
    [_cell.flowImage sd_setImageWithURL:self.dataModel[count].flowImage.zjt_URL];
    _cell.flowName.text = self.dataModel[count].flowName;
    _cell.flowTitle.text = self.dataModel[count].flowTitle;
    [_cell.zanBtn setImage:[UIImage imageNamed:@"dianzan_weixuanzhong"] forState:UIControlStateNormal];
    [_cell.zanBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _cell.timerLB.text = [self convertTimestampsAccordingToTheLengthOfThePresentTime:[NSString stringWithFormat:@"%ld", self.dataModel[count].createdTime]];
    
    return _cell;
}

- (void)zanBtnClick:(UIButton *)sender {
    sender.selected =! sender.selected;
    if (sender.selected) {//赞
        [sender setImage:[UIImage imageNamed:@"dianzan_xuanzhong"] forState:UIControlStateNormal];
    }else {//取消
        [sender setImage:[UIImage imageNamed:@"dianzan_weixuanzhong"] forState:UIControlStateNormal];
    }
}

/**
 * 将时间戳（服务器获取）转换成时间 并计算发出的时间
 * 如果超过12小时  则返回时间格式为 年-月-日 时：分：秒
 * 否则，返回时间格式：
 *                如果，大于一小时，则为 -时-分钟前
 *                否则，返回   -分钟前
 **/
- (NSString *)convertTimestampsAccordingToTheLengthOfThePresentTime:(NSString *)timestamps {
    
    //NSString *nowTime = [self getCurrentTime:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval interval = [timestamps doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    // 获取时间差 单位为秒
    NSTimeInterval secondDifference = [nowDate timeIntervalSinceDate:date];
    NSLog(@"secondDifference == %f, %@", secondDifference, [formatter stringFromDate:date]);
    if (secondDifference < 60) {
        // 几秒前发送
        return [NSString stringWithFormat:@"%.lf秒前", roundf(secondDifference)];
    } else if (secondDifference >= 60 && secondDifference < 60 * 60) {
        return [NSString stringWithFormat:@"%.lf分钟前", roundf(secondDifference/60)];
    } else if (secondDifference >= 60 * 60 && secondDifference < 60 * 60 * 24) {
        return [NSString stringWithFormat:@"%.lf小时前", roundf(secondDifference / 3600)];
    } else if (secondDifference >= 60 * 60 * 24 && secondDifference < 60 * 60 * 24 * 28) {
        return [NSString stringWithFormat:@"%.lf天前", roundf(secondDifference / (60 * 60 * 24))];
    }
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}


@end
