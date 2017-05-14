//
//  MNTaskListViewController.m
//  ManekiNeko
//
//  Created by JackCheng on 15/10/19.
//  Copyright © 2015年 HardTime. All rights reserved.
//

#import "MNTaskListViewController.h"
#import "MNTaskListTableViewCell.h"
#import "MNTaskListHeaderTableViewCell.h"
#import "MNLoadMoreFooterTableViewCell.h"
#import "MNUserRedpackView.h"
#import "MNUserGotRedpackView.h"
#import "MNTaskDetailView.h"
#import "MNToastUtils.h"

#import "YALSunnyRefreshControl.h"

#import "MNNetWorking.h"
#import "MNTaskListModel.h"
#import "MNUserLoginModel.h"
#import "MNTaskPutModel.h"
#import "MNTaskGetModel.h"
#import "MNUserInfoModel.h"
#import "MNTaskDiscardModel.h"
#import "MNUserRedpackModel.h"
#import "MNGlobalSharedMemeroyCache.h"
#import "MNConst.h"
#import "MNDeviceInfo.h"
#import "AppDelegate.h"

#import "JCAlertView.h"
#import "SVWebViewController.h"
#import "MNUserTaskRecordViewController.h"

static NSString *cellIdentifierForTaskListTableViewCell = @"cellIdentifierForTaskListTableViewCell";
static NSString *cellIdentifierForTaskHeaderTableViewCell = @"cellIdentifierForTaskHeaderTableViewCell";
static NSString *cellIdentifierForTaskFooterTableViewCell = @"cellIdentifierForTaskFooterTableViewCell";

@interface MNTaskListViewController ()<UITableViewDataSource, UITableViewDelegate, UIAccelerometerDelegate>

@property (nonatomic, weak)UITableView *taskTableView;
@property (nonatomic,strong) YALSunnyRefreshControl *sunnyRefreshControl;

@property (nonatomic, weak)UIView *overageView;
@property (nonatomic, weak)UILabel *overageLabel;
@property (nonatomic, weak)UILabel *myOverageDisplayLabel;

@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, strong)NSMutableArray *taskDataArray;

@property (nonatomic, assign)BOOL hasLoaded;

@property (nonatomic, weak)MNTaskListResponseModel *selectedTaskModel;
@property (nonatomic, weak)JCAlertView *detaiTasklAlertView;

@end

@implementation MNTaskListViewController

static CGFloat const heightOfOverageView = 127.0;
static CGFloat const offsetYOfOverageViewBottom = -20.0;

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    //获得单例对象
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    //设置代理
    accelerometer.delegate = self;
    //设置采样间隔 1/60.0 就是 1秒采集60次
    accelerometer.updateInterval = 10 / 60.0;
     */
}

- (void)showRedpackViewFirstTimeLaunching
{
    NSString * vActiveAppKey = [NSString stringWithFormat:@"hasActiveApp%@", [MNDeviceInfo deviceID]];
    bool hasActiveApp = [[NSUserDefaults standardUserDefaults] boolForKey:vActiveAppKey];
    
    if (!hasActiveApp) {
        MNUserRedpackView *customView = [[MNUserRedpackView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 18 * 2, 270)];
        
        JCAlertView *customAlert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:NO];
        [customAlert show];
        
        __weak JCAlertView *weakcustomalert = customAlert;
        
        @weakify(self);
        
        customView.confirmRedPackCallBack = ^(NSString *invitedID, NSString *redpackAmount){
            @strongify(self);
            [self getRedpackForView:customAlert inviteID:invitedID block:^(BOOL complete) {
                if (complete) {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:vActiveAppKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [weakcustomalert dismissWithCompletion:^{
                        MNUserGotRedpackView *gotRedpackView = [[MNUserGotRedpackView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 18 * 2, 240)];
                        
                        gotRedpackView.redpackAmount = redpackAmount;
                        
                        JCAlertView *gotRedpackAlert = [[JCAlertView alloc] initWithCustomView:gotRedpackView dismissWhenTouchedBackground:NO];
                        [gotRedpackAlert show];
                        
                        gotRedpackView.confirmRedPackCallBack = ^(void) {
                            [gotRedpackAlert dismissWithCompletion:^{
                                @strongify(self);
                                [self.sunnyRefreshControl beginRefreshing];
                                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                            }];
                        };
                    }];
                }
            }];
        };
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 开始请求数据
    [self.sunnyRefreshControl beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.sunnyRefreshControl endRefreshing];
}

- (void)initSubViews
{
    [self configRightBarButton];
    
    // 余额部分
    UIView *overageView = [UIView new];
    
    overageView.backgroundColor = UIColorFromRGB(0xFB7540);
    
    [self.view addSubview:overageView];
    
    [overageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(heightOfOverageView));
    }];
    
    self.overageView = overageView;
    
    UILabel *myOverageDisplayLabel = [UILabel new];
    
    myOverageDisplayLabel.text = @"我的余额";
    myOverageDisplayLabel.textColor = [UIColor whiteColor];
    myOverageDisplayLabel.font = [UIFont systemFontOfSize:15];
    
    [self.view addSubview:myOverageDisplayLabel];
    
    [myOverageDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(overageView);
        make.top.equalTo(overageView).with.offset(28);
    }];
    
    self.myOverageDisplayLabel = myOverageDisplayLabel;
    
    UILabel *overageLabel = [UILabel new];

    overageLabel.text = @"****";
    overageLabel.textColor = [UIColor whiteColor];
    overageLabel.font = [UIFont boldSystemFontOfSize:48];
    
    [self.view addSubview:overageLabel];
    
    [overageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.overageView);
        make.bottom.equalTo(self.overageView.mas_bottom).with.offset(offsetYOfOverageViewBottom);
    }];
    
    self.overageLabel = overageLabel;
    
    UILabel *yuanLabel = [UILabel new];
    
    yuanLabel.text = @"元";
    yuanLabel.textColor = [UIColor whiteColor];
    yuanLabel.font = [UIFont systemFontOfSize:15];
    
    [self.view addSubview:yuanLabel];
    
    [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(overageLabel.mas_right);
        make.baseline.equalTo(overageLabel);
    }];
    
    // 任务列表
    UITableView *taskTableView = [[UITableView alloc] init];
    
    taskTableView.delegate = self;
    taskTableView.dataSource = self;
    
    taskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [taskTableView registerClass:[MNTaskListTableViewCell class] forCellReuseIdentifier:cellIdentifierForTaskListTableViewCell];
    [taskTableView registerClass:[MNTaskListHeaderTableViewCell class] forCellReuseIdentifier:cellIdentifierForTaskHeaderTableViewCell];
    [taskTableView registerClass:[MNLoadMoreFooterTableViewCell class] forCellReuseIdentifier:cellIdentifierForTaskFooterTableViewCell];
    
    [self.view addSubview:taskTableView];
    
    self.taskTableView = taskTableView;
    
    [taskTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(overageView.mas_bottom);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-(CGRectGetHeight(self.tabBarController.tabBar.frame)));
        make.left.equalTo(self.view);
    }];
    
    [self setupRefreshControl];
}

# pragma mark - YALSunyRefreshControl methods

-(void)setupRefreshControl
{
    self.sunnyRefreshControl = [YALSunnyRefreshControl new];
    [self.sunnyRefreshControl addTarget:self
                                 action:@selector(sunnyControlDidStartAnimation)
                       forControlEvents:UIControlEventValueChanged];
    [self.sunnyRefreshControl attachToScrollView:self.taskTableView];
}

-(void)sunnyControlDidStartAnimation
{
    if (!self.hasLoaded) {
        self.hasLoaded = YES;
        
        @weakify(self);
        
        [self requestLoginData:^(BOOL complete) {
            @strongify(self);
            @weakify(self);
            if (complete) {
                [[NSNotificationCenter defaultCenter] postNotificationName:vNotificationHeartBeatStart object:nil];
                
                [self requestUserInfoData:^(BOOL complete) {
                    @strongify(self);
                    if (complete) {
                        // 开关字段为什么设计成了0是true，1是false呢？诡异的设计…
                        // so...只能按照数值判断了，真蛋疼…
                        if ([[[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] redpack] integerValue] == 0) {
                            [self showRedpackViewFirstTimeLaunching];
                        }
                        
                        [self requestTaskListDataThenEndRefreshing];
                    } else {
                        [self.sunnyRefreshControl endRefreshing];
                    }
                }];
            } else {
                [self.sunnyRefreshControl endRefreshing];
            }
        }];
    } else {
        @weakify(self);
        [self requestUserInfoData:^(BOOL complete) {
            @strongify(self);
            if (complete) {
                [self requestTaskListDataThenEndRefreshing];
            } else {
                [self.sunnyRefreshControl endRefreshing];
            }
        }];
    }
}

- (void)getRedpackForView:(UIView *)view inviteID:(NSString *)inviteID block:(void(^)(BOOL complete))completeBlock
{
    MNUserRedpackModel *model = [MNUserRedpackModel new];
    
    if (inviteID) {
        model.ruid = inviteID;
    } else {
        model.ruid = @"";
    }
    model.uid = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] uid];
    model.token = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] token];
    model.ruid = inviteID;
    
    [[MNHttpSessionManager manager] POST:kUserRedpack parameters:[model toDictionary]
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
                                         completeBlock(YES);
                                     } else {
                                         [MNToastUtils showToastViewWithMessage:[responseObject objectForKey:@"info"] ForView:view forTimeInterval:3];
                                     }
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     
                                 }];
}

- (void)requestUserInfoData:(void(^)(BOOL complete))completeBlock
{
    // request balance data infomation & task list data
    MNUserInfoRequestModel *deviceModel = [MNUserInfoRequestModel new];
    deviceModel.uid = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] uid];
    deviceModel.token = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] token];
    
    [[MNHttpSessionManager manager] POST:kUserInfo parameters:[deviceModel toDictionary]
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
                                         NSError *error;
                                         [[MNGlobalSharedMemeroyCache sharedInstance] setUserInfoModel:[[MNUserInfoModel alloc] initWithDictionary:[responseObject objectForKey:@"result"] error:&error]];
                                         completeBlock(YES);
                                     } else {
                                         completeBlock(NO);
                                     }
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     completeBlock(NO);
                                 }];
}

- (void)requestLoginData:(void(^)(BOOL complete))completeBlock
{
    // request balance data infomation & task list data
    MNUserLoginModel *deviceModel = [MNUserLoginModel new];
    [deviceModel setupBidsAndPnames];
    [deviceModel setupModelData];
    
    [[MNHttpSessionManager manager] POST:kUserLogin parameters:[deviceModel toDictionary]
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
                                         [[MNGlobalSharedMemeroyCache sharedInstance] setUserLoginModel:[[MNUserLoginResponseModel alloc] initWithDictionary:[responseObject objectForKey:@"result"] error:nil]];
                                         
                                         // app更新信息
                                         NSError *error;
                                         MNAppUpdateInfoModel *appUpdateInfoModel = [[MNAppUpdateInfoModel alloc] initWithDictionary:[responseObject objectForKey:@"result2"] error:&error];
                                         
                                         if ([[appUpdateInfoModel updatetype] integerValue] != MNUpdateType_None) {
                                             
                                             if ([[appUpdateInfoModel updatetype] integerValue] == MNUpdateType_Force) {
                                                 
                                                 void (^click)(void) = ^void(void) {
                                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[appUpdateInfoModel versionurl]]];
                                                 };
                                                 
                                                 JCAlertView *alertView = [JCAlertView new];
                                                 
                                                 alertView.displayAlertWhenButtonsClicked = YES;
                                                 
                                                 [alertView configAlertViewPropertyWithTitle:@"更新提示" Message:[appUpdateInfoModel versioninfo] Buttons:@[@{[NSString stringWithFormat:@"%zi", JCAlertViewButtonTypeDefault] : @"确定"}] Clicks:@[click] ClickWithIndex:nil];
                                                 
                                             } else if ([[appUpdateInfoModel updatetype] integerValue] == MNUpdateType_Normal) {
                                                 [JCAlertView showTwoButtonsWithTitle:@"更新提示" Message:[appUpdateInfoModel versioninfo] ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"确定" Click:^{
                                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[appUpdateInfoModel versionurl]]];
                                                 } ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"暂不更新" Click:^{
                                                     
                                                 }];
                                             }
                                             
                                             completeBlock(NO);
                                             
                                         } else {
                                             completeBlock(YES);
                                         }
                                         
                                     } else {
                                         self.hasLoaded = NO;
                                         completeBlock(NO);
                                     }
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     completeBlock(NO);
                                 }];
}

- (void)requestTaskListDataThenEndRefreshing
{
    @weakify(self);
    [self requestTaskListData:^(BOOL complete) {
        @strongify(self);
        [self.taskTableView reloadData];
        
        self.overageLabel.text = [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] balance];
        
        [self.sunnyRefreshControl endRefreshing];
    }];
}

- (void)requestTaskListData:(void(^)(BOOL complete))completeBlock
{
    // request balance data infomation & task list data
    @weakify(self);
    MNTaskListModel *taskListModel = [MNTaskListModel new];
    taskListModel.uid = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] uid];
    taskListModel.token = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] token];
    taskListModel.p = [NSString stringWithFormat:@"%ld", (long)self.pageNum];
    [[MNHttpSessionManager manager] POST:kTaskList parameters:[taskListModel toDictionary]
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     @strongify(self);
                                     if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
                                         self.taskDataArray = [[[[JSONValueTransformer alloc] init] NSArrayFromJSONModelArray:[[JSONModelArray alloc] initWithArray:[responseObject objectForKey:@"result"] modelClass:[MNTaskListResponseModel class]]] mutableCopy];
                                         
                                         completeBlock(YES);
                                     } else {
                                         completeBlock(NO);
                                     }
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     completeBlock(NO);
                                 }];
}

#pragma mark - UITableViewDelegate

static CGFloat section1Height = 56.0;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return section1Height;
    } else if (indexPath.section == 1) {
        return 74;
    } else {
        return 55;
    }
}

- (void)showTaskDetailView:(MNTaskListResponseModel *)model
{
    CGFloat detailViewHeight = 425;
    if (iPhone6 || iPhone6Plus) {
        detailViewHeight = 380;
    }
    
    MNTaskDetailView *customView = [[MNTaskDetailView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 18 * 2, detailViewHeight)];
    
    [customView setModel:model];
    
    JCAlertView *customAlert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:NO];
    
    [customAlert show];
    
    self.detaiTasklAlertView = customAlert;
    
    __weak JCAlertView *weakcustomalert = customAlert;
    
    customView.viewCloseCallback = ^(MNTaskDetailViewCallbackType type, MNTaskListResponseModel *model) {
        
        void(^completeBlock)(BOOL complete) = ^(BOOL complete) {
            if (complete) {
                [weakcustomalert dismissWithCompletion:^{
                    [self.sunnyRefreshControl beginRefreshing];
                }];
            }
        };
        
        if (type == MNTaskDetailViewCallbackType_Commit) {
            [self commitTaskWithModel:model block:^(BOOL complete) {
                completeBlock(complete);
            }];
        } else if (type == MNTaskDetailViewCallbackType_Aboart) {
            [self aboartTaskWithModel:model callback:^(BOOL complete) {
                completeBlock(complete);
            }];
        }
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        MNTaskListResponseModel *model = [self.taskDataArray objectAtIndex:indexPath.row];
        
        [self getTaskThenShowDetailViewWithModel:model];
    } else if (indexPath.section == 0) {
        
    }
    
}

- (void)getTaskThenShowDetailViewWithModel:(MNTaskListResponseModel *)model
{
    if (model.userstate == MNTaskUserStatus_Processing) {
        [self showTaskDetailView:model];
    } else {
        @weakify(self);
        @weakify(model);
        [self getTaskWithModel:model completeBlock:^(BOOL complete) {
            @strongify(self);
            @strongify(model);
            if (complete) {
                [self showTaskDetailView:model];
            }
        }];
    }
}

- (void)getTaskWithModel:(MNTaskListResponseModel *)model completeBlock:(void(^)(BOOL complete))completeBlock
{
    self.selectedTaskModel = model;
    
    MNTaskGetModel *taskGetModel = [MNTaskGetModel new];
    [taskGetModel setupModelData];
    taskGetModel.uid = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] uid];
    taskGetModel.token = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] token];
    taskGetModel.tid = model.tid;
    
    @weakify(self);
    [[MNHttpSessionManager manager] POST:kTaskGet parameters:[taskGetModel toDictionary]
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     @strongify(self);
                                     NSInteger statusCode = [[responseObject objectForKey:@"status"] integerValue];
                                     if (statusCode == 0) {
                                         completeBlock(YES);
                                     } else if (statusCode == 1209) {
                                         [self showAboartOldTaskViewWithMessageInfo:(NSString *)[responseObject objectForKey:@"info"]];
                                         completeBlock(NO);
                                     } else {
                                         [MNToastUtils showToastViewWithMessage:[responseObject objectForKey:@"info"] ForView:self.view forTimeInterval:3];
                                         completeBlock(NO);
                                     }
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     @strongify(self);
                                     [MNToastUtils showNetworkErrorToastForView:self.view];
                                     completeBlock(NO);
                                 }];
}

- (void)commitTaskWithModel:(MNTaskListResponseModel *)model block:(void(^)(BOOL complete))completeBlock
{
    MNTaskGetModel *taskGetModel = [MNTaskGetModel new];
    [taskGetModel setupModelData];
    taskGetModel.uid = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] uid];
    taskGetModel.token = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] token];
    taskGetModel.tid = model.tid;
    
    @weakify(self);
    [[MNHttpSessionManager manager] POST:kTaskPut parameters:[taskGetModel toDictionary]
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     NSInteger statusCode = [[responseObject objectForKey:@"status"] integerValue];
                                     if (statusCode == 0) {
                                         completeBlock(YES);
                                     } else {
                                         [MNToastUtils showToastViewWithMessage:[responseObject objectForKey:@"info"] ForView:[[UIApplication sharedApplication] keyWindow] forTimeInterval:3 completionBlock:^{
                                             if (statusCode == 1210) {
                                                 completeBlock(YES);
                                             } else {
                                                 completeBlock(NO);
                                             }
                                         }];
                                     }
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     @strongify(self);
                                     [MNToastUtils showNetworkErrorToastForView:self.view completionBlock:^{
                                         completeBlock(NO);        
                                     }];
                                 }];
}

- (void)showAboartOldTaskViewWithMessageInfo:(NSString *)messageInfo
{
    @weakify(self);
    [JCAlertView showTwoButtonsWithTitle:@"提示" Message:messageInfo ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"取消" Click:NULL ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"确定" Click:^{
        @strongify(self);
        [self aboartOldTaskThenGetTask];
    }];
}

- (void)aboartOldTaskThenGetTask
{
    [self aboartTaskWithModel:nil callback:^(BOOL complete) {
        [self getTaskThenShowDetailViewWithModel:self.selectedTaskModel];
    }];
}

- (void)aboartTaskWithModel:(MNTaskListResponseModel *)model callback:(void(^)(BOOL complete))callback
{
    MNTaskDiscardModel *taskDiscardModel = [MNTaskDiscardModel new];
    
    taskDiscardModel.uid = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] uid];
    taskDiscardModel.token = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] token];
    if (!model) {
        taskDiscardModel.tid = @"0";
    } else {
        taskDiscardModel.tid = model.tid;
    }
    
    @weakify(self);
    [[MNHttpSessionManager manager] POST:kTaskDiscard parameters:[taskDiscardModel toDictionary]
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     @strongify(self);
                                     NSInteger statusCode = [[responseObject objectForKey:@"status"] integerValue];
                                     if (statusCode == 0) {
                                         if (callback) {
                                             callback(YES);
                                         }
                                     } else {
                                         [MNToastUtils showToastViewWithMessage:[responseObject objectForKey:@"info"] ForView:self.view forTimeInterval:3];
                                     }
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     @strongify(self);
                                     [MNToastUtils showNetworkErrorToastForView:self.view];
                                 }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /*
     *  20160304-与宏亮商议暂时不对任务list进行分页，每次获取所有数据，因此只需2个section足够。
     */
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return [self.taskDataArray count];
    } else if (section == 2) {
        return 1;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MNBaseTableViewCell *cell = nil;
    if (indexPath.section == 0) {
        MNTaskListHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForTaskHeaderTableViewCell];
        cell = headerCell;
        headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        headerCell.incomeLabel.text = [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] todayincome];
        headerCell.apprenticeLabel.text = [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] disciplecount];
        
        headerCell.callback = ^void(void) {
            UINavigationController *navController = self.navigationController.tabBarController.viewControllers[MNTabBarControllerIndex_Me];
            [navController popToRootViewControllerAnimated:NO];
            
            self.navigationController.tabBarController.selectedIndex = MNTabBarControllerIndex_Me;
            
            MNBaseViewController *vc = [MNUserTaskRecordViewController new];
            
            [navController pushViewController:vc animated:YES];
        };
        
    } else if (indexPath.section == 1) {
        MNTaskListTableViewCell *taskCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForTaskListTableViewCell];
        
        cell = taskCell;
        
        [taskCell setModel:[self.taskDataArray objectAtIndex:indexPath.row]];
        @weakify(self);
        taskCell.taskButtonClick = ^void(MNTaskListResponseModel *model) {
            @strongify(self);
            [self getTaskThenShowDetailViewWithModel:model];
        };
    } else if (indexPath.section == 2) {
        MNTaskListHeaderTableViewCell *footerCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForTaskFooterTableViewCell];
        cell = footerCell;
        footerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetY = 60.0;
    
    if (scrollView.contentSize.height < [[UIScreen mainScreen] bounds].size.height - self.navigationController.navigationBar.frame.size.height - (heightOfOverageView -  + contentOffsetY) - self.navigationController.tabBarController.tabBar.frame.size.height) {
        return;
    }
    
    if (scrollView.contentOffset.y < contentOffsetY && scrollView.contentOffset.y >0) {
        
        CGFloat contentOffsetYPercentage = fmodf(scrollView.contentOffset.y, contentOffsetY) / contentOffsetY;
        
        if (contentOffsetYPercentage > 0.9) {
            [self.overageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(heightOfOverageView - contentOffsetY));
            }];
        } else {
            [self.overageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(heightOfOverageView - contentOffsetY*contentOffsetYPercentage));
            }];
        }
        
        [self.overageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.overageView.mas_bottom).with.offset(offsetYOfOverageViewBottom + 15*contentOffsetYPercentage);
        }];
        
        self.myOverageDisplayLabel.alpha = 1.0 - contentOffsetYPercentage;
        
    } else if (scrollView.contentOffset.y >= contentOffsetY) {
        [self.overageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(heightOfOverageView - contentOffsetY));
        }];
        
        [self.overageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.overageView.mas_bottom).with.offset(offsetYOfOverageViewBottom + 15);
        }];
        self.myOverageDisplayLabel.alpha = 0;
    } else if (scrollView.contentOffset.y <= 0.0) {
        [self.overageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(heightOfOverageView));
        }];
        
        [self.overageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.overageView.mas_bottom).with.offset(offsetYOfOverageViewBottom + 0);
        }];
        self.myOverageDisplayLabel.alpha = 1;
    }
}

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAccelerometerChanged object:acceleration];
}

@end
