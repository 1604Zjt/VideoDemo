//
//  SYMethodTools.m
//  UI课程
//
//  Created by dfssdfs on 2017/12/4.
//  Copyright © 2017年 dfssdfs. All rights reserved.
//

#import "CSLMethodTools.h"

static CSLMethodTools *methodTools = nil;

@implementation CSLMethodTools

+ (CSLMethodTools *)shared {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        if (methodTools == nil) {

            methodTools = [[self alloc] init];
        }
    });
    return methodTools;
}
/*
 * 按指定的宽度进行比例缩放
 * oldImage  原来的图片
 * targetWidth 目标宽度
 * return newImage 返回指定宽度等比缩放的图片
 */
- (UIImage *)imageCompressForWidthWithOldImage:(UIImage *)oldImage targetWidth:(CGFloat)targetWidth {

    UIImage *newImage = nil;
    CGSize imageSize = oldImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;

    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaleHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

    if (CGSizeEqualToSize(imageSize, size) == NO) {

        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

        if (widthFactor > heightFactor) {

            scaleFactor = widthFactor;
        } else {

            scaleFactor = widthFactor;
        }

        scaledWidth = width * scaleFactor;
        scaleHeight = height * scaleFactor;

        if (widthFactor > heightFactor) {

            thumbnailPoint.y = (targetHeight - scaleHeight) * 0.5;
        } else if (widthFactor < heightFactor) {

            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }

    }

    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaleHeight;
    [oldImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {

        NSLog(@"scale image fail, %s, %d", __FUNCTION__, __LINE__);
    }
    UIGraphicsEndImageContext();
    return newImage;
}
/*
 * 将图片按比例缩放
 * oldImage   原来的图片
 * size       将oldImage缩放到的尺寸
 * return newImage 返回新尺寸图片
 */
- (UIImage *)imageCompressForSizeWithOldImage:(UIImage *)oldImage newImageForSize:(CGSize)size {

    UIImage *newImage = nil;

    CGSize imageSize = oldImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

    if(CGSizeEqualToSize(imageSize, size) == NO){

        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;

        }
        else{

            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;

        if(widthFactor > heightFactor){

            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){

            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }

    UIGraphicsBeginImageContext(size);

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [oldImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){

        NSLog(@"scale image fail, %s, %d", __FUNCTION__, __LINE__);
    }

    UIGraphicsEndImageContext();

    NSLog(@"newImage === %ld, %ld", (long)newImage.size.width, (long)newImage.size.height);
    return newImage;
}

- (UIImage *)creatImageWithColor:(UIColor *)color {
    
    UIImage *image = nil;
    CGRect rect = CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
/**
 * 获取当前时间
 * @pramar format  获取的当前时间的格式
 **/
- (NSString *)getCurrentTime:(NSString *) format {
    
    NSString *timeStr = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    timeStr = [formatter stringFromDate:[NSDate date]];
    return timeStr;
}
/**
 *
 * 获取当前时间  年 月 日 时 分 秒
 * 时间戳
 **/
- (NSString *)getCurrentAccurateTime {
    
    NSString *timeStr = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    // 设置时区，这个对于时间的处理有时很重要
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *dateNow = [NSDate date];// 现在时间
    timeStr = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    return timeStr;
}
/**
 * 将时间转换成时间戳   出生日期  YYYY-MM-dd（年-月-日）
 * @param   time  需要转换的时间
 * @param   formatter   时间的格式
 **/
- (NSInteger)convertTimeToTimestampsWithTime:(NSString *)time timeFormatter:(NSString *) formatter {
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
    [format setDateFormat:formatter];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [format setTimeZone:timeZone];
    
    // 将字符串按formatter格式转化成NSDate
    NSDate *date = [format dateFromString:time];
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return timeSp;
}
/**
 * 将时间戳转换成时间
 * 注：此时间戳为iOS生成的
 **/
- (NSString *)convertTimestampsGeneratedByIOSToAccurateTime:(NSString *)timestamps {
    
    NSTimeInterval interval = [timestamps doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
/**
 * 将时间戳转换成时间 年 月 日
 * @param timestamps 传人的时间戳
 * @param timeFormat 生成的时间的格式
 * 注：此时间戳为iOS生成的
 **/
- (NSString *)convertTimestampsGeneratedByIOSToTime:(NSString *)timestamps formatter:(NSString *)timeFormat {
    
    NSTimeInterval interval = [timestamps doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:timeFormat];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
/**
 * 将时间戳转换成时间
 * 注：此时间戳为服务器返回的
 **/
- (NSString *)convertTimestampsReturnedByTheServerToAccurateTime:(NSString *)timestamps {
    
    NSTimeInterval interval = [timestamps doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
/**
 * 将时间戳（服务器获取）转换成时间 并计算发出的时间
 * 如果超过12小时  则返回时间格式为 年-月-日 时：分：秒
 * 否则，返回时间格式：
 *                如果，大于一小时，则为 -时-分钟前
 *                否则，返回   -分钟前
 **/
- (NSString *)convertTimestampsAccordingToTheLengthOfThePresentTime:(NSString *)timestamps {
    
    //NSString *nowTime = [self getCurrentTime:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval interval = [timestamps doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    // 获取时间差 单位为秒
    NSTimeInterval secondDifference = [nowDate timeIntervalSinceDate:date];
    NSLog(@"secondDifference == %f, %@", secondDifference, [formatter stringFromDate:date]);
    if (secondDifference < 60) {
        // 几秒前发送
        return [NSString stringWithFormat:@"%.lf秒前", roundf(secondDifference)];
    } else if (secondDifference >= 60 && secondDifference < 60 * 60) {
        return [NSString stringWithFormat:@"%.lf分钟前", roundf(secondDifference/60)];
    } else if (secondDifference >= 60 * 60 && secondDifference < 60 * 60 * 24) {
        return [NSString stringWithFormat:@"%.lf小时前", roundf(secondDifference / 3600)];
    } else if (secondDifference >= 60 * 60 * 24 && secondDifference < 60 * 60 * 24 * 28) {
        return [NSString stringWithFormat:@"%.lf天前", roundf(secondDifference / (60 * 60 * 24))];
    }
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}
#pragma mark - 判断object是否为null -
-(BOOL)isNull:(id)object

{
    
    // 判断是否为空串
    NSLog(@"object -=-=-= %@", object);
    if ([object isEqual:[NSNull null]]) {
        
        return NO;
        
    }
    
    else if ([object isKindOfClass:[NSNull class]])
        
    {
        
        return NO;
        
    }
    
    else if (object==nil){
        
        return NO;
        
    } else if (((NSString *)object).length == 0) {
        return NO;
    }
    
    return YES;
    
}

+(void)saveUserInfo:(NSArray *)userDic{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *documnetPath = [documents stringByAppendingPathComponent:@"diary.xml"];
    NSArray *dic = userDic;
    [dic writeToFile:documnetPath atomically:YES];
    
}

+(NSArray *)getUserInfo{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [array lastObject];
    NSString *documnetPath = [documents stringByAppendingPathComponent:@"diary.xml"];
    NSArray *userDic = [NSArray arrayWithContentsOfFile:documnetPath];
    return  userDic;
}
@end

