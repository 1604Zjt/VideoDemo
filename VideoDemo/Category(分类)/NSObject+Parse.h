//
//  NSObject+Parse.h
//  Sing
//
//  Created by 张俊涛 on 2018/7/22.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Parse)<YYModel>
+ (id)parse:(id)JSON;

@end
