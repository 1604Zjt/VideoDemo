//
//  SYMethodTools.h
//  UI课程
//
//  Created by dfssdfs on 2017/12/4.
//  Copyright © 2017年 dfssdfs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CSLMethodTools : NSObject

+ (CSLMethodTools *)shared;

/*
 * 将图片按比例缩放
 * oldImage   原来的图片
 * size       将oldImage缩放到的尺寸
 * return newImage 返回新尺寸图片
 */
- (UIImage *)imageCompressForSizeWithOldImage:(UIImage *)oldImage newImageForSize:(CGSize)size;
/*
 * 按指定的宽度进行比例缩放
 * oldImage  原来的图片
 * targetWidth 目标宽度
 * return newImage 返回指定宽度等比缩放的图片
 */
- (UIImage *)imageCompressForWidthWithOldImage:(UIImage *)oldImage targetWidth:(CGFloat )targetWidth;
/**
 * 根据颜色生成一张纯色图片
 **/
- (UIImage *)creatImageWithColor:(UIColor *)color;
/**
 *
 * 获取当前时间  年 月 日
 **/
- (NSString *)getCurrentTime:(NSString *) format;
/**
 *
 * 获取当前时间  年 月 日 时 分 秒
 * 时间戳
 **/
- (NSString *)getCurrentAccurateTime;
/**
 * 将时间转换成时间戳   出生日期  YYYY-MM-dd（年-月-日）
 * @param   time  需要转换的时间
 * @param   formatter   时间的格式
 **/
- (NSInteger)convertTimeToTimestampsWithTime:(NSString *)time timeFormatter:(NSString *) formatter;
/**
 * 将时间戳转换成时间 年 月 日 时 分
 * 注：此时间戳为iOS生成的
 **/
- (NSString *)convertTimestampsGeneratedByIOSToAccurateTime:(NSString *)timestamps;
/**
 * 将时间戳转换成时间 年 月 日
 * @param timestamps 传人的时间戳
 * @param timeFormat 生成的时间的格式
 * 注：此时间戳为iOS生成的
 **/
- (NSString *)convertTimestampsGeneratedByIOSToTime:(NSString *)timestamps formatter:(NSString *)timeFormat;
/**
 * 将时间戳转换成时间
 * 注：此时间戳为服务器返回的
 **/
- (NSString *)convertTimestampsReturnedByTheServerToAccurateTime:(NSString *)timestamps;
/**
 * 将时间戳（服务器获取）转换成时间 并计算发出的时间
 * 如果超过12小时  则返回时间格式为 年-月-日 时：分：秒
 * 否则，返回时间格式：
 *                如果，大于一小时，则为 -时-分钟前
 *                否则，返回   -分钟前
 **/
- (NSString *)convertTimestampsAccordingToTheLengthOfThePresentTime:(NSString *)timestamps;
/**
 * 判断字符串是否为空
 **/
- (BOOL )isNull:(id)object;

+(void)saveUserInfo:(NSArray *)userDic;
+(NSArray *)getUserInfo;
@end


