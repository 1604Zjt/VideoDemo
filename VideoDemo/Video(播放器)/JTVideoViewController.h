//
//  JTVideoViewController.h
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/17.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTVideoModel.h"

@interface JTVideoViewController : UIViewController
@property (nonatomic) NSMutableArray<JTVideoAppPlaysModel *> *dataList;
@property (nonatomic) NSString *videoTitle;
@property (nonatomic) NSString *videoType;
//@property (nonatomic) NSString *;   

@end
