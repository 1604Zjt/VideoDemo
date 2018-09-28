//
//  JTFaBuViewController.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/25.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTFaBuViewController.h"
#import "JTNetworking.h"

//默认最大输入字数为 200
#define kMaxTextCount 120

@interface JTFaBuViewController ()<UITextViewDelegate, UIScrollViewDelegate>
{
    float noteTextHeight;
    float pickerViewHeight;
    float allViewHeight;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end

@implementation JTFaBuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IPHONE_X) {
        self.heightLayout.constant = 88;
        self.topLayout.constant = 88;
    }else {
        self.heightLayout.constant = 64;
        self.topLayout.constant = 64;
    }
    //收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    _mainScrollView.delegate = self;
    self.showInView = _mainScrollView;
    
    [self initPickerView];
    [self initViews];
}

- (void)viewTap {
    [self.view endEditing:YES];
}

//取消
- (IBAction)backBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//发布
- (IBAction)fabuBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    //检查输入
    if (![self chectInput]) {
        return;
    }
    
    //小图数据
    NSArray *smallImageArray = self.imageArray;
    //小图二进制数据
    NSMutableArray *smallImageDataArray = [NSMutableArray array];
    
    for (UIImage *smallImg in smallImageArray) {
        NSData *smallImgData = UIImagePNGRepresentation(smallImg);
        [smallImageDataArray addObject:smallImgData];
    }
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:2];
    muDic[@"flowImage"] = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPic];
    muDic[@"flowName"] = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    muDic[@"userId"] = [[NSUserDefaults standardUserDefaults] objectForKey:kUserID];
    muDic[@"flowTitle"] = [NSString stringWithFormat:@"%@%@", self.noteTextView.text, smallImageDataArray];
    muDic[@"appId"] = commentID;
    
    NSString *url = [NSString stringWithFormat:@"%@appCommentWeb/insert", PORTURL];
    [[JTNetworking shareManager] POST:url paramters:muDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD showSuccess:@"发送成功!" toView:kWindow];
        [self backBtnClick:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showSuccess:@"发送失败，服务器出错了!" toView:kWindow];
    }];
    
}

- (BOOL)chectInput {
    if (_noteTextView.text.length == 0) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"说一下这一刻的想法吧..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:alert1];
        [self presentViewController:alertC animated:YES completion:nil];
        
        return NO;
    }
    //文本框字数超过120
    if (_noteTextView.text.length >= kMaxTextCount) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"文字超出字数限制了!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
        
        [self.view endEditing:YES];
        
        return NO;
    }
    return YES;
}

- (void)initViews {
    _noteTextBackgroundView = [[UIView alloc] init];
    _noteTextBackgroundView.backgroundColor = [UIColor whiteColor];
    //文本输入框
    _noteTextView = [[UITextView alloc] init];
    _noteTextView.keyboardType = UIKeyboardTypeDefault;
    //文字样式
    [_noteTextView setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
    [_noteTextView setTextColor:[UIColor blackColor]];
    _noteTextView.delegate = self;
    
    _textNumberLabel = [[UILabel alloc] init];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:11];
    _textNumberLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.4];
    _textNumberLabel.text = [NSString stringWithFormat:@"剩余%d个字", kMaxTextCount];
    
    _textLB = [[UILabel alloc] init];
    _textLB.textAlignment = NSTextAlignmentLeft;
    _textLB.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    _textLB.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.3];
    _textLB.text = @"这一刻的想法…";
    
    
    [_mainScrollView addSubview:_noteTextBackgroundView];
    [_mainScrollView addSubview:_noteTextView];
    [_mainScrollView addSubview:_textNumberLabel];
    [_mainScrollView addSubview:_textLB];
    
    [self updateViewsFrame];
}

- (void)updateViewsFrame {
    if (!allViewHeight) {
        allViewHeight = 0;
    }
    if (!noteTextHeight) {
        noteTextHeight = 100;
    }
    _noteTextBackgroundView.frame = CGRectMake(0, 0, kScreenWidth, noteTextHeight);
    //文本输入框
    _noteTextView.frame = CGRectMake(20, 0, kScreenWidth - 40, noteTextHeight);
    //textViewLB
    _textLB.frame = CGRectMake(24, 8, 140, 16);
    //文字提示label
    _textNumberLabel.frame = CGRectMake(0, [self getPickerViewFrame].origin.y + [self getPickerViewFrame].size.height + 150, kScreenWidth - 20, 11);
    //photoPicker
    [self updatePickerViewFrameY:_noteTextView.frame.origin.y + _noteTextView.frame.size.height];
    
    allViewHeight = noteTextHeight + [self getPickerViewFrame].size.height + 30 + 100;
    _mainScrollView.contentSize = CGSizeMake(0, allViewHeight);
}

/**
 恢复原始界面布局
 */
- (void)resumeOriginalFrame {
    _noteTextBackgroundView.frame = CGRectMake(0, 0, kScreenWidth, noteTextHeight);
    //文本输入框
    _noteTextView.frame = CGRectMake(20, 0, kScreenWidth - 40, noteTextHeight);
    //textViewLB
    _textLB.frame = CGRectMake(24, 8, 140, 16);
    //文字个数提示label
    _textNumberLabel.frame = CGRectMake(0, [self getPickerViewFrame].origin.y + [self getPickerViewFrame].size.height + 150, kScreenWidth - 20, 11);
}

- (void)pickerViewFrameChanged {
    [self updateViewsFrame];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (_noteTextView.text.length > 0) {
        self.textLB.hidden = YES;
    }else {
        self.textLB.hidden = NO;
    }
    //当前输入字数
    NSInteger count = kMaxTextCount - _noteTextView.text.length;
    _textNumberLabel.text = [NSString stringWithFormat:@"剩余%ld个字", count];
    if (_noteTextView.text.length >= kMaxTextCount) {
        _textNumberLabel.textColor = [UIColor redColor];
        _textNumberLabel.text = [NSString stringWithFormat:@"文字超出字数限制"];
    }else {
        _textNumberLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.4];
    }
    [self textChanged];
    return YES;
}

//文本框每次输入都会调用 --> 更改文字个数提示框
- (void)textViewDidChange:(UITextView *)textView {
    if (_noteTextView.text.length > 0) {
        self.textLB.hidden = YES;
    }else {
        self.textLB.hidden = NO;
    }
    //当前输入字数
    NSInteger count = kMaxTextCount - _noteTextView.text.length;
    _textNumberLabel.text = [NSString stringWithFormat:@"剩余%ld个字", count];
    if (_noteTextView.text.length >= kMaxTextCount) {
        _textNumberLabel.textColor = [UIColor redColor];
        _textNumberLabel.text = [NSString stringWithFormat:@"文字超出字数限制"];
    }else {
        _textNumberLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.4];
    }
    [self textChanged];
}
/**
 文本高度自适应
 */
- (void)textChanged {
    //获取原始UITextView的frame
    CGRect orgRect = self.noteTextView.frame;
    
    //获取尺寸
    CGSize size = [self.noteTextView sizeThatFits:CGSizeMake(self.noteTextView.frame.size.width, MAXFLOAT)];
    
    //获取自适应文本内容高度
    orgRect.size.height = size.height + 10;
    
    //如果文本框没字了恢复初始尺寸
    if (orgRect.size.height > 100) {
        noteTextHeight = orgRect.size.height;
    }else {
        noteTextHeight = 100;
    }
    [self updateViewsFrame];
}

- (void)didReceiveMemoryWarning {
    [MBProgressHUD showError:@"内存警告..." toView:kWindow];
}

//用户向上便宜收键盘，增强用户体验
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        [self.view endEditing:YES];
    }
}






@end
