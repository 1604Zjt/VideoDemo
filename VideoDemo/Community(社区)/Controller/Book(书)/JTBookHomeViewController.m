//
//  JTBookHomeViewController.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/21.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTBookHomeViewController.h"
#import "DCBookModel.h"
#import "JTBookHomeDetailViewController.h"
#import "MLSearchViewController.h"
#import "BookModel.h"

@interface JTBookHomeViewController ()
@property (nonatomic,strong) NSArray<DCBookModel *> *books;
@property (nonatomic) NSMutableArray *pathArr;
@property (nonatomic) NSArray *dataModel;
@end

@implementation JTBookHomeViewController

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"naviLine"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"名书解读";
    [self loadData];
    self.view.backgroundColor = [UIColor whiteColor];
    [self pathArr];
}
- (IBAction)searchBtn:(UIButton *)sender {
    MLSearchViewController *vc = [[MLSearchViewController alloc] init];
    vc.tagsArray = @[@"交互设计入门", @"交互设计模式", @"简约至上", @"Axure交互基础"];
    
    JTBaseNaviController *navi = [[JTBaseNaviController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark  - private
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
