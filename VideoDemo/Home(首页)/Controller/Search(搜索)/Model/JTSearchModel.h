//
//  JTSearchModel.h
//  GuZheng
//
//  Created by 张俊涛 on 2018/8/27.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JTSearchDataInfoModel;

@interface JTSearchModel : NSObject
@property (nonatomic) NSString *returnCode;
@property (nonatomic) NSString *message;
@property (nonatomic) NSArray<JTSearchDataInfoModel *> *dataInfo;

@end

@interface JTSearchDataInfoModel : NSObject
//id --> ID
@property (nonatomic) NSString *ID;
@property (nonatomic) NSString *videoId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *enName;
@property (nonatomic) NSString *grade;
@property (nonatomic) NSString *property;
@property (nonatomic) NSString *createTime;
@property (nonatomic) NSString *craeteBy;

@end

