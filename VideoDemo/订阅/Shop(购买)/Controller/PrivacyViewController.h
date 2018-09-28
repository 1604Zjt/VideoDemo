//
//  PrivacyViewController.h
//  hair_style
//
//  Created by WYT on 2018/1/22.
//  Copyright © 2018年 licheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    PrivacySourceTypePrivacy,
    PrivacySourceTypeUseTerms,
} PrivacySourceType;

@interface PrivacyViewController : UIViewController

@property (nonatomic,assign) PrivacySourceType sourceType;

@end
