//
//  AppDelegate.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/14.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "AppDelegate.h"
#import "JTBookDetailViewController.h"
#import "JTWelComeViewController.h"
#import "JTTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //创建根目录
    [DCFileTool creatRootDirectory];
    //tableViewCell点击不变灰
    [[UITableViewCell appearance] setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //app睡上2秒
    [NSThread sleepForTimeInterval:2.0f];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //判断版本是否进入欢迎页
//    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//    NSString *key = @"CFBundleShortVersionString";
//    NSString *currentVersion = infoDic[key];
//    NSString *runVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
//
//    if (runVersion == nil || ![runVersion isEqualToString:currentVersion]) {
//
//        _window.rootViewController = [[JTWelComeViewController alloc] init];
//    }else{
        _window.rootViewController  = [[JTTabBarController alloc] init];
//    }
    [_window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    if (url) {
        
        NSString *fileNameStr = [url lastPathComponent];
        fileNameStr = [fileNameStr stringByRemovingPercentEncoding];
        
        NSString *toPath = [DCBooksPath stringByAppendingPathComponent:fileNameStr];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        [data writeToFile:toPath atomically:YES];
        
        
        //用阅读器打开这个文件
        JTBookDetailViewController *vc = [[JTBookDetailViewController alloc]init];
        vc.filePath = toPath;
        JTBaseNaviController *nav = (JTBaseNaviController *)self.window.rootViewController;
        [nav.topViewController.navigationController pushViewController:vc animated:YES];
    }
    return YES;
}


+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}


@end
