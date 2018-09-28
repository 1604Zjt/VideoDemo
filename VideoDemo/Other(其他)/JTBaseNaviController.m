//
//  JTBaseNaviController.m
//  Sing
//
//  Created by 张俊涛 on 2018/7/20.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTBaseNaviController.h"

@interface JTBaseNaviController ()

@end

@implementation JTBaseNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)initialize {
    //设置透明
    [[UINavigationBar appearance] setTranslucent:NO];
    [UINavigationBar appearance].alpha = 1;
    //设置导航栏标题文字颜色
    NSMutableDictionary *color = [NSMutableDictionary dictionary];
    color[NSFontAttributeName] = [UIFont fontWithName:@"PingFangSC-Light" size:18];
    color[NSForegroundColorAttributeName] = kColor(60, 60, 60);
    [[UINavigationBar appearance] setTitleTextAttributes:color];
    
    //拿到整个导航栏控制器外观
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    item.tintColor = [UIColor whiteColor];
    //设置字典字体大小
    NSMutableDictionary *atts = [NSMutableDictionary dictionary];
    atts[NSFontAttributeName] = [UIFont fontWithName:@"PingFangSC-Light" size:18];
    atts[NSForegroundColorAttributeName] = kColor(60, 60, 60);
    [item setTitleTextAttributes:atts forState:UIControlStateNormal];
    
    //设置导航栏背景颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    //设置导航栏背景图片
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithBackImage:@"back_icon_black" highImage:nil target:self action:@selector(popViewControllerAnimated:)];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
