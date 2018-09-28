//
//  JTHomeViewController.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/26.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTHomeViewController.h"
#import "JTVideoViewController.h"
#import "MLSearchViewController.h"
#import "JTPageViewController.h"
#import "JTBookHomeDetailViewController.h"
#import "DCBookModel.h"
#import "BookModel.h"

@interface JTHomeViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic,strong) NSArray<DCBookModel *> *books;
@property (nonatomic) NSMutableArray *pathArr;
@property (nonatomic) NSArray *dataModel;

@end

@implementation JTHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IPHONE_X) {
        self.heightLayout.constant = 88;
        self.topLayout.constant = 40;
    }else {
        self.heightLayout.constant = 64;
        self.topLayout.constant = 20;
    }
    //UIScrollView
    self.scrollView.delegate = self;
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    //书本数据
    [self loadData];
    [self pathArr];
}

//导航栏渐变
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.topView.alpha = scrollView.contentOffset.y / (kScreenW * 217 / 375 - self.heightLayout.constant);
}
//搜索
- (IBAction)searchBtn:(UIButton *)sender {
    MLSearchViewController *vc = [[MLSearchViewController alloc] init];
    vc.tagsArray = @[@"交互设计入门", @"交互设计模式", @"简约至上", @"Axure交互基础"];
    
    JTBaseNaviController *navi = [[JTBaseNaviController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}
//视频播单
- (IBAction)videoList:(UIButton *)sender {
    JTPageViewController *vc = [[JTPageViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
//书本
- (NSMutableArray *)pathArr {
    if (_pathArr == nil) {
        _pathArr = [[NSMutableArray alloc] init];
        NSBundle *boundle = [NSBundle mainBundle];
        NSString *path = [boundle pathForResource:@"Book" ofType:@"plist"];
        _pathArr = [NSMutableArray arrayWithContentsOfFile:path];
        _dataModel = [BookModel parse:_pathArr];
    }
    return _pathArr;
}

-(void)loadData {
    //获取文件夹中的所有文件
    NSArray *fileArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:DCBooksPath error:nil];
    
    NSMutableArray *bookArr = [[NSMutableArray alloc]init];
    for (NSString *file in fileArr) {
        DCBookModel *book = [[DCBookModel alloc]init];
        book.path = [DCBooksPath stringByAppendingPathComponent:file];
        NSArray *arr = [file componentsSeparatedByString:@"."];
        book.name = arr.firstObject;
        book.type = arr.lastObject;
        [bookArr addObject:book];
    }
    self.books = [NSArray arrayWithArray:bookArr];
}

- (IBAction)bookDetailVC:(UIButton *)sender {
    DCBookModel *book = self.books[sender.tag];
    BookModel *model = self.dataModel[sender.tag];
    
    JTBookHomeDetailViewController *vc = [[JTBookHomeDetailViewController alloc] init];
    //书本路径
    vc.filePath = book.path;
    //图片
    vc.bookIVStr = [NSString stringWithFormat:@"book_%ld", sender.tag + 1];
    vc.bookNameStr = model.bookName;
    vc.bookAuthorStr = model.bookAuthor;
    vc.bookDetailStr = model.bookDetail;
    vc.bookContentDetailStr = model.bookContent;
    
    [self.navigationController pushViewController:vc animated:YES];
}














@end
