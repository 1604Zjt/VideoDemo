//
//  JTBookHomeDetailViewController.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/26.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTBookHomeDetailViewController.h"
#import "JTBookDetailViewController.h"

@interface JTBookHomeDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bookIV;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLB;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthorLB;
@property (weak, nonatomic) IBOutlet UILabel *bookDetailLB;
@property (weak, nonatomic) IBOutlet UILabel *bookContentLB;

@end

@implementation JTBookHomeDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    
    self.bookIV.image = [UIImage imageNamed:self.bookIVStr];
    self.bookNameLB.text = self.bookNameStr;
    self.bookAuthorLB.text = self.bookAuthorStr;
    self.bookDetailLB.text = self.bookDetailStr;
    self.bookContentLB.text = self.bookContentDetailStr;
    
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = kColor(98, 155, 255);
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(83);
    }];
    
    
    UIButton *begin = [UIButton buttonWithType:UIButtonTypeSystem];
    [bottomView addSubview:begin];
    [begin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    
    [begin setBackgroundColor:[UIColor clearColor]];
    [begin setTitle:@"开始学习" forState:UIControlStateNormal];
    begin.titleLabel.font = [UIFont fontWithName:kPingFangSCMedium size:18];
    [begin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [begin addTarget:self action:@selector(beginStudy:) forControlEvents:UIControlEventTouchUpInside];
    
    //字间距
    NSDictionary *dic = @{NSKernAttributeName:@0.6f};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.bookContentLB.text attributes:dic];
    //行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:18];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.bookContentLB.text length])];
    [self.bookContentLB setAttributedText:attributedString];
    [self.bookContentLB sizeToFit];
}

- (void)beginStudy:(UIButton *)sender {
    JTBookDetailViewController *vc = [[JTBookDetailViewController alloc] init];
    vc.filePath = self.filePath;
    
    [self.navigationController pushViewController:vc animated:YES];
}















@end
