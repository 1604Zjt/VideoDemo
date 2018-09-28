//
//  BaseNetworking.m
//  Sing
//
//  Created by 张俊涛 on 2018/7/22.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "BaseNetworking.h"

@implementation BaseNetworking
+ (id)GET:(NSString *)path Parameters:(NSDictionary *)parameters CompletionHandler:(void (^)(id, NSError *))completionHandler {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    // 允许非权威机构颁发的证书
    manager.securityPolicy.allowInvalidCertificates = YES;
    // 不验证域名的一致性
    manager.securityPolicy.validatesDomainName = NO;
    // 关闭缓存避免干扰测试
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    // 设置请求参数的类型：JSOn
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置超时时间
    manager.requestSerializer.timeoutInterval = 20.f;
    // 设置contentType
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/xml", @"application/json", @"multipart/form-data", @"application/x-www-form-urlencoded", nil];
    return [manager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //网络请求成功时
        !completionHandler ?: completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //网络请求失败时
        !completionHandler ?: completionHandler(nil, error);
    }];
}


+ (id)POST:(NSString *)path Parameters:(NSDictionary *)parameters CompletionHandler:(void (^)(id, NSError *))completionHandler {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    
    // 允许非权威机构颁发的证书
    manager.securityPolicy.allowInvalidCertificates = YES;
    // 不验证域名的一致性
    manager.securityPolicy.validatesDomainName = NO;
    // 关闭缓存避免干扰测试
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    // 设置请求参数的类型：JSOn
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置超时时间
    manager.requestSerializer.timeoutInterval = 20.f;
    // 设置contentType
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", @"text/javascript", @"text/xml", @"image/jpeg",  @"image/png", @"application/octet-stream", nil];
    return [manager POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !completionHandler ?: completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !completionHandler ?: completionHandler(nil, error);
    }];
}
@end
