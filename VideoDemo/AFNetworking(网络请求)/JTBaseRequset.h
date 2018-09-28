//
//  JTBaseRequset.h
//  Sing
//
//  Created by 张俊涛 on 2018/8/5.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol JTBaseRequestReponseDelegate <NSObject>
@required

-(void)requestSuccessReponse:(BOOL) success response:(id)reponse message :(NSString *)message;

@end


typedef void(^LCAPIDicCompletion)(id response, BOOL success,NSString *message);
@interface JTBaseRequset : NSObject


@property (nonatomic ,weak)id <JTBaseRequestReponseDelegate> nh_delegate;

@property (nonatomic,copy)NSString *nh_url;

@property (nonatomic,assign)BOOL nh_isPost;

@property (nonatomic ,strong)NSArray <UIImage *>*nh_imageArray;


/**构造方法**/
+(instancetype)nh_request;
+(instancetype)nh_requestWithUrl:(NSString *)nh_url;
+ (instancetype)nh_requestWithUrl:(NSString *)nh_url isPost:(BOOL)nh_isPost;
+ (instancetype)nh_requestWithUrl:(NSString *)nh_url isPost:(BOOL)nh_isPost delegate:(id <JTBaseRequestReponseDelegate>)sc_delegate;


- (void)nh_sendRequest;

- (void)nh_sendRequestWithCompletion:(LCAPIDicCompletion)completion;
@end


