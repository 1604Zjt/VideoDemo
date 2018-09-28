//
//  JTCommentModel.m
//  Sing
//
//  Created by 张俊涛 on 2018/7/29.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTCommentModel.h"

@implementation JTCommentModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"dataInfo" : [JTCommentDataInfoModel class]};
}
@end


@implementation JTCommentDataInfoModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}
@end
