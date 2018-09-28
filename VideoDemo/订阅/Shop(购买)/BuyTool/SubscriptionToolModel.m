//
//  SubscriptionToolModel.m
//  TestDemo
//
//  Created by WYT on 2018/1/16.
//  Copyright © 2018年 shineyie. All rights reserved.
//

#import "SubscriptionToolModel.h"
#import "YYModel.h"
#import "ReceiptModel.h"

@implementation SubscriptionToolModel

+(void)prepareNeedSubscriptionWithArray:(NSArray *)array{
    
    NSArray *tempArr = [NSArray yy_modelArrayWithClass:[ReceiptModel class] json:array];
    
    long long maxTime = 0;
    NSString *productID = nil;
    for (int i = 0; i < tempArr.count; i++) {
        ReceiptModel *model = tempArr[i];
        long long temMax = [model.expires_date_ms longLongValue];
        if (temMax > maxTime) {
            maxTime = temMax;
            productID = model.product_id;
        }
    }
    //换算成s
    maxTime /= 1000;
    //美国时间换算成中国时间
    maxTime += 8*3600;
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long currentTime = (long long int)time;
    
    BOOL isSubscrition = NO;
    if (currentTime > maxTime) {
        isSubscrition = NO;
    }else{
        isSubscrition = YES;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@(isSubscrition) forKey:YTSubscription];
    [[NSUserDefaults standardUserDefaults] setObject:@(maxTime) forKey:YTExpiresTime];
    [[NSUserDefaults standardUserDefaults] setObject:productID forKey:YTEffectiveProductID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

// 程序启动
+ (void)prepareStartLaunch{
    
    long long expiresTime = [[[NSUserDefaults standardUserDefaults] objectForKey:YTExpiresTime] longLongValue];
    BOOL isSubscription = NO;
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long currentTime = (long long int)time;
    
    if (currentTime > expiresTime) {
        isSubscription = NO;
    }else{
        isSubscription = YES;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@(isSubscription) forKey:YTSubscription];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end














