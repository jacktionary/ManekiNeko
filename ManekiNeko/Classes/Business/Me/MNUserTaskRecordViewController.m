//
//  MNUserTaskRecordViewController.m
//  ManekiNeko
//
//  Created by JackCheng on 16/3/30.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNUserTaskRecordViewController.h"
#import "Masonry.h"
#import "MNToastUtils.h"
#import "MNGlobalSharedMemeroyCache.h"
#import "UILabel+ManekiNeko.h"
#import "MNMacro.h"
#import "MNNetWorking.h"
#import "YALSunnyRefreshControl.h"
#import "MNUserTaskRecordModel.h"
#import "JSONModelArray.h"
#import "MNUserTaskRecordTableViewCell.h"

static NSString *cellIdentifierForUserTaskRecordTableViewCell = @"cellIdentifierForUserTaskRecordTableViewCell";

@interface MNUserTaskRecordViewController()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)YALSunnyRefreshControl *sunnyRefreshControl;
@property (nonatomic, assign)NSInteger pageNo;

@end

@implementation MNUserTaskRecordViewController

static CGFloat const heightOfOverageView = 127.0;
static CGFloat const offsetYOfOverageViewBottom = -20.0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageNo = 0;
    
    self.view.backgroundColor = UIColorFromRGB(0xf0efef);
}

- (NSString *)title
{
    return @"任务记录";
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
    // 任务部分
    UIView *cashingBackgroundView = [UIView new];
    
    cashingBackgroundView.backgroundColor = UIColorFromRGB(0xFB7540);
    
    [self.view addSubview:cashingBackgroundView];
    
    [cashingBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(heightOfOverageView));
    }];
    
    UILabel *myDisplayLabel = [UILabel new];
    
    myDisplayLabel.text = @"累计任务收益";
    myDisplayLabel.textColor = [UIColor whiteColor];
    myDisplayLabel.font = [UIFont systemFontOfSize:15];
    
    [self.view addSubview:myDisplayLabel];
    
    [myDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cashingBackgroundView);
        make.top.equalTo(cashingBackgroundView).with.offset(28);
    }];
    
    UILabel *overageLabel = [UILabel new];
    
    overageLabel.text = [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] income];
    overageLabel.textColor = [UIColor whiteColor];
    overageLabel.font = [UIFont boldSystemFontOfSize:48];
    
    [self.view addSubview:overageLabel];
    
    [overageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cashingBackgroundView);
        make.bottom.equalTo(cashingBackgroundView.mas_bottom).with.offset(offsetYOfOverageViewBottom);
    }];
    
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
    UITableView *tableView = [[UITableView alloc] init];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView registerClass:[MNUserTaskRecordTableViewCell class] forCellReuseIdentifier:cellIdentifierForUserTaskRecordTableViewCell];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cashingBackgroundView.mas_bottom);
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
    [self.sunnyRefreshControl attachToScrollView:self.tableView];
}

-(void)sunnyControlDidStartAnimation
{
    @synchronized (self) {
        self.pageNo = 0;
    }
    [self requestTaskRecordWithPageNum:self.pageNo];
}

- (void)requestTaskRecordWithPageNum:(NSInteger)pageNo
{
    MNUserTaskRecordRequestModel *model = [MNUserTaskRecordRequestModel new];
    model.uid = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] uid];
    model.token = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] token];
    model.p = [NSString stringWithFormat:@"%ld", (long)pageNo];
    
    [[MNHttpSessionManager manager] POST:kTaskRecord parameters:[model toDictionary]
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
                                         
                                         if (self.pageNo == 0) {
                                             self.dataArray = [NSMutableArray array];
                                         }
                                         
                                         NSArray *resultArray = [[[[JSONValueTransformer alloc] init] NSArrayFromJSONModelArray:[[JSONModelArray alloc] initWithArray:[responseObject objectForKey:@"result"] modelClass:[MNUserTaskRecordModel class]]] mutableCopy];
                                         
                                         if ([resultArray count] <= 0) {
                                             self.pageNo = -1;
                                         } else {
                                             [self.dataArray addObjectsFromArray:resultArray];
                                         }
                                         
                                         if ([self.dataArray count] > 0) {
                                             [self.tableView reloadData];   
                                         }
                                     }
                                    
                                     [self.sunnyRefreshControl endRefreshing];
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     [self.sunnyRefreshControl endRefreshing];
                                 }];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MNUserTaskRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForUserTaskRecordTableViewCell];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MNUserTaskRecordModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell setModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.dataArray count] > 0) {
        return 40;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    ;
    headerView.backgroundColor = UIColorFromRGB(0xf0efef);
    headerView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    headerView.layer.borderWidth = 0.5;
    
    UILabel *taskNameLabel = [UILabel labelWithType:LabelTypeDefault fontSize:14 textColor:UIColorFromRGB(0x808080)];
    taskNameLabel.font = [UIFont boldSystemFontOfSize:14];
    
    taskNameLabel.text = @"任务名称";
    
    [headerView addSubview:taskNameLabel];
    
    [taskNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.centerX.equalTo(headerView).multipliedBy(1.0/3.0);
    }];
    
    UILabel *taskCompleteLabel = [UILabel labelWithType:LabelTypeDefault fontSize:14 textColor:UIColorFromRGB(0x808080)];
    taskCompleteLabel.font = [UIFont boldSystemFontOfSize:14];
    
    taskCompleteLabel.text = @"完成时间";
    
    [headerView addSubview:taskCompleteLabel];
    
    [taskCompleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.centerX.equalTo(headerView);
    }];
    
    UILabel *taskIncomeLabel = [UILabel labelWithType:LabelTypeDefault fontSize:14 textColor:UIColorFromRGB(0x808080)];
    taskIncomeLabel.font = [UIFont boldSystemFontOfSize:14];
    
    taskIncomeLabel.text = @"收入";
    
    [headerView addSubview:taskIncomeLabel];
    
    [taskIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.centerX.equalTo(headerView).multipliedBy(5.0 / 3.0);
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.dataArray count] > 0 && self.pageNo >= 0) {
        return 0;
    } else {
        return 40;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *norecordLabel = [UILabel labelWithType:LabelTypeDefault fontSize:12 textColor:UIColorFromRGB(0x808080)];
    norecordLabel.text = @"暂无更多记录";
    
    [headerView addSubview:norecordLabel];
    
    [norecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(headerView).with.offset(20);
    }];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.dataArray count] - 1 && self.pageNo >= 0) {
        @synchronized (self) {
            self.pageNo += 1;
        }
        
        [self requestTaskRecordWithPageNum:self.pageNo];
    }
}

@end
