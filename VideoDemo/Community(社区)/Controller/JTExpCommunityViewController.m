//
//  JTExpCommunityViewController.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/28.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTExpCommunityViewController.h"
#import "MLSearchViewController.h"
#import "JTBookHomeViewController.h"
#import "JTCommunityViewController.h"
#import "JTExpDetailViewController.h"
#import "JTExpModel.h"

@interface JTExpCommunityViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic) NSMutableArray *pathArr;
@property (nonatomic) NSArray *dataModel;

@end

@implementation JTExpCommunityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IPHONE_X) {
        self.heightLayout.constant = 88;
        self.topLayout.constant = 40;
    }else {
        self.heightLayout.constant = 64;
        self.topLayout.constant = 20;
    }
    //UIScrollView
    self.scrollView.delegate = self;
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    //获取数据
    [self pathArr];
}

- (NSMutableArray *)pathArr {
    if (_pathArr == nil) {
        _pathArr = [[NSMutableArray alloc] init];
        NSBundle *boundle = [NSBundle mainBundle];
        NSString *path = [boundle pathForResource:@"JTExp" ofType:@"plist"];
        _pathArr = [NSMutableArray arrayWithContentsOfFile:path];
        _dataModel = [JTExpModel parse:_pathArr];
    }
    return _pathArr;
}
//搜索
- (IBAction)searchBtn:(UIButton *)sender {
    MLSearchViewController *vc = [[MLSearchViewController alloc] init];
    vc.tagsArray = @[@"交互设计入门", @"交互设计模式", @"简约至上", @"Axure交互基础"];
    
    JTBaseNaviController *navi = [[JTBaseNaviController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}

//导航栏渐变
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.topView.alpha = scrollView.contentOffset.y / (kScreenW * 188 / 375 - self.heightLayout.constant);
}
//干货分享
- (IBAction)ganhuofenxiang:(UIButton *)sender {
    JTExpModel *model = self.dataModel[sender.tag];
    JTExpDetailViewController *vc = [[JTExpDetailViewController alloc] init];
    vc.titleStr = model.titleStr;
    vc.headerImg = model.headerImg;
    vc.contentStr = model.contentStr;
    vc.contentImg = model.contentImg;
    [self.navigationController pushViewController:vc animated:YES];
}
//有问必答
- (IBAction)communityVC:(UIButton *)sender {
    JTCommunityViewController *vc = [[JTCommunityViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
//名书解读
- (IBAction)bookVC:(UIButton *)sender {
    JTBookHomeViewController *vc = [[JTBookHomeViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}









@end
