//
//  JTExpDetailViewController.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/28.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTExpDetailViewController.h"
#import "JTFindCommunityViewController.h"
#import "JTExpDetailOneCell.h"
#import "JTExpDetailTwoCell.h"

@interface JTExpDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableView;

@property (nonatomic) UIView *bottomView;
@property (nonatomic) UIView *lineView;
@property (nonatomic) UIButton *bottomTF;

@property (nonatomic) UIButton *zanBtn;
@property (nonatomic) UIButton *zanLB;
@property (nonatomic) UIButton *pinlunBtn;
@property (nonatomic) UIButton *pinlunLB;

@property (nonatomic) NSInteger zanCount;

@end

@implementation JTExpDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
        
        CGFloat height = 0;
        if (IS_IPHONE_X) {
            height = -80;
        }else {
            height = -60;
        }
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(0);
            make.bottom.equalTo(height);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        CGFloat height = 0;
        if (IS_IPHONE_X) {
            height = 80;
        }else {
            height = 60;
        }
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - height - height, kScreenW, height)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.5)];
        _lineView.backgroundColor = [UIColor blackColor];
        _lineView.alpha = 0.1;
        [_bottomView addSubview:_lineView];
    }
    return _lineView;
}

- (UIButton *)bottomTF {
    if (_bottomTF == nil) {
        _bottomTF = [[UIButton alloc] initWithFrame:CGRectMake(20, 14, kScreenW - 159, 35)];
        _bottomTF.layer.cornerRadius = 17.5;
        _bottomTF.layer.masksToBounds = YES;
        [_bottomTF setTitleColor:kColor(183, 183, 183) forState:UIControlStateNormal];
        _bottomTF.titleLabel.font = [UIFont systemFontOfSize:14];
        [_bottomTF setTitle:@"  说点什么吧～" forState:UIControlStateNormal];
        _bottomTF.backgroundColor = kColor(242, 242, 242);
        [self.bottomView addSubview:_bottomTF];
        
        [_bottomTF addTarget:self action:@selector(gotoPinLun:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomTF;
}

- (UIButton *)zanBtn {
    if (_zanBtn == nil) {
        _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bottomView addSubview:_zanBtn];
        _zanBtn.frame = CGRectMake(self.bottomTF.right + 18, 21, 18, 19.3);
        [_zanBtn setImage:[UIImage imageNamed:@"dianzan_weixuanzhong"] forState:UIControlStateNormal];
        [_zanBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _zanBtn;
}

- (UIButton *)zanLB {
    if (_zanLB == nil) {
        _zanLB = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.bottomView addSubview:_zanLB];
        _zanLB.titleLabel.font = [UIFont fontWithName:kPingFangSCMedium size:12];
        [_zanLB setTitleColor:kColor(183, 183, 183) forState:UIControlStateNormal];
        _zanLB.frame = CGRectMake(self.zanBtn.right + 6, 24, 17, 13);
        NSString *zanStr = [NSString stringWithFormat:@"%ld", _zanCount];
        [_zanLB setTitle:zanStr forState:UIControlStateNormal];
        [_zanLB addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zanLB;
}

- (UIButton *)pinlunBtn {
    if (_pinlunBtn == nil) {
        _pinlunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bottomView addSubview:_pinlunBtn];
        _pinlunBtn.frame = CGRectMake(self.zanLB.right + 18, 21, 21, 19.9);
        [_pinlunBtn setImage:[UIImage imageNamed:@"pinglun"] forState:UIControlStateNormal];
        [_pinlunBtn addTarget:self action:@selector(gotoPinLun:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pinlunBtn;
}

- (UIButton *)pinlunLB {
    if (_pinlunLB == nil) {
        _pinlunLB = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.bottomView addSubview:_pinlunLB];
        _pinlunLB.titleLabel.font = [UIFont fontWithName:kPingFangSCMedium size:12];
        [_pinlunLB setTitleColor:kColor(183, 183, 183) forState:UIControlStateNormal];
        _pinlunLB.frame = CGRectMake(self.pinlunBtn.right + 6, 24, 17, 13);
        NSString *pinlunStr = [NSString stringWithFormat:@"%d", arc4random() % 100];
        [_pinlunLB setTitle:pinlunStr forState:UIControlStateNormal];
        [_pinlunLB addTarget:self action:@selector(gotoPinLun:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _pinlunLB;
}

- (void)zanBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_zanBtn setImage:[UIImage imageNamed:@"dianzan_xuanzhong"] forState:UIControlStateNormal];
        NSInteger count = _zanCount + 1;
        [_zanLB setTitle:[NSString stringWithFormat:@"%ld", count] forState:UIControlStateNormal];
    }else {
        [_zanBtn setImage:[UIImage imageNamed:@"dianzan_weixuanzhong"] forState:UIControlStateNormal];
        NSInteger count = _zanCount;
        [_zanLB setTitle:[NSString stringWithFormat:@"%ld", count] forState:UIControlStateNormal];
    }
}

- (void)gotoPinLun:(UIButton *)sender {
    JTFindCommunityViewController *vc = [[JTFindCommunityViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _zanCount = arc4random() % 100;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"详情";
    [self.tableView registerNib:[UINib nibWithNibName:@"JTExpDetailOneCell" bundle:nil] forCellReuseIdentifier:@"oneCell"];
    [self.tableView registerClass:[JTExpDetailTwoCell class] forCellReuseIdentifier:@"twoCell"];
    [self bottomView];
    [self bottomTF];
    [self lineView];
    [self zanBtn];
    [self zanLB];
    [self pinlunBtn];
    [self pinlunLB];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        NSArray *countArr = [self.contentStr componentsSeparatedByString:@"*"];

        return countArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JTExpDetailOneCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"oneCell" forIndexPath:indexPath];
        oneCell.headerIV.image = [UIImage imageNamed:self.headerImg];
        oneCell.titleLB.text = self.titleStr;
        
        return oneCell;
    }else {
        JTExpDetailTwoCell *twoCell = [tableView dequeueReusableCellWithIdentifier:@"twoCell" forIndexPath:indexPath];
        NSArray *titleArr = [self.contentStr componentsSeparatedByString:@"*"];
        twoCell.contentLB.text = titleArr[indexPath.row];
        //字间距
        NSDictionary *dic = @{NSKernAttributeName:@0.7f};
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:twoCell.contentLB.text attributes:dic];
        //行间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:18];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [twoCell.contentLB.text length])];
        [twoCell.contentLB setAttributedText:attributedString];
        [twoCell.contentLB sizeToFit];
        
        NSArray *imgArr = [self.contentImg componentsSeparatedByString:@"*"];
        twoCell.contentIV.image = [UIImage imageNamed:imgArr[indexPath.row]];
        
        return twoCell;
    }
}

//自适应高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}








@end
