//
//  JTPageViewController.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/27.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTPageViewController.h"
#import "JTPageDetailViewController.h"

@interface JTPageViewController ()

@end

@implementation JTPageViewController

- (instancetype)init {
    if (self = [super init]) {
        self.navigationItem.title = @"必备工具篇";
        self.showOnNavigationBar = NO;
        self.titleFontName = kPingFangSCMedium;
        self.titleSizeNormal = 12;
        self.titleSizeSelected = 12;
        self.titleColorNormal = kColor(136, 136, 136);
        self.titleColorSelected = kColor(41, 75, 255);
        self.progressWidth = 12;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.progressColor = kColor(41, 75, 255);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"naviLine"];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return @[@"Axure", @"Keynote", @"Principle", @"Sketch"][index];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 4;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    JTPageDetailViewController *vc = [[JTPageDetailViewController alloc] init];
    vc.index =index;
    return vc;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = [UIColor whiteColor];
    return CGRectMake(0, 0, kScreenWidth, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
}

@end
