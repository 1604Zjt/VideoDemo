//
//  ReceiptModel.h
//  TestDemo
//
//  Created by WYT on 2018/1/16.
//  Copyright © 2018年 shineyie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiptModel : NSObject

@property (nonatomic,strong) NSString *product_id;

@property (nonatomic,strong) NSString *purchase_date_ms;

@property (nonatomic,strong) NSString *expires_date_ms;

@end
