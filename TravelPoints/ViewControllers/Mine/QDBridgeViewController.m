//
//  QDBridgeViewController.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/16.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDBridgeViewController.h"
#import <WebKit/WebKit.h>
#import "WebViewJavascriptBridge.h"
@interface QDBridgeViewController ()<WKNavigationDelegate>{
    WebViewJavascriptBridge *_bridge;
}

@end

@implementation QDBridgeViewController

- (void)viewWillAppear:(BOOL)animated{
    if (_bridge) {
        return;
    }
    //初始化UIWebView,设置webView代理
    WKWebView *webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:self.view.bounds];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    //注册handle供JS调用--把注册过的handle保存起来。
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        QDLog(@"testObjcCallback called:%@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
    
    //加载网页URL
    [self loadExamplePage:webView];

    //网页一加载就会执行web页中的bridge初始化代码,即setupWebViewJavascriptBridge(bridge)函数
    [_bridge callHandler:@"testJavascriptHandler" data:@{@"foo": @"before ready"}];
    [self renderButtons:webView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)callHandler:(id)sender{
    id data = @{@"greetingFromObjc": @"Hi there, JS!"};
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id responseData) {
        QDLog(@"testJavascriptHandler responded: %@", responseData);
    }];
}

- (void)loadExamplePage:(WKWebView *)webView{
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)renderButtons:(WKWebView *)webView{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handle" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(10, 400, 100, 35);
    callbackButton.titleLabel.font = font;
    
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload webView" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(110, 400, 100, 35);
    reloadButton.titleLabel.font = font;
}
#pragma mark - WKWebView Delegate
- (void) webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    QDLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    QDLog(@"webViewDidFinishLoad");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
