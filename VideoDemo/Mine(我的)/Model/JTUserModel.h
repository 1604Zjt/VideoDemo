//
//  JTUserModel.h
//  Sing
//
//  Created by 张俊涛 on 2018/8/10.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JTUserDataInfoModel;

@interface JTUserModel : NSObject
@property (nonatomic) NSString *returnCode;
@property (nonatomic) NSString *message;
@property (nonatomic) NSString *dataInfo;

@end


@interface JTUserDataInfoModel : NSObject
//id -->ID
@property (nonatomic) NSString *ID;
@property (nonatomic) NSString *tel;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *appAge;
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *appName;
@property (nonatomic) NSString *appSex;
@property (nonatomic) NSString *appPic;
@property (nonatomic) NSString *appDescribe;
@property (nonatomic) NSString *createdTime;
@property (nonatomic) NSString *checkMsm;
@end
