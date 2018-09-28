//
//  JTLoginViewController.m
//  Sing
//
//  Created by 张俊涛 on 2018/8/4.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTLoginViewController.h"
#import "JTBaseRequset.h"
#import "JTNetworking.h"
#import "TermsOfServiceController.h"

@interface JTLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emilTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;

@property (nonatomic,strong) JTBaseRequset *request;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeCount;

@end

@implementation JTLoginViewController

//发送验证码
- (IBAction)sendCodeButton:(UIButton *)sender {
    [self.emilTF resignFirstResponder];
    
    if ([self.emilTF.text isEqualToString:@""] && self.emilTF.text.length < 1) {
        [MBProgressHUD showError:@"邮箱不能为空" toView:kWindow];
        return;
    }
    
    if ([NSString isEmailWithString:_emilTF.text]) {
        NSLog(@"正确");
        sender.userInteractionEnabled = NO;
        
        self.request.nh_url =[NSString stringWithFormat:@"appUserWeb/sendEmail/%@",self.emilTF.text];
        [self.request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            
            NSDictionary *resultDic = (NSDictionary*)response;
            
            __weak typeof(self) weakSelf = self;
            if ([resultDic[@"returnCode"] integerValue] == 1000) {
                weakSelf.timeCount = 60;
                weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(reduceTime:) userInfo:sender repeats:YES];
                [MBProgressHUD showSuccess:@"发送成功，请注意查收" toView:kWindow];
            }
            else
            {
                sender.userInteractionEnabled = YES;
                [MBProgressHUD showError:@"发送失败" toView:kWindow];
            }
        }];
        
    } else {
        NSLog(@"邮箱格式错误 ");
        [MBProgressHUD showError:@"邮箱格式错误" toView:kWindow];
    }
}

- (void)reduceTime:(NSTimer *)codeTimer {
    
    self.timeCount--;
    if (self.timeCount == 0) {
        [_sendCodeButton setTitleColor:kColor(16, 108, 255) forState:UIControlStateNormal];
        [_sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _sendCodeButton.userInteractionEnabled = YES;
        [self.timer invalidate];
    } else {
        NSString *str = [NSString stringWithFormat:@"%lu秒后重新获取", self.timeCount];
        [_sendCodeButton setTitleColor:kColor(188, 188, 188) forState:UIControlStateNormal];
        [_sendCodeButton setTitle:str forState:UIControlStateNormal];
        _sendCodeButton.userInteractionEnabled = NO;
    }
}

//返回
- (IBAction)backBtn:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.timer invalidate];
}

//登录
- (IBAction)loginBtn:(UIButton *)sender {
    
    //注册前判断信息
    if (self.passWordTF.text.length < 1) {
        [MBProgressHUD showError:@"验证码不能为空" toView:kWindow];
        return;
    }
    
    if (self.emilTF.text.length < 1) {
        [MBProgressHUD showError:@"邮箱不能为空" toView:kWindow];
        return;
    }
    
    if (self.emilTF.text.length < 1 || self.passWordTF.text.length < 1) {
        [MBProgressHUD showError:@"账号或验证码不能为空" toView:kWindow];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@appUserWeb/insert", PORTURL];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:2];
    muDic[@"tel"] = self.emilTF.text;
    muDic[@"checkMsm"] = self.passWordTF.text;
    
    [[JTNetworking shareManager] POST:url paramters:muDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"returnCode"]integerValue] == 1006 || [responseObject[@"returnCode"]integerValue] == 1000) {
            JTUserDataInfoModel *model = [JTUserDataInfoModel parse:responseObject[@"dataInfo"]];
            [[NSUserDefaults standardUserDefaults] setObject:self.emilTF.text forKey:kEMailKey];
            [[NSUserDefaults standardUserDefaults] setObject:@"赶快设置你的座右铭吧" forKey:kZuoYouMing];
            [[NSUserDefaults standardUserDefaults] setObject:model.appPic forKey:kAppPic];
            [[NSUserDefaults standardUserDefaults] setObject:model.ID forKey:kUserID];
            [[NSUserDefaults standardUserDefaults] setObject:model.appName forKey:kUserName];
            
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kIsLoginKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginStateChangedNotificationKey object:nil];
            [MBProgressHUD showSuccess:@"登录成功!" toView:kWindow];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            [MBProgressHUD showError:@"验证码错误!" toView:kWindow];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:@"登陆失败，请检查你的账号验证码" toView:kWindow];
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"点击登录即表示您阅读并同意《用户协议》"];
    NSRange rang = [@"点击登录即表示您阅读并同意《用户协议》" rangeOfString:@"《用户协议》"];
    [string addAttribute:NSForegroundColorAttributeName value:kColor(0, 182, 255) range:rang];
    UILabel *registPromot = [[UILabel alloc] init];
    registPromot.font = [UIFont systemFontOfSize:12];
    registPromot.textColor = kColor(178, 178, 178);
    registPromot.textAlignment = NSTextAlignmentCenter;
    registPromot.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registPromotLabelOnClicked:)];
    [registPromot addGestureRecognizer:tap];
    registPromot.attributedText = string;
    [self.view addSubview:registPromot];
    [registPromot mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(0);
        make.bottom.equalTo(-40);
    }];
}

- (void)registPromotLabelOnClicked:(UITapGestureRecognizer *) gesture {
    TermsOfServiceController *wmServ = [[TermsOfServiceController alloc] init];
    
    [self.navigationController pushViewController:wmServ animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


#pragma mark - 懒加载
- (JTBaseRequset *)request {
    if (!_request) {
        _request = [JTBaseRequset nh_request];
        _request.nh_isPost = NO;
    }
    return _request;
}















@end
