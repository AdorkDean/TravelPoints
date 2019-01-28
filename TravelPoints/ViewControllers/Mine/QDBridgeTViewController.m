//
//  QDBridgeViewController.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/16.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDBridgeTViewController.h"
#import <WebKit/WebKit.h>
#import "WebViewJavascriptBridge.h"
#import "QDRefreshHeader.h"

@interface QDBridgeTViewController ()<WKNavigationDelegate>{
    WebViewJavascriptBridge *_bridge;
    CAReplicatorLayer *_containerLayer;
}

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic,weak)CALayer * progressLayer;

@end

@implementation QDBridgeTViewController

- (void)viewWillDisappear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
    self.tabBarController.tabBar.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.tabBarController.tabBar setHidden:YES];
    self.tabBarController.tabBar.frame = CGRectZero;
    
    if (_bridge) {
        return;
    }
    //初始化UIWebView,设置webView代理
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 3, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _webView.navigationDelegate = self;
    _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:_webView];
    
    //设置能够进行桥接
    [WebViewJavascriptBridge enableLogging];
    
    //初始化WebViewJavascriptBridge, 设置代理, 进行桥接
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
    
    //加载网页URL
    [self loadWebViewWithURL];
    
    // 添加属性监听
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    // 进度条
    UIView * progress = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 2)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    // 隐式动画
    CALayer * layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = APP_GREENCOLOR.CGColor;
    [progress.layer addSublayer:layer];
    self.progressLayer = layer;
    
    [_bridge registerHandler:@"POST" handler:^(id data, WVJBResponseCallback responseCallback) {
        //data: js页面传过来的参数
        //准备post请求
        QDLog(@"JS调用OC,并传值过来");
        NSDictionary *dataDic = [data objectForKey:@"param"];
        if(![dataDic count]){
            dataDic = nil;
        }
        NSString *urlStr = [data objectForKey:@"url"];
        [[QDServiceClient shareClient] requestWithHTMLType:kHTTPRequestTypePOST urlString:urlStr params:dataDic successBlock:^(id responseObject) {
            QDLog(@"responseObject");
            responseCallback(responseObject);
        } failureBlock:^(NSError *error) {
        }];
    }];
    
    [_bridge registerHandler:@"goBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        QDLog(@"goBack");
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.progressView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)loadWebViewWithURL{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    [_webView loadRequest:request];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        //        NSLog(@"change == %@",change);
        self.progressLayer.opacity = 1;
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[NSKeyValueChangeNewKey] floatValue] < [change[NSKeyValueChangeOldKey] floatValue]) {
            return;
        }
        self.progressLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[NSKeyValueChangeNewKey] floatValue], 3);
        if ([change[NSKeyValueChangeNewKey] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLayer.opacity = 0;
                _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - WKWebView Delegate
//页面开始加载时调用
- (void) webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    QDLog(@"webViewDidStartLoad");
    [_progressView setProgress:0.2 animated:YES];
}

//页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    QDLog(@"webViewDidFinishLoad");
    [_progressView setProgress:0.8 animated:YES];
    _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
}

//页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self.progressView setProgress:0.0f animated:YES];
}

//接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

//在收到响应后,决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

//在发送请求之前,决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    QDLog(@"拦截到的URL = %@", navigationAction.request.URL.absoluteString);
    
    QDLog(@"拦截到的URL = %@", navigationAction.request.URL.absoluteURL);
    QDLog(@"拦截到的URL = %@", navigationAction.request.URL.parameterString);
    
    NSString *hostName = navigationAction.request.URL.host.lowercaseString;
    QDLog(@"hostName = %@", hostName);
    // 拦截到的URL = xl://quantdo:8888/CommonWeb?url=/hotel/reservation?%7B%22id%22:29,%22checkinDate%22:1548309942089,%22checkoutDate%22:1548396342089%7D, strRequest = xl://quantdo:8888/CommonWeb?url=/hotel/reservation?{"id":29,"checkinDate":1548309942089,"checkoutDate":1548396342089}
    
//    if ([hostName isEqualToString:@"quantdo"]) {
//        //2.匹配字符串
//        QDLog(@"ss = %d", (int)_infoModel.id);
//        NSString *ss = [QD_JSURL stringByAppendingString:@"/#/hotel/reservation?%7B%22id%22:37,%22checkinDate%22:1548661927018,%22checkoutDate%22:1548748327019%7D"];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:ss]];
//        [_webView loadRequest:request];
//        
//        QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
//        NSString *str = @"/#/hotel/reservation?%7B%22id%22:34,%22checkinDate%22:1548386635954,%22checkoutDate%22:1548473035954%7D";
//        bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@", QD_JSURL, str];
//        [self.navigationController pushViewController:bridgeVC animated:YES];
//    }
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self.progressView setProgress:0.0f animated:NO];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the ne/Users/ranjin/Desktop/tewtsdf/tewtsdfw view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (UIProgressView *)progressView
{
    if (!_progressView){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 3)];
        _progressView.progressTintColor = APP_GREENCOLOR;   //已完成的进度的颜色
        _progressView.trackTintColor = [UIColor whiteColor];       //未完成的进度的颜色
        _progressView.progress = 0.3;
        _progressView.progressViewStyle = UIProgressViewStyleDefault;
    }
    return _progressView;
}

@end
