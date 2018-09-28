//
//  TermsOfServiceController.m
//  SYLessonDemo
//
//  Created by 魏淼 on 2018/2/3.
//  Copyright © 2018年 Ijianji. All rights reserved.
//

#import "TermsOfServiceController.h"
#import <QuickLook/QuickLook.h>
@interface TermsOfServiceController ()<QLPreviewControllerDelegate,QLPreviewControllerDataSource>

@end

@implementation TermsOfServiceController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //状态栏黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //导航栏背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //设置导航栏标题文字颜色
    NSMutableDictionary *color = [NSMutableDictionary dictionary];
    color[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    color[NSForegroundColorAttributeName] = [UIColor blackColor];
    [[UINavigationBar appearance] setTitleTextAttributes:color];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super didReceiveMemoryWarning];
    self.view.backgroundColor = [UIColor whiteColor];
    [self webLoad];
    self.title = @"阅读服务条款";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back_icon_black" highImage:@"back_icon_black" target:self action:@selector(leftBarButtonItemClick)];
}


- (void)leftBarButtonItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webLoad{
    
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"服务条款.pages" ofType:nil];
//        NSURL *url = [NSURL fileURLWithPath:path];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 20, kScreenW-20, kScreenH-20)];
//    [webView loadRequest:request];
//
//    [self.view addSubview:webView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"serv.plist" ofType:nil];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    UITextView *textVIew = [[UITextView alloc] initWithFrame:self.view.frame];
    textVIew.text = dic[@"servive"];
    textVIew.editable = NO;
    [self.view addSubview:textVIew];
}
//-(void)creatQLpreviewControllLoad{
//
//    self.view.backgroundColor = [UIColor whiteColor];
//    QLPreviewController *wmService = [[QLPreviewController alloc] init];
//
//    wmService.dataSource = self;
//
//    [self presentViewController:wmService animated:YES completion:nil];
//}
//
//- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
//
//    return 1;
//}
//
//
//- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
//
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"面试宝典.pdf" ofType:nil];
//    NSURL *url = [NSURL fileURLWithPath:path];
//
//    return url;
//}

@end
