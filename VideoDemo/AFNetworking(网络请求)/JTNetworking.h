//
//  JTNetworking.h
//  GuZheng
//
//  Created by 张俊涛 on 2018/8/20.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "BaseNetworking.h"
#import "JTUserModel.h"
#import "JTBuyModel.h"
#import "JTSearchModel.h"
#import "JTCommentModel.h"
#import "JTVideoModel.h"

typedef NS_ENUM(NSInteger , UIImageRe1Type) {
    UIImageReTypePNG,
    UIImageReTypeJEPG
};

// 成功后的回调
typedef void(^success)(NSURLSessionDataTask *task, id responseObject);
// 失败后的回调
typedef void(^failure)(NSURLSessionDataTask *task, NSError *error);
// 请求进度
typedef void(^loadProgress)(NSProgress *progress);

@interface JTNetworking : BaseNetworking

+ (instancetype)shareManager;

/**
 * POST 请求
 * @param url 请求url
 * @param paramters 请求参数
 * @param success 成功后的回调
 * @param failure 失败后的回调
 **/
- (void)POST:(NSString *)url paramters:(id)paramters success:(success)success failure:(failure)failure;

- (void)POST:(NSString *)url parameters:(NSDictionary *)parameters CompletionHandler:(void(^)(JTUserModel *model, NSError *error))completionHandler;

/**
 * POST 请求
 * @param url 请求url
 * @param paramters 请求参数
 * @param image     需要上传的图片
 * @param imageType 需要上传的图片的格式（png、jepg）
 * @param imageName 需要上传的图片的名字
 * @param success 成功后的回调
 * @param failure 失败后的回调
 **/

- (void)POSTSingleImage:(NSString *)url paramters:(id)paramters image:(UIImage *)image imageType:(UIImageRe1Type )imageType imageName:(NSString *)imageName success:(success)success failure:(failure)failure;


//购买请求
+ (id)getBuy:(NSString *)path parameters:(NSDictionary *)parameters CompletionHandler:(void(^)(JTBuyModel *model, NSError *error))completionHandler;

//搜索请求
+ (id)getSearch:(NSString *)path parameters:(NSDictionary *)parameters CompletionHandler:(void(^)(JTSearchModel *model, NSError *error))completionHandler;

//评论请求
+ (id)get:(NSString *)path parameters:(NSDictionary *)parameters CompletionHandler:(void(^)(JTCommentModel * model, NSError *error))completionHandler;


//打卡
+ (id)getStudySign:(NSString *)path parameters:(NSDictionary *)parameters CompletionHandler:(void(^)(id responseObj, NSError *error))completionHandler;
//获取进7天打卡
+ (id)postSignDay:(NSString *)path parameters:(NSDictionary *)parameters CompletionHandler:(void(^)(id responseObj, NSError *error))completionHandler;

//播单列表
+ (id)postVideoList:(NSString *)path parameters:(NSDictionary *)parameters CompletionHandler:(void(^)(JTVideoModel *model, NSError *error))completionHandler;








@end
