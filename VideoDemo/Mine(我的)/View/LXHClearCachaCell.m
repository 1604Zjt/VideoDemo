//
//  ClearCachaCell.m
//  NewOffice
//
//  Created by LXH on 2017/9/21.
//  Copyright © 2017年 shineyie. All rights reserved.
//

#import "LXHClearCachaCell.h"

@implementation LXHClearCachaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self readCacheSize];
    }
    
    return self;
}

//获取缓存大小
- (void)readCacheSize {
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    self.accessoryView = loadingView;
    
    self.textLabel.text = @"清除缓存";
    
//    self.textLabel.font = [UIFont systemFontOfSize:17];
    
    self.detailTextLabel.text = @"正在计算";
    
    self.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
    self.userInteractionEnabled = NO;
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [NSThread sleepForTimeInterval:1.0];
        
        //            NSString *customFileCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"MP3"];
        
        unsigned long long size = LXHCustomFile.fileSize;
        NSLog(@"customFile -size:%zd",size);
        
        size += [SDImageCache sharedImageCache].getSize;   //SDImage 缓存
        NSLog(@"%zd",[SDImageCache sharedImageCache].getSize);
        
        NSLog(@"allFile -size:%zd",size);
        
        if (weakSelf == nil) return;
        
        NSString *sizeText = nil;
        if (size >= pow(10, 9)) {
            sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
        }else if (size >= pow(10, 6)) {
            sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
        }else if (size >= pow(10, 3)) {
            sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
        }else {
            sizeText = [NSString stringWithFormat:@"%zdB", size];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.detailTextLabel.text = [NSString stringWithFormat:@"%@",sizeText];
            weakSelf.accessoryView = nil;
            weakSelf.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
//            [weakSelf addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(clearCacheClick)]];
            
            weakSelf.userInteractionEnabled = YES;
            
        });
        
    });
}

//清除缓存
//- (void)clearCacheClick {
//
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [MBProgressHUD showLoadToView:window title:@"正在清除缓存···"];
//
//    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//            [NSThread sleepForTimeInterval:1.0];
//
//            NSFileManager *mgr = [NSFileManager defaultManager];
//            [mgr removeItemAtPath:LXHCustomFile error:nil];
//            [mgr createDirectoryAtPath:LXHCustomFile withIntermediateDirectories:YES attributes:nil error:nil];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                [MBProgressHUD hideHUD];
//
//                // 设置文字
//                self.detailTextLabel.text = nil;
//
//            });
//
//        });
//    }];
//
//}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self readCacheSize];
}


/**
 *  当cell重新显示到屏幕上时, 也会调用一次layoutSubviews
 */
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    // cell重新显示的时候, 继续转圈圈
//    UIActivityIndicatorView *loadingView = (UIActivityIndicatorView *)self.accessoryView;
//    [loadingView startAnimating];
//}



@end
