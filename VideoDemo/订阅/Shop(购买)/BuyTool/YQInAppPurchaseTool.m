//
//  YQInAppPurchaseTool.m
//  YQStoreToolDemo
//
//  Created by problemchild on 16/8/24.
//  Copyright © 2016年 ProblenChild. All rights reserved.
//
#ifdef DEBUG
#define checkURL @"https://sandbox.itunes.apple.com/verifyReceipt"
#else
#define checkURL @"https://buy.itunes.apple.com/verifyReceipt"
#endif

#import "YQInAppPurchaseTool.h"
#import "SubscriptionToolModel.h"

@interface YQInAppPurchaseTool ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>

/**
 *  商品字典
 */
@property(nonatomic,strong)NSMutableDictionary *productDict;

@end

@implementation YQInAppPurchaseTool


//单例
static YQInAppPurchaseTool *storeTool;

//单例
+(YQInAppPurchaseTool *)defaultTool{
    if(!storeTool){
        storeTool = [YQInAppPurchaseTool new];
        [storeTool setup];
    }
    return storeTool;
}

#pragma mark  初始化
/**
 *  初始化
 */
-(void)setup{
    
    self.CheckAfterPay = YES;
    
    // 设置购买队列的监听器
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
}

#pragma mark 询问苹果的服务器能够销售哪些商品
/**
 *  询问苹果的服务器能够销售哪些商品
 */
- (void)requestProductsWithProductArray:(NSArray *)products
{
    NSLog(@"开始请求可销售商品");
    
    // 能够销售的商品
    NSSet *set = [[NSSet alloc] initWithArray:products];
    
    // "异步"询问苹果能否销售
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    
    request.delegate = self;
    
    // 启动请求
    [request start];
}

#pragma mark 获取询问结果，成功采取操作把商品加入可售商品字典里
/**
 *  获取询问结果，成功采取操作把商品加入可售商品字典里
 *
 *  @param request  请求内容
 *  @param response 返回的结果
 */
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    if (self.productDict == nil) {
        self.productDict = [NSMutableDictionary dictionaryWithCapacity:response.products.count];
    }
    
    NSMutableArray *productArray = [NSMutableArray array];
    
    for (SKProduct *product in response.products) {
        //NSLog(@"%@", product.productIdentifier);
        
        // 填充商品字典
        [self.productDict setObject:product forKey:product.productIdentifier];
        
        [productArray addObject:product];
    }
    //通知代理
    [self.delegate IAPToolGotProducts:productArray];
}

#pragma mark - 用户决定购买商品
/**
 *  用户决定购买商品
 *
 *  @param productID 商品ID
 */
- (void)buyProduct:(NSString *)productID
{
    SKProduct *product = self.productDict[productID];
    
    // 要购买产品(店员给用户开了个小票)
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    // 去收银台排队，准备购买(异步网络)
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - SKPaymentTransaction Observer
#pragma mark 购买队列状态变化,,判断购买状态是否成功
/**
 *  监测购买队列的变化
 *
 *  @param queue        队列
 *  @param transactions 交易
 */
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    // 处理结果
    for (SKPaymentTransaction *transaction in transactions) {
        NSLog(@"队列状态变化 %@", transaction);
        // 如果小票状态是购买完成
        if (SKPaymentTransactionStatePurchased == transaction.transactionState) {
            //NSLog(@"购买完成 %@", transaction.payment.productIdentifier);
            
            if(self.CheckAfterPay){
                //需要向苹果服务器验证一下
                //通知代理
                [self.delegate IAPToolBeginCheckingdWithProductID:transaction.payment.productIdentifier];
                // 验证购买凭据
                [self verifyPruchaseWithTransaction:transaction];
            }else{
                //不需要向苹果服务器验证
                //通知代理
                [self.delegate IAPToolBoughtProductSuccessedWithProductID:transaction.payment.productIdentifier
                                                                    andInfo:nil];
                // 将交易从交易队列中删除
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
            
        } else if (SKPaymentTransactionStateRestored == transaction.transactionState) {
            //NSLog(@"恢复成功 :%@", transaction.payment.productIdentifier);
            
            
            [self verifyRestoreWithRransaction:transaction];
            
//            // 通知代理
//            [self.delegate IAPToolRestoredProductID:transaction.payment.productIdentifier];
//
//            // 将交易从交易队列中删除
//            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        } else if (SKPaymentTransactionStateFailed == transaction.transactionState){
            
            // 将交易从交易队列中删除
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            //NSLog(@"交易失败");
            [self.delegate IAPToolCanceldWithProductID:transaction.payment.productIdentifier];
            
            
        }else if(SKPaymentTransactionStatePurchasing == transaction.transactionState){
            NSLog(@"正在购买");
        }else{
            NSLog(@"state:%ld",(long)transaction.transactionState);
            NSLog(@"已经购买");
            // 将交易从交易队列中删除
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
    }
}

#pragma mark - 恢复商品
/**
 *  恢复商品
 */
- (void)restorePurchase
{
    // 恢复已经完成的所有交易.（仅限永久有效商品）
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark 验证购买凭据
/**
 *  验证购买凭据
 */
- (void)verifyPruchaseWithTransaction:(SKPaymentTransaction *)transaction
{
    NSMutableURLRequest *request = [self prepareUrlRequest];
    if (request == nil) {
        return;
    }
    // 提交验证请求，并获得官方的验证JSON结果
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"connectionError = %@",error);
            [self.delegate IAPToolCheckFailedWithProductID:transaction.payment.productIdentifier andInfo:data];
        }else{
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *arr = dict[@"receipt"][@"in_app"];
            [SubscriptionToolModel prepareNeedSubscriptionWithArray:arr];
//            NSString *datastr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"datastr = %@",datastr);
            if (dict != nil) {
                [self.delegate IAPToolBoughtProductSuccessedWithProductID:transaction.payment.productIdentifier andInfo:dict];
            }else{
                [self.delegate IAPToolCheckFailedWithProductID:transaction.payment.productIdentifier andInfo:data];
            }
            
            // 将交易从交易队列中删除
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            
        }
    }];
    
    [task resume];
    
}

/**
 *  验证恢复凭据
 */

- (void)verifyRestoreWithRransaction:(SKPaymentTransaction *)transaction{
    NSMutableURLRequest *request = [self prepareUrlRequest];
    if (request == nil) {
        return;
    }
    // 提交验证请求，并获得官方的验证JSON结果
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"connectionError = %@",error);
            [self.delegate IAPToolCheckFailedWithProductID:transaction.payment.productIdentifier andInfo:data];
        }else{
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *arr = dict[@"receipt"][@"in_app"];
            [SubscriptionToolModel prepareNeedSubscriptionWithArray:arr];
//            NSString *datastr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"datastr = %@",datastr);
            if (dict != nil) {
                [self.delegate IAPToolRestoredProductID:transaction.payment.productIdentifier];
            }else{
                [self.delegate IAPToolCheckFailedWithProductID:transaction.payment.productIdentifier andInfo:data];
            }
            
            // 将交易从交易队列中删除
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
    }];
    
    [task resume];
    
}

- (NSMutableURLRequest *)prepareUrlRequest{
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    
    //NSString *datastrs = [[NSString alloc] initWithData:receiptData];// encoding:NSUTF8StringEncoding];
    // 在网络中传输数据，大多情况下是传输的字符串而不是二进制数据
    // 传输的是BASE64编码的字符串
    /**
     BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
     BASE64是可以编码和解码的
     */
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    if (encodeStr == nil) {
        return nil;
    }
    
    NSDictionary *requestContents = @{@"receipt-data" :  encodeStr, @"password" : YTSubscriptionSecretKey};
    NSError *error;
    NSData *payloadData = [NSJSONSerialization dataWithJSONObject:requestContents options:0 error:&error];
    
    // 发送网络POST请求，对购买凭据进行验证
    //In the test environment, use https://sandbox.itunes.apple.com/verifyReceipt
    //In the real environment, use https://buy.itunes.apple.com/verifyReceipt
    // Create a POST request with the receipt data.
    NSURL *url = [NSURL URLWithString:checkURL];
    
    NSLog(@"checkURL:%@",checkURL);
    
    // 国内访问苹果服务器比较慢，timeoutInterval需要长一点
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
    
    request.HTTPMethod = @"POST";
    
    request.HTTPBody = payloadData;
    
    return request;
}


- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    [SVProgressHUD dismiss];
}



@end
