//
//  JTWelComeViewController.m
//  Piano
//
//  Created by 张俊涛 on 2018/8/15.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTWelComeViewController.h"
#import "JTOneWelComeCell.h"
#import "JTTwoWelComeCell.h"
#import "JTThreeWelComeCell.h"
#import "JTTabBarController.h"
#import "YQInAppPurchaseTool.h"
#import "JTNetworking.h"

@interface JTWelComeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, JTOneWelComeCellDelegate, JTTwoWelComeCellDelegate, JTThreeWelComeCellDelegate, YQInAppPurchaseToolDelegate>
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic,strong) SKProduct *product;
@property (nonatomic,strong) NSArray *proArr;
@property (nonatomic) NSMutableArray<JTBuyModel *> *dataList;
@property (nonatomic) JTThreeWelComeCell *threeCell;
@property (nonatomic) NSString *mianfei;
@property (nonatomic) NSString *contentIV;
@property (nonatomic) UIPageControl *pageC;

@end

@implementation JTWelComeViewController

- (UIPageControl *)pageC {
    if (_pageC == nil) {
        _pageC = [[UIPageControl alloc] init];
        _pageC.numberOfPages = 3;
        _pageC.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageC.pageIndicatorTintColor = kColor(154, 154, 154);
        _pageC.currentPage = 0;
        [self.view addSubview:_pageC];
        
        [_pageC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(64);
        }];
    }
    return _pageC;
}

- (NSMutableArray<JTBuyModel *> *)dataList {
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]  initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.view addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollEnabled = NO;
        [self pageC];
    }
    return _collectionView;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self networking];
    
    //注册Cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"JTOneWelComeCell" bundle:nil] forCellWithReuseIdentifier:@"oneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"JTTwoWelComeCell" bundle:nil] forCellWithReuseIdentifier:@"twoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"JTThreeWelComeCell" bundle:nil] forCellWithReuseIdentifier:@"threeCell"];
}

- (void)networking {
    [JTNetworking getBuy:[NSString stringWithFormat:@"%@appAudit/get/appId/%@/location/1", PORTURL, switchID] parameters:nil CompletionHandler:^(JTBuyModel *model, NSError *error) {
        if (error) {
        }else {
            [self createInAppPurchaseTool];
            [self.dataList addObject:model];
            [self mianfeiShiYong];
            [self.collectionView reloadData];
        }
    }];
}

- (void)mianfeiShiYong {
    self.mianfei = self.dataList[0].auditShowName;
    if ([self.dataList[0].auditPass isEqualToString:@"1"]) {
        self.contentIV = @"pic";
    }else {
        self.contentIV = @"pic1";
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        JTOneWelComeCell *oneCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"oneCell" forIndexPath:indexPath];
        oneCell.delegate = self;
        
        return oneCell;
    }else if (indexPath.row == 1) {
        JTTwoWelComeCell *twoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"twoCell" forIndexPath:indexPath];
        twoCell.delegate = self;
        
        return twoCell;
    }else {
        _threeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"threeCell" forIndexPath:indexPath];
        _threeCell.delegate = self;
        _threeCell.contentIV.image = [UIImage imageNamed:self.contentIV];
        [_threeCell.beginBtn setTitle:self.mianfei forState:UIControlStateNormal];
        
        return _threeCell;
    }
}

- (void)oneWelComeBtnClick:(NSInteger)index {
    [self networking];
    self.pageC.currentPage = 1;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)twoWelComeBtnClick:(NSInteger)index {
    [self networking];
    self.pageC.currentPage = 2;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index + 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)gotoOneWelComeBtnClick:(NSInteger)index {
    self.pageC.currentPage = 1;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)threeWelComeBtnClick:(NSInteger)index {
    if ([self.dataList[0].auditPass isEqualToString:@"1"] ) {
        if (_proArr.count > 0) {
            [self BuyProduct:_product];
        }else{
            [SVProgressHUD showWithStatus:@"正在加载..."];
            [self createInAppPurchaseTool];
        }
    }else {
        [self jumpToMainViewController];
    }
}

- (void)jumpToMainViewController {
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *key = @"CFBundleShortVersionString";
    NSString *currentVersion = infoDic[key];
    [[NSUserDefaults standardUserDefaults] setValue:currentVersion forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CATransition *anima = [CATransition animation];
    anima.type     = kCATransitionFade;
    anima.duration = 1.0;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.layer addAnimation:anima forKey:@"ani"];
    
    
    window.rootViewController = [[JTTabBarController alloc] init];
}




#pragma mark -------------IAP--------------

- (void)createInAppPurchaseTool {
    //获取单例
    YQInAppPurchaseTool *IAPTool = [YQInAppPurchaseTool defaultTool];
    
    //设置代理
    IAPTool.delegate = self;
    
    //向苹果询问哪些商品能够购买
    
    [IAPTool requestProductsWithProductArray:@[ProductID_IAPp25]];
    
    
}

#pragma mark --------YQInAppPurchaseToolDelegate
//IAP工具已获得可购买的商品
- (void)IAPToolGotProducts:(NSMutableArray *)products {
    NSLog(@"GotProducts:%@",products);
    
    if (products.count > 0) {
        
        _proArr = products;
        
        _product = products.firstObject;
    }
    
    [SVProgressHUD dismiss];
}

//支付失败/取消
- (void)IAPToolCanceldWithProductID:(NSString *)productID {
    NSLog(@"canceld:%@", productID);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismiss];
        
        [self jumpToMainViewController];
    });
    
    
}
//支付成功了，并开始向苹果服务器进行验证（若CheckAfterPay为NO，则不会经过此步骤）
- (void)IAPToolBeginCheckingdWithProductID:(NSString *)productID {
    NSLog(@"BeginChecking:%@",productID);
    
    [SVProgressHUD showWithStatus:@"正在处理..."];
}
//商品被重复验证了
- (void)IAPToolCheckRedundantWithProductID:(NSString *)productID {
    NSLog(@"CheckRedundant:%@",productID);
    
    [SVProgressHUD showInfoWithStatus:@"重复验证了"];
}

//商品完全购买成功且验证成功了。（若CheckAfterPay为NO，则会在购买成功后直接触发此方法）
- (void)IAPToolBoughtProductSuccessedWithProductID:(NSString *)productID
                                           andInfo:(NSDictionary *)infoDic {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismiss];
        
        [self jumpToMainViewController];
    });
    
}

//商品购买成功了，但向苹果服务器验证失败了
//2种可能：
//1，设备越狱了，使用了插件，在虚假购买。
//2，验证的时候网络突然中断了。（一般极少出现，因为购买的时候是需要网络的）
- (void)IAPToolCheckFailedWithProductID:(NSString *)productID
                                andInfo:(NSData *)infoData {
    NSLog(@"CheckFailed:%@",productID);
    
    [SVProgressHUD showErrorWithStatus:@"验证失败了"];
}


//恢复了已购买的商品（仅限永久有效商品）
- (void)IAPToolRestoredProductID:(NSString *)productID {
    
    [SVProgressHUD showSuccessWithStatus:@"成功恢复了订阅"];
    
}


//内购系统错误了
- (void)IAPToolSysWrong {
    NSLog(@"SysWrong");
    [SVProgressHUD showErrorWithStatus:@"内购系统出错"];
}

//恢复已购买的商品
- (void)restoreProduct {
    
    [SVProgressHUD showWithStatus:@"正在处理..."];
    //直接调用
    [[YQInAppPurchaseTool defaultTool] restorePurchase];
    
}


//购买商品
- (void)BuyProduct:(SKProduct *)product {
    
    [SVProgressHUD showWithStatus:@"正在处理..."];
    
    [[YQInAppPurchaseTool defaultTool] buyProduct:product.productIdentifier];
}

- (void)prepareForPurchaseAnimationTime:(CGFloat)time animView:(UIView *)view{
    CATransition *anima = [CATransition animation];
    anima.type = kCATransitionPush;
    anima.subtype = kCATransitionFromRight;
    anima.duration = time;
    [view.layer addAnimation:anima forKey:@"Anima"];
}


@end
