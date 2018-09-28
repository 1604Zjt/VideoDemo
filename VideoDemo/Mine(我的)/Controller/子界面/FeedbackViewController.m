//
//  FeedbackViewController.m
//  Language
//
//  Created by LXH on 2017/12/29.
//  Copyright © 2017年 shineyie. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UILabel *stirngLenghLabel;
@property (weak, nonatomic) IBOutlet UITextView *feedBackTextView;
@property (weak, nonatomic) IBOutlet UITextField *QQTextField;
@property (weak, nonatomic) IBOutlet UITextField *weiXinTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;




@end

@implementation FeedbackViewController

/** 提交反馈 */
- (IBAction)sendFeedback:(UIButton *)sender {
    [MBProgressHUD showSuccess:@"反馈成功!" toView:kWindow];
    [self leftBarButtonItemClick];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"意见反馈";
    
    [self prepareLayout];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithBackImage:@"back_icon_black" highImage:@"back_icon_black" target:self action:@selector(leftBarButtonItemClick)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    
    self.feedBackTextView.userInteractionEnabled = YES;
    self.QQTextField.userInteractionEnabled = YES;
    self.weiXinTextField.userInteractionEnabled = YES;
    [self.feedBackTextView addGestureRecognizer:tap];
    [self.QQTextField addGestureRecognizer:tap];
    [self.weiXinTextField addGestureRecognizer:tap];
}

- (void)tap {
    [self.view endEditing:YES];
}

- (void)leftBarButtonItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareLayout {
    
    self.feedBackTextView.delegate = self;
    self.placeHolderLabel.userInteractionEnabled = NO;
    
    self.commitButton.layer.cornerRadius = 25;
    self.commitButton.layer.masksToBounds = YES;
    self.commitButton.userInteractionEnabled = NO;
    self.commitButton.backgroundColor = [UIColor lightGrayColor];
}

//正在改变
- (void)textViewDidChange:(UITextView *)textView
{
    
    self.placeHolderLabel.hidden = YES;
    //允许提交按钮点击操作
    self.commitButton.backgroundColor = kColor(255, 0, 0);
    self.commitButton.userInteractionEnabled = YES;
    //实时显示字数
    self.stirngLenghLabel.text = [NSString stringWithFormat:@"%lu/200", (unsigned long)textView.text.length];
    
    //字数限制操作
    if (textView.text.length >= 200) {
        
        textView.text = [textView.text substringToIndex:200];
        self.stirngLenghLabel.text = @"200/200";
    }
    //取消按钮点击权限，并显示提示文字
    if (textView.text.length == 0) {
        
        self.placeHolderLabel.hidden = NO;
        self.stirngLenghLabel.hidden = NO;
        self.commitButton.userInteractionEnabled = NO;
        self.commitButton.backgroundColor = [UIColor lightGrayColor];
        
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
