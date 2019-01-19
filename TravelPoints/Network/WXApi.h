//
//  WXApi.h
//  QDINFI
//  API定义文件
//  Created by ZengTark on 2017/10/20.
//  Copyright © 2017年 quantdo. All rights reserved.
//

#ifndef WXApi_h
#define WXApi_h

const static NSString *APIKey = @"0ddab1fff98f51d5958e2aaab23f3e55";

static NSString * const QD_Domain = @"http://192.168.65.198:9083";

static NSString * const QD_ProjectName = @"/lyjfapp/api/v1/";
static NSString * const QD_MarkProjectName = @"/qdMarketJniServer/";

static NSString * const QD_Service = @"service/";
static NSString * const QD_JniService = @"qdMarketJniServer/";

static NSString * const QD_RestfulService = @"restfulservice/";
static NSString * const QD_WS_Service = @"wsPublicMessage";
static NSTimeInterval const QD_Timeout = 30;

/***************** WS Topic **************************/
static NSString * const WS_TOPIC_Quotation = @"public_instrument_"; //行情订阅（后加交易所id_合约id：public_instrument_exchangeID_instrumentID）
static NSString * const WS_TOPIC_Trade = @"public_trade_return_";    //成交回报（接brokerID + investorID）
static NSString * const WS_TOPIC_Order = @"public_order_return_";    //委托回报（接brokerID + investorID）

static NSString * const WS_TOPIC_Order_Action = @"public_order_action_return_";    //撤单响应（接brokerID + investorID）

static NSString * const WS_TOPIC_Order_Insert = @"public_order_insert_return_";    //下单响应（接brokerID + investorID）

static NSString * const WS_TOPIC_Account = @"public_part_account_"; //资金订阅（接userID）

/***************** API **************************/
static NSString * const api_Login = @"user/login";            //登录
static NSString * const api_LogoutService = @"logout";          //登出
static NSString * const api_GetVerifyCode = @"captcha?d=";      //获取验证码
static NSString * const api_ListMarketData = @"listMarketDataByInstrumentIdList";//合约列表行情
static NSString * const api_GetMarketDataById = @"getMarketDataByInstrumentId";  //根据合约id获取行情
static NSString * const api_ListInstrument = @"listInstrument"; //查询合约列表
static NSString * const api_FindInstrumentList = @"findInstrumentList";

//K线相关
static NSString * const api_ListOneMinKline = @"listOneMinKline";           //一分钟
static NSString * const api_ListThreeMinKline = @"listThreeMinKline";       //三分钟
static NSString * const api_ListFiveMinKline = @"listFiveMinKline";         //五分钟
static NSString * const api_ListTenMinKline = @"listTenMinKline";           //十分钟
static NSString * const api_ListFifteenMinKline = @"listFifteenMinKline";   //十五分钟
static NSString * const api_ListThirtyMinKline = @"listThirtyMinKline";     //三十分钟
static NSString * const api_ListOneHourKline = @"listOneHourKline";         //一小时
static NSString * const api_ListTwoHoursKline = @"listTwoHoursKline";       //两小时
static NSString * const api_ListFourHoursKline = @"listFourHoursKline";     //四小时
static NSString * const api_ListSixHoursKline = @"listSixHoursKline";       //六小时
static NSString * const api_ListTwelveHoursKline = @"listTwelveHoursKline"; //十二小时
static NSString * const api_ListOneDayKline = @"listOneDayKline";           //日K
static NSString * const api_ListThreeDaysKline = @"listThreeDaysKline";     //三天K线
static NSString * const api_ListOneWeekKline = @"listOneWeekKline";         //周K
static NSString * const api_ListOneMonthKline = @"listOneMonthKline";       //月K

static NSString * const api_QueryOperTradingAccount = @"queryOperTradingAccount";   //查询个人资金数据
static NSString * const api_QueryBaseInfo = @"queryBaseInfo";   //查询基础枚举数据

/**************** ServiceName *******************/
static NSString *const QD_Service_Trade = @"qdFrontTradeService";
static NSString *const QD_Service_BaseData = @"baseDataService";
//static NSString *const QD_Service_Market = @"qdFrontMarketDataService";
static NSString *const QD_Service_Market = @"marketDataService";
static NSString *const QD_Service_AppGeneral = @"appGeneralService";
static NSString *const QD_Service_AnonymousAppGeneral = @"anonymousAppGeneralService";  //app匿名服务
static NSString *const QD_Service_FileUpload = @"memberFileUploadService";  //文件上传服务
static NSString *const QD_Service_clientApply = @"clientApplyService";  //身份验证
static NSString *const QD_Service_kLineService = @"kLineService";

/**************** NotificationName about WS *******************/
static NSString *const QD_Notification_Quotation = @"QD_Notification_Quotation";
static NSString *const QD_Notification_Trade = @"QD_Notification_Trade";
static NSString *const QD_Notification_Order = @"QD_Notification_Order";
static NSString *const QD_Notification_OrderInsert = @"QD_Notification_OrderInsert";
static NSString *const QD_Notification_OrderAction = @"QD_Notification_OrderAction";

#endif /* WXApi_h */

