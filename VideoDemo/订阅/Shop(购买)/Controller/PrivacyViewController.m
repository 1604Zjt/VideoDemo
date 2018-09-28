//
//  PrivacyViewController.m
//  hair_style
//
//  Created by WYT on 2018/1/22.
//  Copyright © 2018年 licheng. All rights reserved.
//

#import "PrivacyViewController.h"
#import "YYText.h"

@interface PrivacyViewController ()

@property (nonatomic,strong) YYTextView *textView;

@property (nonatomic,strong) NSString *textString;

@end

@implementation PrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithBackImage:@"back_icon_black" highImage:nil target:self action:@selector(backActionItem:)];
    
    [self prepareInitView];
}

- (void)backActionItem:(UIBarButtonItem *)item{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareInitView{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PrivacyText" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    if (_sourceType == PrivacySourceTypePrivacy) {
        self.navigationItem.title = @"隐私政策";
        _textString = dict[@"privacyText"];
    }else{
        self.navigationItem.title = @"使用条款";
        _textString = dict[@"useTermsText"];
    }
    
    _textString = [_textString stringByReplacingOccurrencesOfString:@"XXXXX" withString:YTProjectName];
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:_textString attributes:nil]];
    text.yy_font = [UIFont systemFontOfSize:15];
    text.yy_color = [UIColor blackColor];
    text.yy_lineSpacing = 5;
    text.yy_alignment = NSTextAlignmentLeft;
    
    _textView = [[YYTextView alloc] initWithFrame:CGRectZero];
    _textView.editable = NO;
    _textView.attributedText = text;
    _textView.textContainerInset = UIEdgeInsetsMake(10, 8, 10, 8);
//    _textView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    
    
}




@end





