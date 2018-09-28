//
//  JTUserNameViewController.m
//  Piano
//
//  Created by 张俊涛 on 2018/8/13.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTUserNameViewController.h"
#import "JTUserViewController.h"

@interface JTUserNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTF;

@end

@implementation JTUserNameViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.naviTitle;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightButton)];
    
    self.userTF.text = self.userTFplaceholder;
}

- (void)leftButton {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightButton {
    if ([self.naviTitle isEqualToString:@"座右铭"]) {
        self.page = 1;
    }
    if ([self.naviTitle isEqualToString:@"设置名字"]) {
        self.page = 0;
    }
    if ([self.delegate respondsToSelector:@selector(delegateUserNameViewControllerDidClickWithString:page:)]) {
        [self.delegate delegateUserNameViewControllerDidClickWithString:self.userTF.text page:self.page];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}





@end
