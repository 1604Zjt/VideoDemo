//
//  LCBaseViewController.h
//  NeiHan
//
//  Created by  YIYOng on 17/6/13.
//  Copyright © 2017年  YIYOng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCBaseViewController : UIViewController

- (void)pop;

- (void)popToRootVc;

- (void)popToVc:(UIViewController *)vc;

- (void)dismiss;

- (void)dismissWithCompletion:(void(^)())completion;

- (void)presentVc:(UIViewController *)vc;

- (void)presentVc:(UIViewController *)vc completion:(void (^)(void))completion;

- (void)pushVc:(UIViewController *)vc;

- (void)removeChildVc:(UIViewController *)childVc;

- (void)addChildVc:(UIViewController *)childVc;


//@property (nonatomic, assign) BOOL isLogin;

@end
