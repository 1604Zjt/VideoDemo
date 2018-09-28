//
//  CSLNetworkState.h
//  UI课程
//
//  Created by cuisongliang on 2018/4/30.
//  Copyright © 2018年 cuisongliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSLNetworkState : NSObject

/**
 * 判断是否连接网络
 **/
@property (nonatomic, assign) BOOL net_state;

+ (instancetype)share;
- (void)startMonitoringNetworkState;
@end
