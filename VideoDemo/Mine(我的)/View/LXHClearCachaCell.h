//
//  ClearCachaCell.h
//  NewOffice
//
//  Created by LXH on 2017/9/21.
//  Copyright © 2017年 shineyie. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LXHCustomFile [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"MP3"]

@interface LXHClearCachaCell : UITableViewCell

- (void)readCacheSize;

@end
