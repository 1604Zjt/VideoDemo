//
//  BaseNetworking.h
//  Sing
//
//  Created by 张俊涛 on 2018/7/22.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseNetworking : NSObject
//对AFNetworking进行的封装

//GET请求
+ (id)GET:(NSString *)path Parameters:(NSDictionary *)parameters CompletionHandler:(void(^)(id responseObj, NSError *error))completionHandler;
//POST请求
+ (id)POST:(NSString *)path Parameters:(NSDictionary *)parameters CompletionHandler:(void(^)(id responseObj, NSError *error))completionHandler;
@end
