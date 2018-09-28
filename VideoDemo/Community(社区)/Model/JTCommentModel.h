//
//  JTCommentModel.h
//  Sing
//
//  Created by 张俊涛 on 2018/7/29.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JTCommentDataInfoModel;

@interface JTCommentModel : NSObject
@property (nonatomic) NSString *message;
@property (nonatomic) NSString *returnCode;
@property (nonatomic) NSArray<JTCommentDataInfoModel *> *dataInfo;

@end

@interface JTCommentDataInfoModel :NSObject
@property (nonatomic) NSString *flowImage;
//id --> ID
@property (nonatomic) NSInteger ID;
@property (nonatomic) NSString *flowName;
@property (nonatomic) NSInteger userId;
@property (nonatomic) NSInteger createdTime;
@property (nonatomic) NSString *flowTitle;
@property (nonatomic) NSInteger agree;
@property (nonatomic) NSInteger commentNum;
@property (nonatomic) NSString *pageSize;
@property (nonatomic) NSString *pageNum;
@property (nonatomic) NSInteger appId;


@end


