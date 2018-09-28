//
//  ShopViewController.m
//  hair_style
//
//  Created by WYT on 2018/1/17.
//  Copyright © 2018年 licheng. All rights reserved.
//

#import "ShopViewController.h"
#import "YQInAppPurchaseTool.h"
#import "SubscriptionToolModel.h"
#import "PrivacyViewController.h"

#import "YTShopContentView.h"

#import "JTBaseNaviController.h"
#import "JTNetworking.h"
#import "JTSetUPViewController.h"

@interface ShopViewController ()<YQInAppPurchaseToolDelegate,YTShopContentViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *subMutDict;

@property (nonatomic,strong) NSArray *pidArr;

@property (nonatomic,strong) YQInAppPurchaseTool *appTool;

@property (nonatomic,strong) YTShopContentView *contentView;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic) NSMutableArray<JTBuyModel *> *dataList;

@end

@implementation ShopViewController

- (NSMutableArray<JTBuyModel *> *)dataList {
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pidArr = kProductIDArray;
    
    [self prepareInitView];

    [JTNetworking getBuy:[NSString stringWithFormat:@"%@appAudit/get/appId/%@/location/1", PORTURL, switchID] parameters:nil CompletionHandler:^(JTBuyModel *model, NSError *error) {
        if (error) {
        }else {
            [self.dataList removeAllObjects];
            [self.dataList addObject:model];
            [self mianfei];
        }
    }];
}

- (void)mianfei {
    SKProduct *onePro = self.subMutDict[ProductID_IAPp25];
    if ([self.dataList[0].auditPass isEqualToString:@"1"]) {
        _contentView.onePriceLB.text = [NSString stringWithFormat:@"%@", self.dataList[0].auditShowName];
    }else {
        _contentView.onePriceLB.text = [NSString stringWithFormat:@"一周会员：¥%@",onePro.price];
    }
}

- (void)prepareInitView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _contentView = [[NSBundle mainBundle] loadNibNamed:@"YTShopContentView" owner:nil options:nil].firstObject;
    _contentView.delegate = self;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = 0;
    if (isPad) {
        x = (kScreenWidth - 486) / 2;
        y = 60;
        width = 486;
    }else {
        x = 0;
        y = 0;
        width = kScreenWidth;
    }
    _contentView.frame = CGRectMake(x, y, width, kScreenH);
    [_scrollView addSubview:_contentView];

    
    [self createInAppPurchaseTool];
}



#pragma mark ----------- 购买功能代理方法 -----------

// 返回
- (void)shopContentViewClickBackButton{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//恢复订阅
- (void)shopContentViewClickRestoreButton{
    
    if (self.subMutDict.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"网络有误，请重新尝试"];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要恢复订阅吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *buyAction0 = [UIAlertAction actionWithTitle:@"恢复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self restoreProduct];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:buyAction0];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// 购买按钮
-(void)shopContentViewClickBuyIdentifier:(NSString *)proIdentifier{
    
    [SVProgressHUD dismiss];
    
    if (self.subMutDict.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"暂无数据，请以后尝试！"];
        return;
    }
    
    SKProduct *tempPro = self.subMutDict[proIdentifier];
    
    if (tempPro == nil) {
        [SVProgressHUD showErrorWithStatus:@"暂无数据，请以后尝试！"];
        return;
    }
    
    BOOL isSubscription = [[[NSUserDefaults standardUserDefaults] objectForKey:YTSubscription] boolValue];
    if (isSubscription) {
        NSString *effectiveProductID = [[NSUserDefaults standardUserDefaults] objectForKey:YTEffectiveProductID];
        if ([effectiveProductID isEqualToString:tempPro.productIdentifier]) {
            [self BuyProduct:tempPro];
        }else{
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"您已经订阅了！\n您可以在主屏幕的设备设置应用中取消或更改%@订阅！！",YTProjectName]];
        }
    }else{
        
        [self BuyProduct:tempPro];
    }
}




// 隐私政策
- (void)shopContentViewClickPrivacyButton{
    
    PrivacyViewController *privacyVC = [[PrivacyViewController alloc] init];
    privacyVC.sourceType = PrivacySourceTypePrivacy;
    
    JTBaseNaviController *navi = [[JTBaseNaviController alloc] initWithRootViewController:privacyVC];
    
    [self presentViewController:navi animated:YES completion:nil];
}

// 使用条款
- (void)shopContentViewClickUseItemButton{
    
    PrivacyViewController *privacyVC = [[PrivacyViewController alloc] init];
    privacyVC.sourceType = PrivacySourceTypeUseTerms;
    
    JTBaseNaviController *navi = [[JTBaseNaviController alloc] initWithRootViewController:privacyVC];
    
    [self presentViewController:navi animated:YES completion:nil];
}





// 纠正购买产品顺序
- (void)changeBuyProductOrder:(NSMutableArray*)products{
    
    self.subMutDict = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < products.count; i++) {
        SKProduct *prod = products[i];
        [_subMutDict setObject:prod forKey:prod.productIdentifier];
        
    }
}

- (void)changeSpendLabel {
    
    SKProduct *onePro = self.subMutDict[ProductID_IAPp25];
    SKProduct *twoPro = self.subMutDict[ProductID_IAPp26];
    if (onePro) {
        _contentView.onePriceLB.text = [NSString stringWithFormat:@"一周会员：¥%@",onePro.price];
    }
    if (twoPro) {
        _contentView.twoPriceLB.text = [NSString stringWithFormat:@"一年会员：¥%@",twoPro.price];
    }
}


#pragma mark -------------IAP--------------

- (void)createInAppPurchaseTool {
    //获取单例
    YQInAppPurchaseTool *IAPTool = [YQInAppPurchaseTool defaultTool];
    
    //设置代理
    IAPTool.delegate = self;
    
    //向苹果询问哪些商品能够购买
    
    [IAPTool requestProductsWithProductArray:_pidArr];
    
    self.appTool = IAPTool;
    
    [MMProgressHUD showWithStatus:@"正在加载"];
    
    [self networkLatency];
    
    
}


- (void)networkLatency{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [NSThread sleepForTimeInterval:20];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.subMutDict.count == 0) {
                [MMProgressHUD dismiss];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络延迟，是否重新加载？" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self shopContentViewClickBackButton];
                }];;
                
                UIAlertAction *buyAction0 = [UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [_appTool requestProductsWithProductArray:_pidArr];
                    
                    [MMProgressHUD showWithStatus:@"正在加载"];
                    
                    [self networkLatency];
                    
                }];
                
                [alert addAction:cancelAction];
                [alert addAction:buyAction0];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            
        });
    });
}

#pragma mark --------YQInAppPurchaseToolDelegate
//IAP工具已获得可购买的商品
- (void)IAPToolGotProducts:(NSMutableArray *)products {
    
    if (products.count > 0) {
        
        // 纠正购买产品顺序
        [self changeBuyProductOrder:products];
        
        // 刷新价格
        [self changeSpendLabel];
    }

    
    [MMProgressHUD dismissWithSuccess:@"加载完成"];
}

//支付失败/取消
- (void)IAPToolCanceldWithProductID:(NSString *)productID {
    NSLog(@"canceld:%@", productID);
    [SVProgressHUD showInfoWithStatus:@"订阅取消"];
}
//支付成功了，并开始向苹果服务器进行验证（若CheckAfterPay为NO，则不会经过此步骤）
- (void)IAPToolBeginCheckingdWithProductID:(NSString *)productID {
    NSLog(@"BeginChecking:%@",productID);
    
    [SVProgressHUD showWithStatus:@"订阅成功，正在验证"];
}
//商品被重复验证了
- (void)IAPToolCheckRedundantWithProductID:(NSString *)productID {
    NSLog(@"CheckRedundant:%@",productID);
    
    [SVProgressHUD showInfoWithStatus:@"重复验证了"];
}

//商品完全购买成功且验证成功了。（若CheckAfterPay为NO，则会在购买成功后直接触发此方法）
- (void)IAPToolBoughtProductSuccessedWithProductID:(NSString *)productID
                                           andInfo:(NSDictionary *)infoDic {
    
    [SVProgressHUD showSuccessWithStatus:@"订阅成功！"];
    [self.contentView awakeFromNib];
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






@end












