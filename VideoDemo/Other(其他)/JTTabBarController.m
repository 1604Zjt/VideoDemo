//
//  JTTabBarController.m
//  Sing
//
//  Created by 张俊涛 on 2018/7/20.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTTabBarController.h"
#import "JTHomeViewController.h"
#import "JTStudySignViewController.h"
#import "JTExpCommunityViewController.h"
#import "TuitorListViewController.h"
#import "MineViewController.h"

@interface JTTabBarController ()

@end

@implementation JTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self allPropertySetup];
    [self setupAllControllers];
}

#pragma mark - 全局属性
- (void)allPropertySetup {
    [UITabBar appearance].tintColor = [UIColor whiteColor];
    [[UITabBar appearance] setTranslucent:NO];
    
    
    //设置tabbarItem字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: kColor(98, 155, 255)} forState:UIControlStateSelected];
    
    //设置tabbar背景颜色
    [UITabBar appearance].barTintColor = [UIColor whiteColor];
    
    //图片填充模式
//    [UIImageView appearance].contentMode = UIViewContentModeScaleAspectFill;
//    [UIImageView appearance].clipsToBounds = YES;
}

#pragma mark - 创建所有tabBar子控制器
- (void)setupAllControllers {
    //首页
    JTHomeViewController *homeVC = [[JTHomeViewController alloc] init];
    homeVC.tabBarItem.image = [[UIImage imageNamed:@"1_nor"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"1_sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.title = @"首页";
    JTBaseNaviController *homeNavi = [[JTBaseNaviController alloc] initWithRootViewController:homeVC];
    //打卡学习
    JTStudySignViewController *studySignVC = [[JTStudySignViewController alloc] init];
    studySignVC.tabBarItem.image = [[UIImage imageNamed:@"2_nor"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    studySignVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"2_sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    studySignVC.tabBarItem.title = @"打卡";
    studySignVC.navigationItem.title = @"学习打卡";
    JTBaseNaviController *studySignNavi = [[JTBaseNaviController alloc] initWithRootViewController:studySignVC];
    //社区
    JTExpCommunityViewController *communityVC = [[JTExpCommunityViewController alloc] init];
    communityVC.tabBarItem.image = [[UIImage imageNamed:@"3_nor"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    communityVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"3_sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    communityVC.tabBarItem.title = @"社区";
    JTBaseNaviController *communityNavi = [[JTBaseNaviController alloc] initWithRootViewController:communityVC];
    //老师
    TuitorListViewController *tuitorVC = [[TuitorListViewController alloc] init];
    tuitorVC.tabBarItem.image = [[UIImage imageNamed:@"4_nor"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tuitorVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"4_sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tuitorVC.navigationItem.title = @"名师咨询";
    tuitorVC.tabBarItem.title = @"老师";
    JTBaseNaviController *tuitorNavi = [[JTBaseNaviController alloc] initWithRootViewController:tuitorVC];

    //我的
    MineViewController *mineVC = [[MineViewController alloc] init];
    mineVC.tabBarItem.image = [[UIImage imageNamed:@"5_nor"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"5_sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.title = @"我的";
    JTBaseNaviController *mineNavi = [[JTBaseNaviController alloc] initWithRootViewController:mineVC];

    self.viewControllers = @[homeNavi, studySignNavi, communityNavi, tuitorNavi, mineNavi];
}


















@end
