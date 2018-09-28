//
//  AppDelegate.h
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/14.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) BOOL *allowRotation;

+ (AppDelegate *)shareAppDelegate;


@end

