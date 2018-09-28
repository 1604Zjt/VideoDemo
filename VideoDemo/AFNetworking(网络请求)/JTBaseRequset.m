//
//  JTBaseRequset.m
//  Sing
//
//  Created by 张俊涛 on 2018/8/5.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTBaseRequset.h"
#import "LCRequsetManager.h"

@implementation JTBaseRequset

+ (instancetype)nh_request {
    return [[self alloc] init];
}

+ (instancetype)nh_requestWithUrl:(NSString *)nh_url {
    return [self nh_requestWithUrl:nh_url isPost:NO];
}

+ (instancetype)nh_requestWithUrl:(NSString *)nh_url isPost:(BOOL)nh_isPost {
    return [self nh_requestWithUrl:nh_url isPost:nh_isPost delegate:nil];
}

+ (instancetype)nh_requestWithUrl:(NSString *)nh_url isPost:(BOOL)nh_isPost delegate:(id <JTBaseRequestReponseDelegate>)nh_delegate {
    JTBaseRequset *request = [self nh_request];
    request.nh_url = nh_url;
    request.nh_isPost = nh_isPost;
    request.nh_delegate = nh_delegate;
    return request;
}

#pragma mark - 发送请求
-(void)nh_sendRequest{
    
}

-(void)nh_sendRequestWithCompletion:(LCAPIDicCompletion)completion{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", PORTURL, self.nh_url];
    
    if (urlStr.length == 0) {
        return;
    }
    NSLog(@"urlStr=%@",urlStr);
    NSDictionary *params = [self params];
    /**普通POST请求**/
    if (self.nh_isPost) {
        if (self.nh_imageArray.count == 0) {
            
            [LCRequsetManager POST:urlStr parameters:params responseSeializerType:LCResponseSeializerTypeJSON success:^(id responseObject) {
                
                [self handleResponse:responseObject completion :completion];
            } failure:^(NSError *error) {
                NSLog(@"request fail");
            }];
        }
    }
    else
    {
        /**GET请求**/
        [LCRequsetManager GET:[urlStr noWhiteSpaceString] parameters:params responseSeializerType:LCResponseSeializerTypeJSON success:^(id responseObject) {
            NSLog(@"responseObject =%@",responseObject);
            
            [self handleResponse:responseObject completion:completion];
            
        } failure:^(NSError *error) {
            NSLog(@"error=%@",error);
            
        }];
        
        
    }
    
    /**上传图片**/
    
    if(self.nh_imageArray.count)
    {
        [LCRequsetManager POST:[urlStr noWhiteSpaceString] parameters:params responseSeializerType:LCResponseSeializerTypeJSON constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSInteger imgCount = 0;
            for (UIImage  *image in self.nh_imageArray) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";
                
                NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(imgCount)];
                [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"file" fileName:fileName mimeType:@"image/png"];
                imgCount++;
            }
            
        } success:^(id responseObject) {
            [self handleResponse:responseObject completion:completion];
        } failure:^(NSError *error) {
            
            
        }];
    }
    
}


-(void)handleResponse:(id)responseObject completion :(LCAPIDicCompletion)completion{
    BOOL success = NO;
    if (responseObject  == nil) {
        [self nh_sendRequestWithCompletion:completion];
        return;
    }
    
    //NSLog(@"responseObject= %@",responseObject);
    //成功 处理数据
    
    
    
    if (completion)
    {
        completion(responseObject,success,nil);
    }
    else if (self.nh_delegate)
    {
        if ([self.nh_delegate respondsToSelector:@selector(requestSuccessReponse:response:message:)]) {
            [self.nh_delegate requestSuccessReponse:success response:responseObject message:responseObject[@"msg"]];
        }
    }
    //请求成功发送通知;
    [NSNotificationCenter postNotification:@"kNHRequestSuccessNotification"];
    
}
- (NSDictionary *)params {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tag"] = @"joke";
    params[@"iid"] = @"5316804410";
    params[@"os_version"] = @"9.3.4";
    params[@"os_api"] = @"18";
    
    return params;
}

// 设置链接
- (void)setNh_url:(NSString *)nh_url {
    if (nh_url.length == 0 || [nh_url isKindOfClass:[NSNull class]]) {
        return ;
    }
    _nh_url = nh_url;
}























@end
