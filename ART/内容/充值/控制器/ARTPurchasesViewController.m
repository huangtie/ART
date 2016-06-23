//
//  ARTPurchasesViewController.m
//  ART
//
//  Created by huangtie on 16/6/22.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTPurchasesViewController.h"
#import "ARTRequestUtil.h"
#import "ARTPurchasesCell.h"
#import <StoreKit/StoreKit.h>

@interface ARTPurchasesViewController()<UITableViewDelegate,UITableViewDataSource,SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UIView *footView;

@property (nonatomic , strong) NSMutableArray *parchasesDatas;

@property (nonatomic , assign) NSInteger selectIndex;

@property (nonatomic , strong) UILabel *currentPriceLabel;
@end

@implementation ARTPurchasesViewController

+ (ARTPurchasesViewController *)launch:(UIViewController *)viewController
{
    ARTPurchasesViewController *vc = [[ARTPurchasesViewController alloc] init];
    [viewController.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"充值金币";
    self.parchasesDatas = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, self.view.width, self.view.height - NAVIGATION_HEIGH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UICOLOR_ARGB(0xfffafafa);
    self.tableView.separatorColor = UICOLOR_ARGB(0xffe5e5e5);
    self.tableView.tableFooterView = self.footView;
    [self.view addSubview:self.tableView];
    
    [self requestUserInfo];
    
    if ([SKPaymentQueue canMakePayments])
    {
        [self requestAppleStore];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.currentPriceLabel.attributedText = [self currentText];
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark GET_SET
- (UIView *)footView
{
    if (!_footView)
    {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        _footView.backgroundColor = [UIColor whiteColor];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _footView.width, ONE_POINT_LINE_WIDTH)];
        topLine.backgroundColor = UICOLOR_ARGB(0xffe5e5e5);
        [_footView addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _footView.width, ONE_POINT_LINE_WIDTH)];
        bottomLine.bottom = _footView.height;
        bottomLine.backgroundColor = UICOLOR_ARGB(0xffe5e5e5);
        [_footView addSubview:bottomLine];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = _footView.bounds;
        [button setTitle:@"立即充值" forState:UIControlStateNormal];
        [button setTitleColor:COLOR_YSYC_ORANGE forState:UIControlStateNormal];
        button.titleLabel.font = FONT_WITH_16;
        [button addTarget:self action:@selector(rechargeClick) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:button];
    }
    return _footView;
}

- (UILabel *)currentPriceLabel
{
    if (!_currentPriceLabel)
    {
        _currentPriceLabel = [[UILabel alloc] init];
        _currentPriceLabel.size = CGSizeMake(200, 20);
        _currentPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _currentPriceLabel;
}

#pragma mark ACTION
- (void)rechargeClick
{
    WS(weak)
    [[ARTUserManager sharedInstance] isLogin:self logined:^(ARTUserData *userInfo) {
        [weak requestPay];
    }];
}

#pragma mark REQUEST
- (void)requestPay
{
    SKPayment *payment = [SKPayment paymentWithProduct:self.parchasesDatas[self.selectIndex]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)requestAppleStore
{
    [self displayHUD];
    NSSet *productIdentifiers = [NSSet setWithArray:@[@"com.ysyc.product.1",@"com.ysyc.product.2",@"com.ysyc.product.3",@"com.ysyc.product.4"]];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    request.delegate = self;
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [self hideHUD];
    request.delegate = nil;
    for(SKProduct *product in response.products)
    {
        [self.parchasesDatas addObject:product];
    }
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [self.tableView reloadData];
}

- (void)requestParchases
{
    [self displayHUD];
    
    WS(weak)
    [ARTRequestUtil requestPurchasesList:^(NSURLSessionDataTask *task, NSArray<ARTPurchasesData *> *datas) {
        [weak hideHUD];
        weak.parchasesDatas = [NSMutableArray arrayWithArray:datas];
        [weak.tableView reloadData];
    } failure:^(ErrorItemd *error) {
        [weak hideHUD];
        [weak.view displayTostError:error.errMsg];
    }];
}

- (void)requestUserInfo
{
    if (![[ARTUserManager sharedInstance] isLogin])
    {
        return;
    }
    WS(weak)
    [ARTRequestUtil requestUserinfo:[ARTUserManager sharedInstance].userinfo.userInfo.userID completion:^(NSURLSessionDataTask *task, ARTUserInfo *data) {
        [ARTUserManager sharedInstance].userinfo.userInfo = data;
        weak.currentPriceLabel.attributedText = [self currentText];
    } failure:^(ErrorItemd *error) {
        
    }];
}

- (void)requestVerify:(SKPaymentTransaction *)transaction
{
    [self hideHUDnoDelay];
    [self displayHUD];
    NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:0];
    ARTPurchaParam *param = [[ARTPurchaParam alloc] init];
    param.receiptyData = receiptString;
    param.productID = transaction.payment.productIdentifier;
    WS(weak)
    [ARTRequestUtil requestVerifyPurchases:param completion:^(NSURLSessionDataTask *task, PURCHA_STATUS status) {
        [weak hideHUD];
        NSString *messge;
        switch (status)
        {
            case PURCHA_STATUS_SUCCEED:
            {
                [weak requestUserInfo];
                messge = @"充值成功";
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
            }
                break;
            case PURCHA_STATUS_FAILURE:
            {
                messge = @"验证失败,请重新进入app重新验证";
            }
            case PURCHA_STATUS_ERROR:
            {
                messge = @"错误,原因未知";
            }
            case PURCHA_STATUS_REPEAT:
            {
                messge = @"重复验证";
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
            }
        }
        [weak.view displayTostSuccess:messge];
    } failure:^(ErrorItemd *error) {
        [weak hideHUD];
        if (error.code == NET_ERROR_9998)
        {
            [[ARTUserManager sharedInstance] isLogin:weak logined:^(ARTUserData *userInfo) {
                [weak requestVerify:transaction];
            }];
            return;
        }
        [weak.view displayTostError:error.errMsg];
    }];
}

#pragma mark DELEGATE_TABLE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.parchasesDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idetifar = @"parchasescell";
    ARTPurchasesCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifar];
    if (!cell)
    {
        cell = [[ARTPurchasesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idetifar];
    }
    
    SKProduct *product = self.parchasesDatas[indexPath.row];
    ARTPurchasesData *data = [[ARTPurchasesData alloc] init];
    data.iapRemark = product.localizedDescription;
    [cell updateData:data isSelect:indexPath.row == self.selectIndex];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndex = indexPath.row;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ARTPURCHASESCELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 44)];
    header.backgroundColor = UICOLOR_ARGB(0xfffafafa);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 200, 20)];
    label.font = FONT_WITH_16;
    label.textColor = UICOLOR_ARGB(0xff333333);
    label.text = @"请选择需要充值的选项:";
    [header addSubview:label];
    
    self.currentPriceLabel.right = header.width - 15;
    self.currentPriceLabel.centerY = header.height / 2;
    self.currentPriceLabel.attributedText = [self currentText];
    [header addSubview:self.currentPriceLabel];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 20)];
    footer.backgroundColor = UICOLOR_ARGB(0xfffafafa);
    return footer;
}

#pragma mark DELEGATE_PAYMENT
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
            {
                [self requestVerify:transaction];
            }
                break;
            case SKPaymentTransactionStateFailed://交易失败
            {
                NSString *message = @"购买失败";
                if(transaction.error.code == SKErrorPaymentCancelled)
                {
                    message = @"交易取消";
                }
                [self.view displayTostError:message];
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
            }
                break;
            case SKPaymentTransactionStateRestored:     //已经购买过该商品
                break;
            case SKPaymentTransactionStatePurchasing:   //商品添加进列表
                break;
            default:
                break;
        }
    }
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentTransaction *)transaction
{
    
}

-(void)paymentQueue:(SKPaymentQueue *)paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    
}

- (NSMutableAttributedString *)currentText
{
    NSMutableAttributedString * attStrA = [[NSMutableAttributedString alloc]initWithString:@"当前账户金币："];
    [attStrA addAttribute:NSFontAttributeName value:FONT_WITH_14 range:NSMakeRange(0, attStrA.length)];
    [attStrA addAttribute:NSForegroundColorAttributeName value:UICOLOR_ARGB(0xff333333) range:NSMakeRange(0, attStrA.length)];
    
    if (![ARTUserManager sharedInstance].userinfo.userInfo.userPrice.length)
    {
        return attStrA;
    }
    
    NSMutableAttributedString * attStrB = [[NSMutableAttributedString alloc]initWithString:[ARTUserManager sharedInstance].userinfo.userInfo.userPrice];
    [attStrB addAttribute:NSFontAttributeName value:FONT_WITH_15 range:NSMakeRange(0, attStrB.length)];
    [attStrB addAttribute:NSForegroundColorAttributeName value:COLOR_YSYC_ORANGE range:NSMakeRange(0, attStrB.length)];
    
    [attStrA appendAttributedString:attStrB];
    return attStrA;
}





@end
