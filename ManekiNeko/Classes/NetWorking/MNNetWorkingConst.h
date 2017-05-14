//
//  MNNetWorkingConst.h
//  ManekiNeko
//
//  Created by JackCheng on 16/2/18.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *protocolHTTPS = @"https://";
static NSString *protocolHTTP  = @"http://";

static NSString *baseHost_Debug = @"moneydebug.hardtime.cn/";
static NSString *baseActivity_Debug = @"wwwdebug.hardtime.cn/";

static NSString *baseHost_Release = @"money.hardtime.cn/";
static NSString *baseActivity_Release = @"www.hardtime.cn/";

#define baseHost            baseHost_Debug
#define baseActivityHost    baseActivity_Debug

#define baseNetworkingURL     [NSString stringWithFormat:@"%@%@", protocolHTTPS, baseHost]
#define baseActivityPageURL [NSString stringWithFormat:@"%@%@", protocolHTTP, baseActivityHost]

/*
 *  用户登录
 */
static NSString *const kUserLogin = @"/MoneyAPI/user/login";

/*
 *  用户心跳
 */
static NSString *const kUserHeartbeat = @"/MoneyAPI/user/heartbeat";

/*
 *  领取红包
 */
static NSString *const kUserRedpack = @"/MoneyAPI/user/redpack";

/*
 *  任务列表
 */
static NSString *const kTaskList = @"/MoneyAPI/task/list";

/*
 *  领取任务
 */
static NSString *const kTaskGet = @"/MoneyAPI/task/get";

/*
 *  提交任务
 */
static NSString *const kTaskPut = @"/MoneyAPI/task/put";

/*
 *  任务记录
 */
static NSString *const kTaskRecord = @"/MoneyAPI/task/record";

/*
 *  放弃任务
 */
static NSString *const kTaskDiscard = @"/MoneyAPI/task/discard";

/*
 *  用户信息
 */
static NSString *const kUserInfo = @"/MoneyAPI/user/info";

/*
 *  绑定支付宝
 */
static NSString *const kUserBindingAlipay = @"/MoneyAPI/user/binding/alipay";

/*
 *  修改昵称
 */
static NSString *const kUserUpdateNickname = @"/MoneyAPI/user/update/nickname";

/*
 *  收入排行榜
 */
static NSString *const kUserIncometop = @"/MoneyAPI/user/incometop";

/*
 *  收徒排行榜
 */
static NSString *const kUserApprenticetop = @"/MoneyAPI/user/discipletop";

/*
 *  成绩单
 */
static NSString *const kUserTranscripts = @"/MoneyAPI/user/transcripts";

/*
 *  提现
 */
static NSString *const kUserExpend = @"/MoneyAPI/user/expend";

/*
 *  提现记录
 */
static NSString *const kUserExpendRecord = @"/MoneyAPI/user/expend/record";

/*
 *  收徒列表
 */
static NSString *const kApprenticeList = @"/MoneyAPI/user/disciple";

