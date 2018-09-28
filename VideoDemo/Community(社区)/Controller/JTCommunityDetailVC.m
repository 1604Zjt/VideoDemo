//
//  JTCommunityDetailVC.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/25.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTCommunityDetailVC.h"
#import "JTCommentCell.h"
#import "JTCommunityDetailCell.h"
#import "JTNetworking.h"

@interface JTCommunityDetailVC ()<UITableViewDelegate, UITableViewDataSource, JTCommunityDetailCellDelegate, UITextFieldDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIView *bottomView;
@property (nonatomic) UIView *lineView;
@property (nonatomic) UITextField *bottomTF;
@property (nonatomic) UIButton *bottomBtn;


@property (nonatomic) UIImageView *backIV;
@property (nonatomic) UIImageView *communityIV;

@end

@implementation JTCommunityDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JTCommunityDetailCell" bundle:nil] forCellReuseIdentifier:@"oneCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JTCommentCell" bundle:nil] forCellReuseIdentifier:@"twoCell"];
    
    
    [self bottomView];
    [self bottomTF];
    [self bottomBtn];
    [self lineView];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JTCommunityDetailCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"oneCell" forIndexPath:indexPath];
        oneCell.btnCount = self.imageArr.count;
        oneCell.delegate = self;
        oneCell.headerIV.image = [UIImage imageNamed:self.headerStr];
        oneCell.titleLB.text = self.titleStr;
        oneCell.timerLB.text = self.timerStr;
        oneCell.contentLB.text = self.contentStr;
        [oneCell.btnIV setBackgroundColor:[UIColor redColor]];
        
        return oneCell;
    }else {
        JTCommentCell *twoCell = [tableView dequeueReusableCellWithIdentifier:@"twoCell" forIndexPath:indexPath];
        twoCell.flowImage.image = [UIImage imageNamed:@"fabu"];
        twoCell.flowName.text = @"小猪佩奇宝宝";
        twoCell.timerLB.text = @"1小时前";
        twoCell.flowTitle.text = @"很赞，学习到了！准备试一试!";
        
        return twoCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
//图片点击事件
- (void)btnIVClick:(NSInteger)index {
    NSLog(@"%ld", index);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        return 35;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 15)];
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 15)];
        titleLB.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        titleLB.textColor = [UIColor blackColor];
        titleLB.alpha = 0.7;
        titleLB.text = @"热门回复";
        
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
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
//    [self data];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



@end
