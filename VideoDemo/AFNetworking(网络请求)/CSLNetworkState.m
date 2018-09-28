//
//  CSLNetworkState.m
//  UI课程
//
//  Created by cuisongliang on 2018/4/30.
//  Copyright © 2018年 cuisongliang. All rights reserved.
//

#import "CSLNetworkState.h"

static CSLNetworkState *network_state = nil;
@implementation CSLNetworkState

+ (instancetype)share {
    
    if (!network_state) {
        network_state = [[CSLNetworkState alloc] init];
    }
    return network_state;
}
- (void)startMonitoringNetworkState {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                self.net_state = NO;
                //[SVProgressHUD showInfoWithStatus:@"未知网络，不可用"];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                self.net_state = NO;
                //[SVProgressHUD showInfoWithStatus:@"当前网络不可用，请检查"];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.net_state = YES;
                //[SVProgressHUD showInfoWithStatus:@"当前网络为WiFi"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.net_state = YES;
                //[SVProgressHUD showInfoWithStatus:@"当前网络为蜂窝移动网络"];
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
}
@end
