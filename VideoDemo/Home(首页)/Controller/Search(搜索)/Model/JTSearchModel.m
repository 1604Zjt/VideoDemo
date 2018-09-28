//
//  JTSearchModel.m
//  GuZheng
//
//  Created by 张俊涛 on 2018/8/27.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTSearchModel.h"

@implementation JTSearchModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"dataInfo" : [JTSearchDataInfoModel class]};
}
@end


@implementation JTSearchDataInfoModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}
@end
