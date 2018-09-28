//
//  NSObject+Parse.m
//  Sing
//
//  Created by 张俊涛 on 2018/7/22.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "NSObject+Parse.h"

@implementation NSObject (Parse)
+ (id)parse:(id)JSON {
    if ([JSON isKindOfClass:[NSArray class]]) {
        return [NSArray yy_modelArrayWithClass:[self class] json:JSON];
    }
    if ([JSON isKindOfClass:[NSDictionary class]] || [JSON isKindOfClass:[NSData class]] || [JSON isKindOfClass:[NSString class]]) {
        return [self yy_modelWithJSON:JSON];
    }
    return JSON;
}

@end
