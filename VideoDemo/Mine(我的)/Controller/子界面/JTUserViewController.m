//
//  JTUserViewController.m
//  Sing
//
//  Created by 张俊涛 on 2018/8/10.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTUserViewController.h"
#import "JTUserCell.h"
#import "JTUserHeaderIVCell.h"
#import "HQPickerView.h"
#import "JTNetworking.h"
#import "JTUserNameViewController.h"
#import "CSLNetworkState.h"
#import "JTNetworking.h"
@interface JTUserViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, HQPickerViewDelegate, JTUserNameViewControllerDelegate>
@property (nonatomic) JTUserHeaderIVCell *userCell;
@property (nonatomic) UIButton *outLoginBtn;
@property (nonatomic) UIImage *userHeaderIV;
@property (nonatomic, strong) CSLNetworkState *net_status;

@end

static BOOL isModifyHeaderPhoto = 0;
@implementation JTUserViewController

- (void)delegateUserNameViewControllerDidClickWithString:(NSString *)string page:(NSInteger)page {
    if (page == 0) {
        self.userName = string;
    }
    if (page == 1) {
        self.userZuoYouMing = string;
    }
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.right.equalTo(0);
            
            make.bottom.equalTo(self.outLoginBtn.mas_top).equalTo(-20);
        }];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UIButton *)outLoginBtn {
    if (_outLoginBtn == nil) {
        _outLoginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_outLoginBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_outLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _outLoginBtn.titleLabel.font = [UIFont fontWithName:kPingFangSCMedium size:20];
        [_outLoginBtn setBackgroundColor:kColor(255, 111, 69)];
        _outLoginBtn.layer.cornerRadius = 25;
        _outLoginBtn.layer.masksToBounds = YES;
        
        [self.view addSubview:_outLoginBtn];
        
        [_outLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(335, 50));
            make.centerX.equalTo(0);
            make.bottom.equalTo(-50);
        }];
        
        [_outLoginBtn addTarget:self action:@selector(outLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _outLoginBtn;
}

//退出登录
- (void)outLoginBtnClick {
    __weak typeof(self) ws = self;
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"是否确认" message:@"确认将退出登录状态" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAtn = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kIsLoginKey];
        [JTUSerDefault removeObjectForKey:kAppPic];
        [JTUSerDefault removeObjectForKey:kUserName];
        [JTUSerDefault removeObjectForKey:kZuoYouMing];
        [JTUSerDefault removeObjectForKey:KEY_UserSex];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *alertAtn1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCtl addAction:alertAtn1];
    [alertCtl addAction:alertAtn];
    [self presentViewController:alertCtl animated:YES completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        _userCell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
        _userCell.headerTitleLB.text = @"头像";
        [_userCell.headerIV sd_setImageWithURL:self.userHeader.zjt_URL placeholderImage:[UIImage imageNamed:@"touxiang"]];
        _userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return _userCell;
    }else {
        JTUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 1) {
            cell.titleLB.text = @"昵称";
            cell.detailLB.text = self.userName;
        }else if (indexPath.row == 2) {
            cell.titleLB.text = @"性别";
            cell.detailLB.text = self.userSex;
        }else {
            cell.titleLB.text = @"座右铭";
            cell.detailLB.text = self.userZuoYouMing;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 100;
    }else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self headerIV];
    }
    if (indexPath.row == 1) {
        JTUserNameViewController *vc = [[JTUserNameViewController alloc] init];
        vc.naviTitle = @"设置名字";
        vc.userTFplaceholder = self.userName;
        vc.delegate = self;
        
        JTBaseNaviController *navi = [[JTBaseNaviController alloc] initWithRootViewController:vc];
        
        [self presentViewController:navi animated:YES completion:nil];
    }
    if (indexPath.row == 2) {
        [self pickerView];
    }
    if (indexPath.row == 3) {
        JTUserNameViewController *vc = [[JTUserNameViewController alloc] init];
        vc.naviTitle = @"座右铭";
        vc.userTFplaceholder = self.userZuoYouMing;
        vc.delegate = self;
        
        JTBaseNaviController *navi = [[JTBaseNaviController alloc] initWithRootViewController:vc];
        
        [self presentViewController:navi animated:YES completion:nil];
    }
}


//设置头像
- (void)headerIV {
    // 创建UIImagePickerController对象，并设置代理和可编辑
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.editing = YES;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"修改头像" message:@"" preferredStyle:(isPad ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet)];
    
    // 从相册选择
    UIAlertAction *alertAtn1 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 跳转到UIImagePickerController控制器弹出
        [self presentViewController:imagePicker animated:YES completion:^{
        }];
    }];
    
    // 相机拍照
    UIAlertAction *alertAtn2 = [UIAlertAction actionWithTitle:@"相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }];
    // 取消
    UIAlertAction *alertAtn3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCtl addAction:alertAtn1];
    [alertCtl addAction:alertAtn2];
    [alertCtl addAction:alertAtn3];
    [self presentViewController:alertCtl animated:YES completion:^{
        
    }];
}

#pragma mark -- UIImagePickerControllerDelegate --
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    _userCell.headerIV.image = image;
    isModifyHeaderPhoto = 1;
}


//设置性别
- (void)pickerView {
    HQPickerView *picker = [[HQPickerView alloc]initWithFrame:self.view.bounds];
    picker.delegate = self ;

    picker.customArr = @[@"男", @"女"];
    [self.view addSubview:picker];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text {
    self.userSex = text;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isModifyHeaderPhoto = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"个人信息";
    [self.tableView registerNib:[UINib nibWithNibName:@"JTUserHeaderIVCell" bundle:nil] forCellReuseIdentifier:@"userCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JTUserCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithBackImage:@"back_icon_black" highImage:nil target:self action:@selector(leftBarButtonItemClick)];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(baoCunBtn)];
}



- (void)leftBarButtonItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)baoCunBtn {
    
    
    [self saveButtonWhenClicked];
}


#pragma mark -- 保存提交用户修改资料 --
- (void)saveButtonWhenClicked {
    NSLog(@"点击了保存提交用户修改资料");
    
    if (self.net_status.net_state == NO) {
        [SVProgressHUD showInfoWithStatus:@"网络不可用，请检查网络状态"];
        return;
    }
    // 获取用户的头像url
    static NSString *imageUrl = nil;
    // 判断用户是否修改了头像
    if (isModifyHeaderPhoto == 1) {
        [SVProgressHUD showImage:[UIImage imageNamed:@"发布"] status:@"正在提交头像..."];
        [[JTNetworking shareManager] POSTSingleImage:UPLOADIMAGE paramters:nil image:_userCell.headerIV.image imageType:UIImageReTypeJEPG imageName:@"headerPhoto" success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject[@"returnCode"] integerValue] == 1000) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismissWithDelay:0.25 completion:^{
                        
                        [SVProgressHUD showSuccessWithStatus:@"头像提交成功"];
                    }];
                    imageUrl = [responseObject[@"dataInfo"] objectForKey:@"url"];
                    [[NSUserDefaults standardUserDefaults] setObject:imageUrl forKey:kAppPic];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    isModifyHeaderPhoto = 0;
                    [self uploadUserInfomation:imageUrl];
                });
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    } else {
        
        imageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPic];
        [self uploadUserInfomation:imageUrl];
    }
}

// 上传用户详细资料
- (void)uploadUserInfomation:(NSString *)imageUrl {
    
    NSUserDefaults *UserDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithCapacity:2];
    paramer[@"id"] = [UserDefault objectForKey:kUserID];
    paramer[@"tel"] = [UserDefault objectForKey:kEMailKey];
    paramer[@"password"] = @"111";
    paramer[@"appAge"] = @"13";
    paramer[@"appId"] = @"10014";
    paramer[@"appName"] = [UserDefault objectForKey:kUserName];
    if ([self.userSex isEqualToString:@"男"]) {
        paramer[@"appSex"] = @"1";
    } else if ([self.userSex isEqualToString:@"女"]) {
        paramer[@"appSex"] = @"2";
    } else {
        paramer[@"appSex"] = @"3";
    }
    paramer[@"appPic"] = imageUrl;
    paramer[@"appDescribe"] = @"1";
    
    
    [SVProgressHUD showWithStatus:@"正在更新用户资料..."];
    [[JTNetworking shareManager] POST:[NSString stringWithFormat:@"%@%@", PORTURL, @"appUserWeb/update"] paramters:paramer success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"returnCode"] integerValue] == 1000) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"更新资料成功"];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:kEMailKey];
            [[NSUserDefaults standardUserDefaults] setObject:self.userZuoYouMing forKey:kZuoYouMing];
            [[NSUserDefaults standardUserDefaults] setObject:self.userSex forKey:KEY_UserSex];
            [self leftBarButtonItemClick];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"更新资料失败"];
    }];
}









- (CSLNetworkState *)net_status {
    if (!_net_status) {
        _net_status = [CSLNetworkState share];
    }
    return _net_status;
}



@end
