//
//  MLSearchResultsTableViewController.m
//  Medicine
//
//  Created by Visoport on 3/1/17.
//  Copyright © 2017年 Visoport. All rights reserved.
//

#import "MLSearchResultsTableViewController.h"
#import "JTNetworking.h"

@interface MLSearchResultsTableViewController ()
@property (nonatomic) NSMutableArray<JTSearchDataInfoModel *> *dataModel;
@end

@implementation MLSearchResultsTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (NSMutableArray<JTSearchDataInfoModel *> *)dataModel {
    if (_dataModel == nil) {
        _dataModel = [[NSMutableArray alloc] init];
    }
    return _dataModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(handleColorChange:) name:@"searchBarDidChange" object:nil];
}

-(void)handleColorChange:(NSNotification* )sender
{
    NSString *text = sender.userInfo[@"searchText"];
    NSString *urlStr = [NSString stringWithFormat:@"%@search?", PORTURL];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:2];
    muDic[@"search"] = text;
    muDic[@"appId"] = @"1001";
    [JTNetworking getSearch:urlStr parameters:muDic CompletionHandler:^(JTSearchModel *model, NSError *error) {
        [self.dataModel removeAllObjects];
        [self.dataModel addObjectsFromArray:model.dataInfo];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataModel.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataModel[indexPath.row].name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.didSelectText(@"");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
