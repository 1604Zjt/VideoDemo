//
//  JTUserNameViewController.h
//  Piano
//
//  Created by 张俊涛 on 2018/8/13.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTUserNameViewControllerDelegate <NSObject>

@optional
- (void)delegateUserNameViewControllerDidClickWithString:(NSString *)string page:(NSInteger)page;

@end

@interface JTUserNameViewController : UIViewController
@property (nonatomic, assign) id<JTUserNameViewControllerDelegate> delegate;
@property (nonatomic) NSString *naviTitle;
@property (nonatomic) NSString *userTFplaceholder;
@property (nonatomic) NSInteger page;

@end
