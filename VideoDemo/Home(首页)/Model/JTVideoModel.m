//
//  JTVideoModel.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/27.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTVideoModel.h"

@implementation JTVideoModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"dataInfo" : [JTVideoDataInfoModel class]};
}

@end

@implementation JTVideoDataInfoModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"appPlays" : [JTVideoAppPlaysModel class]};
}

@end

@implementation JTVideoAppPlaysModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

@end
