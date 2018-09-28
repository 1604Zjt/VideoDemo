//
//  UIBarButtonItem+Extension.h
//  NaMiHe
//
//  Created by Lxh on 2017/6/2.
//  Copyright © 2017年 LXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
+ (instancetype)itemWithBackImage:(NSString *)backImage highImage:(NSString *)highImage target:(id)target action:(SEL)action;

+ (instancetype)itemWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle target:(id)target action:(SEL)action;
@end
