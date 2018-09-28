//
//  JTNetworking.m
//  GuZheng
//
//  Created by 张俊涛 on 2018/8/20.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTNetworking.h"


static JTNetworking *network_single = nil;
static AFHTTPSessionManager *_manager = nil;

@implementation JTNetworking

+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        network_single = [[JTNetworking alloc] init];
        _manager = [AFHTTPSessionManager manager];
        // 允许非权威机构颁发的证书
        _manager.securityPolicy.allowInvalidCertificates = YES;
        // 不验证域名的一致性
        _manager.securityPolicy.validatesDomainName = NO;
        // 关闭缓存避免干扰测试
        _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        // 设置请求参数的类型：JSOn
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置超时时间
        _manager.requestSerializer.timeoutInterval = 20.f;
        // 设置contentType
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", @"text/javascript", @"text/xml", @"image/jpeg",  @"image/png", @"application/octet-stream", nil];
    });
    return network_single;
}

- (void)POST:(NSString *)url paramters:(id)paramters success:(success)success failure:(failure)failure {
    // 开启状态栏上网络请求时的菊花
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_manager POST:url parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //id newResponseObject = [CSLNetworking responseConfiguration:responseObject];
        if (success) {
            success(task, responseObject);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(task, error);
        }
        [task cancel];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (void)POST:(NSString *)url parameters:(NSDictionary *)parameters CompletionHandler:(void (^)(JTUserModel *, NSError *))completionHandler {
    // 开启状态栏上网络请求时的菊花
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self POST:url paramters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        !completionHandler ?: completionHandler([JTUserModel parse:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !completionHandler ?: completionHandler(nil, error);
    }];
}



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
- (void)POSTSingleImage:(NSString *)url paramters:(id)paramters image:(UIImage *)image imageType:(UIImageRe1Type )imageType imageName:(NSString *)imageName success:(success)success failure:(failure)failure {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_manager POST:url parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data = nil;
        NSString *fileName = nil;
        NSString *mineType = nil;
        if (imageType == UIImageReTypePNG) {
            data = UIImagePNGRepresentation(image);
            mineType = @"image/png";
            fileName = [NSString stringWithFormat:@"%@_%@.png", [[CSLMethodTools shared] getCurrentTime:@"YYYY-MM-dd-HH:mm:ss"], imageName];
        } else {
            
            data = UIImageJPEGRepresentation(image, 0.8);
            mineType = @"image/jpeg";
            fileName = [NSString stringWithFormat:@"%@_%@.jpeg", [[CSLMethodTools shared] getCurrentTime:@"YYYY-MM-dd-HH:mm:ss"], imageName];
        }
        [formData appendPartWithFileData:data name:@"fileData" fileName:fileName mimeType:mineType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

//购买
+ (id)getBuy:(NSString *)path parameters:(NSDictionary *)parameters CompletionHandler:(void (^)(JTBuyModel *, NSError *))completionHandler {
    return [self GET:path Parameters:parameters CompletionHandler:^(id responseObj, NSError *error) {
        !completionHandler ?: completionHandler([JTBuyModel parse:responseObj[@"dataInfo"]], error);
    }];
}

//搜索
+ (id)getSearch:(NSString *)path parameters:(NSDictionary *)parameters CompletionHandler:(void (^)(JTSearchModel *, NSError *))completionHandler {
    return [self GET:path Parameters:parameters CompletionHandler:^(id responseObj, NSError *error) {
        !completionHandler ?: completionHandler([JTSearchModel parse:responseObj], error);
    }];
}

//评论
+ (id)get:(NSString *)path parameters:(NSDictionary *)parameters CompletionHandler:(void (^)(JTCommentModel *, NSError *))completionHandler {
    return [self GET:path Parameters:parameters CompletionHandler:^(id responseObj, NSError *error) {
        !completionHandler ?: completionHandler([JTCommentModel parse:responseObj], error);
    }];
}

//打卡
+ (id)getStudySign:(NSString *)path parameters:(NSDictionary *)parameters CompletionHandler:(void (^)(id, NSError *))completionHandler {
    return [self GET:path Parameters:parameters CompletionHandler:^(id responseObj, NSError *error) {
        !completionHandler ?: completionHandler(responseObj, error);
    }];
}

//获取进七天打卡
+ (id)postSignDay:(NSString *)path parameters:(NSDictionary *)parameters CompletionHandler:(void (^)(id, NSError *))completionHandler {
    return [self POST:path Parameters:parameters CompletionHandler:^(id responseObj, NSError *error) {
        !completionHandler ?: completionHandler(responseObj, error);
    }];
}

//视频播单
+ (id)postVideoList:(NSString *)path parameters:(NSDictionary *)parameters CompletionHandler:(void (^)(JTVideoModel *, NSError *))completionHandler {
    return [self POST:path Parameters:parameters CompletionHandler:^(id responseObj, NSError *error) {
        !completionHandler ?: completionHandler([JTVideoModel parse:responseObj], error);
    }];
}














@end
