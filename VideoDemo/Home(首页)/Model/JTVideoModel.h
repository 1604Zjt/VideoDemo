//
//  JTVideoModel.h
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/27.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JTVideoDataInfoModel, JTVideoAppPlaysModel;

@interface JTVideoModel : NSObject
@property (nonatomic) NSString *message;
@property (nonatomic) NSString *returnCode;
@property (nonatomic) NSArray<JTVideoDataInfoModel *> *dataInfo;

@end

@interface JTVideoDataInfoModel : NSObject
//id --> ID
@property (nonatomic) NSString *ID;
@property (nonatomic) NSString *videoUrl;
@property (nonatomic) NSString *videoTitle;
@property (nonatomic) NSString *videoImage;
@property (nonatomic) NSString *pageNum;
@property (nonatomic) NSArray<JTVideoAppPlaysModel *> *appPlays;
@property (nonatomic) NSString *videoCollect;
@property (nonatomic) NSString *classNum;
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *rank;
@property (nonatomic) NSString *fristId;
@property (nonatomic) NSString *videoTime;
@property (nonatomic) NSString *tel;
@property (nonatomic) NSString *videoName;
@property (nonatomic) NSString *sequence;
@property (nonatomic) NSString *pageSize;

@end


@interface JTVideoAppPlaysModel : NSObject
@property (nonatomic) NSString *vtitle;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *vimg;
//id --> ID
@property (nonatomic) NSString *ID;
@property (nonatomic) NSString *videoTime;
@property (nonatomic) NSString *vvurl;
@property (nonatomic) NSString *plays;
@property (nonatomic) NSString *createTime;
@property (nonatomic) NSString *fatherId;

@end
