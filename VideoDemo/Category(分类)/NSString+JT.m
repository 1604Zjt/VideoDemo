//
//  NSString+JT.m
//  Sing
//
//  Created by 张俊涛 on 2018/7/22.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "NSString+JT.h"

@implementation NSString (JT)
- (NSURL *)zjt_URL {
    return [NSURL URLWithString:self];
}
@end
