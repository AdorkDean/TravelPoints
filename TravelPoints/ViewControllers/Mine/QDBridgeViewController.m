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
    [self.navigationController.navigationBar setHidden:YES];
    if (_bridge) {
        return;
    }
    //初始化UIWebView,设置webView代理
    WKWebView *webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    
    //加载网页URL
    [self loadExamplePage:webView];

    /*
     含义: JS调用OC
     @param registerHandler 要注册的事件名称(比如这里为testObjcCallback)
     @param handel 回调block函数 当后台触发这个事件的时候 会执行block里面的代码
     */
    [_bridge registerHandler:@"POST" handler:^(id data, WVJBResponseCallback responseCallback) {
        //data: js页面传过来的参数
        //准备post请求
//        QDLog(@"testObjcCallback called:%@", data);
        QDLog(@"JS调用OC,并传值过来");
        NSDictionary *param = [data objectForKey:@"param"];
        NSString *url = [data objectForKey:@"url"];
//        [[QDServiceClient shareClient] requestWithUrlString:url params:param successBlock:^(NSDictionary *responseObject) {
//            QDLog(@"responeseObject = %@", responseObject);
//        } failureBlock:^(NSError *error) {
//
//        }];
        //responseCallback 给后台的回复
        responseCallback(@"报告,OC已收到js的请求");
    }];
    
    //网页一加载就会执行web页中的bridge初始化代码,即setupWebViewJavascriptBridge(bridge)函数
    /*
     OC调用JS
     @param callHandler 商定的事件名称,用来调用网页里面相应的事件实现
     @param data id类型,d相当于我们函数中的函数,向网页传递函数执行需要的参数
     注意,这里callHandler分三种,根据需不需要传参数和需不需要后台返回执行结果来决定用哪个。
     */
    [_bridge callHandler:@"testJavascriptHandler" data:@{@"foo": @"before ready"}];
    [_bridge callHandler:@"" data:@"uid:123 pwd:123" responseCallback:^(id responseData) {
        QDLog(@"OC请求js后接受的回调结果:%@", responseData);
    }];
    [self renderButtons:webView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)callHandler:(id)sender{
    id data = @{@"greetingFromObjc": @"Hi there, JS!"};
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id responseData) {
        QDLog(@"testJavascriptHandler responded: %@", responseData);
    }];
}

- (void)loadExamplePage:(WKWebView *)webView{
    NSString *urlStr = @"http://192.168.65.199:3001/#/hotel/detail";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [webView loadRequest:request];
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
