//
//  WXApi.h
//  QDINFI
//  API定义文件
//  Created by ZengTark on 2017/10/20.
//  Copyright © 2017年 quantdo. All rights reserved.
//

#ifndef WXApi_h
#define WXApi_h

const static NSString *APIKey = @"7c5deed88c0724736c2792a2979a321f";

static NSString * const QD_Domain = @"http://appuat.wedotting.com";


//static NSString * const QD_Domain = @"http://192.168.65.198:9083";
//测试环境
//static NSString * const QD_Domain = @"http://203.110.179.27:60409";
//阿里云外网

//static NSString * const QD_Domain = @"http://47.101.222.172:8080";

static NSString * const QD_ProjectName = @"/lyjfapp/sso/";
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
static NSString * const api_Login = @"login";            //登录
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


static NSString * const api_UserLogout = @"/lyjfapp/sso/logout";          //登出

//发送短信验证码
static NSString * const api_SendVerificationCode = @"/lyjfapp/api/v1/message/sendVerificationCode";

//校验短信验证码
static NSString * const api_VerificationCode = @"/lyjfapp/api/v1/message/verificationCode";

static NSString * const api_TryToRegister = @"/lyjfapp/api/v1/user/tryToRegister";

//验证用户是否注册
static NSString * const api_VerificationRegister = @"/lyjfapp/api/v1/user/verificationRegister";

static NSString * const api_ChangePwd = @"/lyjfapp/api/v1/user/changePwd";



static NSString * const api_GetBasicPrice = @"/lyjfapp/api/v1/common/getBasicPrice";
static NSString * const api_GetUserDetail = @"/lyjfapp/api/v1/user/detail";
static NSString * const api_GetHotelCondition = @"/lyjfapp/api/v1/hotel/findByCondition";
static NSString * const api_GetDZYList = @"/lyjfapp/api/v1/travel/findByCondition"; //定制游列表
static NSString * const api_GetMallList = @"/lyjfapp/api/v1/goods/findOnStockByCondition"; //商城列表

static NSString * const api_FindHotelById = @"/lyjfapp/api/v1/hotel/findHotelById";
static NSString * const api_FindDifferentStrategyDTO = @"/lyjfapp/api/v1/strategy/findDifferentStrategyDTO";     //不同的攻略列表,最新最热酒店定制游

static NSString * const api_RankedSorting = @"/lyjfapp/api/v1/ranklist/findByCondition";   //榜单列表查询
static NSString * const api_FindCanTrade = @"/lyjfapp/api/v1/ctrade/findCanTrade";   //可交易挂单查询
static NSString * const api_FindMyBiddingPosterse = @"/lyjfapp/api/v1/ctrade/findMyBiddingPosters";   //我的挂单查询
static NSString * const api_FindMyOrder = @"/lyjfapp/api/v1/ctrade/findMyOrder";   //我的摘单查询
static NSString * const api_SaveIntentionPosters = @"/lyjfapp/api/v1/ctrade/saveIntentionPosters";   //生成意向单

static NSString * const api_GetRecommendLists = @"/lyjfapp/api/v1/ctrade/getRecommendList";   //智能推荐
static NSString * const api_FindPurchaseInfos = @"/lyjfapp/api/v1/ctrade/findPurchaseInfos";   //积分充值卡查询

static NSString * const api_ReadyToCreateOrder = @"/lyjfapp/api/v1/ctrade/readyToCreateOrder";   //准备申购

static NSString * const api_SaleByProxyApply = @"/lyjfapp/api/v1/ctrade/saleByProxyApply";   //代销申购
static NSString * const api_FindRankTypeToSort = @"/lyjfapp/api/v1/ranklist/findRankTypeToSort";   //榜单类型排序查询
static NSString * const api_FindAllMapDict = @"/lyjfapp/api/v1/common/findAllMapDict";   //数据字典

static NSString * const api_IsLogin = @"/lyjfapp/api/v1/user/isLogin";           //检查用户是否登录


/**
 JAVAScriptBridgeWebView
 */


//static NSString * const QD_JSURL                = @"http://203.110.179.27:60409";    //前端地址
//static NSString * const QD_TESTJSURL            = @"http://203.110.179.27:60409/app/#";    //前端地址


static NSString * const QD_JSURL                = @"http://appuat.wedotting.com";    //前端地址
static NSString * const QD_TESTJSURL            = @"http://appuat.wedotting.com/app/#";    //前端地址

//static NSString * const QD_JSURL                = @"http://47.101.222.172:8080/app";    //前端地址
//static NSString * const QD_TESTJSURL            = @"http://47.101.222.172:8080/app/#";    //前端地址

static NSString * const JS_HOTELDETAIL          = @"/#/hotel/detail";               //酒店详情
static NSString * const JS_CUSTOMERTRAVEL       = @"/#/coustomSwim/detail";         //定制游详情

static NSString * const JS_ATTRACTIONSDETAIL    = @"/#/attractions/detail";         //景区详情
static NSString * const JS_STRATEGYDETAIL       = @"/#/strategy/detail";            //攻略详情
static NSString * const JS_RESTAURANTDETAIL     = @"/#/restaurant/detail";          //餐厅详情


static NSString * const JS_ORDERS               = @"/#/my/orders/home";                  //全部订单
static NSString * const JS_INTEGRAL             = @"/#/my/integral";                //积分账户
static NSString * const JS_ADDRESS              = @"/#/my/address";                 //地址
static NSString * const JS_SECURITYCENTER       = @"/#/securityCenter/home";        //安全中心
static NSString * const JS_STRATEGY             = @"/#/my/strategy";                //攻略
static NSString * const JS_BANKCARD             = @"/#/my/bankCard";                //我的银行卡

static NSString * const JS_SHOPPING             = @"/#/shopping/details";           //商城
static NSString * const JS_SETTING              = @"/#/my/setting";                 //设置
static NSString * const JS_NOTICE               = @"/#/my/notice";                  //系统消息
static NSString * const JS_COLLECTION           = @"/#/my/collection";              //我的收藏
static NSString * const JS_PAYACTION            = @"/#/pay/orderPay";               //支付
static NSString * const JS_RECHARGE             = @"/pay/recharge";                 //充值
static NSString * const JS_WITHDRAW             = @"/pay/withdraw";                 //提现
static NSString * const JS_OPENACCOUNT          = @"/#/my/openAccount";               //开通资金账户


#endif /* WXApi_h */

