//
//  JTSetUPViewController.m
//  Sing
//
//  Created by 张俊涛 on 2018/8/3.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTSetUPViewController.h"
#import "LXHClearCachaCell.h"
#import "JTAboutViewController.h"

@interface JTSetUPViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) UITableView *tableView;

@end

@implementation JTSetUPViewController

static NSString * const clearReuseIdentifier = @"LXHClearCachaCell";


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        cell.textLabel.text = @"关于我们";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }else {
        LXHClearCachaCell *cell1 = [tableView dequeueReusableCellWithIdentifier:clearReuseIdentifier];
        if (cell1 == nil) {
            cell1 = [[LXHClearCachaCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:clearReuseIdentifier];
        }
        return cell1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        JTAboutViewController *vc = [[JTAboutViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self clickTableViewFirstSection:indexPath];
    }
}



- (void)clickTableViewFirstSection:(NSIndexPath *)indexPath{
    
    
    LXHClearCachaCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        
    [MBProgressHUD showLoadToView:kWindow title:@"正在清除缓存···"];
        
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
            [NSThread sleepForTimeInterval:1.0];
                
            NSFileManager *mgr = [NSFileManager defaultManager];
            [mgr removeItemAtPath:LXHCustomFile error:nil];
            [mgr createDirectoryAtPath:LXHCustomFile withIntermediateDirectories:YES attributes:nil error:nil];
                
            dispatch_async(dispatch_get_main_queue(), ^{
                    
                [MBProgressHUD hideHUD];
                //清除完重新计算缓存
                [cell readCacheSize];
                    
            });
        });
    }];
}






@end
