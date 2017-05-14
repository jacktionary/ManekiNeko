//
//  MNRatingListViewController.m
//  ManekiNeko
//
//  Created by JackCheng on 16/3/15.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNRankingListViewController.h"
#import "MNRankingTableViewCell.h"

#import "MNToastUtils.h"
#import "MNGlobalSharedMemeroyCache.h"
#import "YALSunnyRefreshControl.h"
#import "MNNetWorking.h"
#import "MNUserRankingIncomeModel.h"
#import "MNUserRankingApprenticeModel.h"
#import "UILabel+ManekiNeko.h"
#import "MNConst.h"

typedef enum {
    MNRankingViewType_Income,
    MNRankingViewType_Apprentice,
} MNRankingViewType;

static NSString *cellIdentifierForRankingListTableViewCell = @"cellIdentifierForRankingListTableViewCell";

@interface MNRankingListViewController()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak)UISegmentedControl *segmentedControl;
@property (nonatomic, assign)BOOL hasLoaded;
@property (nonatomic, weak)UIView *rankingNoticeInfoView;
@property (nonatomic, weak)UITableView *rankingTableView;
@property (nonatomic,strong)YALSunnyRefreshControl *sunnyRefreshControl;

@property (nonatomic, strong)NSMutableArray *rankingArray;

@property (nonatomic, weak)UILabel *noticeTextLabel;

@end

@implementation MNRankingListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSString *)title
{
    return @"排行榜";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.sunnyRefreshControl beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.sunnyRefreshControl endRefreshing];
}

- (void)initSubViews
{
    // 配置segment control
    [self setupSegmentControl];
    // 配置榜单提示view
    [self setupRankingNoticeInfoView];
    // 配置排行榜tableview
    [self setupRankingTableView];
    // 配置下拉刷新control
    [self setupRefreshControl];
}

#pragma mark - YALSunyRefreshControl methods

-(void)setupRefreshControl
{
    self.sunnyRefreshControl = [YALSunnyRefreshControl new];
    [self.sunnyRefreshControl addTarget:self
                                 action:@selector(sunnyControlDidStartAnimation)
                       forControlEvents:UIControlEventValueChanged];
    [self.sunnyRefreshControl attachToScrollView:self.rankingTableView];
}

-(void)sunnyControlDidStartAnimation
{
    if (!self.hasLoaded) {
        self.hasLoaded = YES;
    }
    
    MNUserRankingRequestIncomeModel *model = [MNUserRankingRequestIncomeModel new];
    model.uid = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] uid];
    model.token = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] token];
    
    if (self.segmentedControl.selectedSegmentIndex == MNRankingViewType_Income) {
        [self fetchIncomeDataWithModel:model];
    } else if (self.segmentedControl.selectedSegmentIndex == MNRankingViewType_Apprentice) {
        [self fetchApprenticeDataWithModel:model];
    }
}

- (void)fetchIncomeDataWithModel:(MNUserRankingRequestIncomeModel *)model
{
    @weakify(self);
    
    [[MNHttpSessionManager manager] POST:kUserIncometop parameters:[model toDictionary]
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     @strongify(self);
                                     NSInteger statusCode = [[responseObject objectForKey:@"status"] integerValue];
                                     
                                     if (statusCode == 0) {
                                         self.rankingArray = [[[[JSONValueTransformer alloc] init] NSArrayFromJSONModelArray:[[JSONModelArray alloc] initWithArray:[responseObject objectForKey:@"result"] modelClass:[MNUserRankingIncomeModel class]]] mutableCopy];
                                         
                                         [self judgeWhetherURInRankingChart];
                                         
                                         [self.rankingTableView reloadData];
                                     } else {
                                         [MNToastUtils showToastViewWithMessage:[responseObject objectForKey:@"info"] ForView:self.view forTimeInterval:3];
                                     }
                                     
                                     [self.sunnyRefreshControl endRefreshing];
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     @strongify(self);
                                     [self.sunnyRefreshControl endRefreshing];
                                 }];
}

- (void)fetchApprenticeDataWithModel:(MNUserRankingRequestIncomeModel *)model
{
    @weakify(self);
    
    [[MNHttpSessionManager manager] POST:kUserApprenticetop parameters:[model toDictionary]
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     @strongify(self);
                                     NSInteger statusCode = [[responseObject objectForKey:@"status"] integerValue];
                                     
                                     if (statusCode == 0) {
                                         self.rankingArray = [[[[JSONValueTransformer alloc] init] NSArrayFromJSONModelArray:[[JSONModelArray alloc] initWithArray:[responseObject objectForKey:@"result"] modelClass:[MNUserRankingApprenticeModel class]]] mutableCopy];
                                         
                                         [self judgeWhetherURInRankingChart];
                                         
                                         [self.rankingTableView reloadData];
                                     } else {
                                         [MNToastUtils showToastViewWithMessage:[responseObject objectForKey:@"info"] ForView:self.view forTimeInterval:3];
                                     }
                                     
                                     [self.sunnyRefreshControl endRefreshing];
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     @strongify(self);
                                     [self.sunnyRefreshControl endRefreshing];
                                 }];
}

#pragma mark - UITableViewDelegate

static CGFloat rowLessOrEqualThan3Height = 72.0;
static CGFloat rowGreaterThan3Height = 46.0;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 3) {
        return rowLessOrEqualThan3Height;
    } else {
        return rowGreaterThan3Height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rankingArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MNRankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForRankingListTableViewCell];
    
    MNBaseModel *model = [self.rankingArray objectAtIndex:indexPath.row];
    
    [cell setModel:model];
    
    cell.rankingNum = indexPath.row + 1;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        [cell addTopLineToCell];
    }
    
    return cell;
}

#pragma mark - Private Methods

- (void)setupSegmentControl
{
    UISegmentedControl *control = [UISegmentedControl new];
    
    control.tintColor = UIColorFromRGB(0xfb7540);
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], NSFontAttributeName, nil];
    
    [control setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    [control insertSegmentWithTitle:@"收入排行" atIndex:MNRankingViewType_Income animated:NO];
    [control insertSegmentWithTitle:@"收徒排行" atIndex:MNRankingViewType_Apprentice animated:NO];
    
    [control addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    control.selectedSegmentIndex = MNRankingViewType_Income;
    
    [self.view addSubview:control];
    
    self.segmentedControl = control;
    
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@22);
        make.left.equalTo(self.view).with.offset(40);
        make.right.equalTo(self.view).with.offset(-40);
    }];
}

- (void)segmentControlValueChanged:(UISegmentedControl *)control
{
    self.rankingArray = [NSMutableArray array];
    
    [self.rankingTableView reloadData];
    
    [self resetRankingNoticeInfoViewHeight];
    
    [self.sunnyRefreshControl beginRefreshing];
}

- (void)setupRankingTableView
{
    // 任务列表
    UITableView *rankingTableView = [[UITableView alloc] init];
    
    rankingTableView.delegate = self;
    rankingTableView.dataSource = self;
    
    rankingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [rankingTableView registerClass:[MNRankingTableViewCell class] forCellReuseIdentifier:cellIdentifierForRankingListTableViewCell];
    
    [self.view addSubview:rankingTableView];
    
    self.rankingTableView = rankingTableView;
    @weakify(self);
    [rankingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(72);
        make.bottom.equalTo(self.rankingNoticeInfoView.mas_top);
    }];
}

static NSInteger heightOfRankingNoticeInfoView = 27;
- (void)setupRankingNoticeInfoView
{
    @weakify(self);
    
    // ranking notice info view alloc
    UIView *rankingInfoView = [UIView new];
    rankingInfoView.backgroundColor = UIColorFromRGB(0xf1ede9);
    
    [self.view addSubview:rankingInfoView];
    
    self.rankingNoticeInfoView = rankingInfoView;
    
    // add tap gesture to ranking notice info view
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rankingNoticeInfoViewTapped)];
    
    [self.rankingNoticeInfoView addGestureRecognizer:tap];
    
    // notice label
    UILabel *noticeLabel = [UILabel labelWithType:LabelTypeDefault fontSize:15 textColor:UIColorFromRGB(0x999898)];
    
    [self.rankingNoticeInfoView addSubview:noticeLabel];
    
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.rankingNoticeInfoView).with.offset(33);
        make.centerY.equalTo(self.rankingNoticeInfoView);
    }];
    
    self.noticeTextLabel = noticeLabel;
    
    // right indicator imgview alloc
    UIImageView *rightIndicatorImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_back_gray_normal"]];
    
    [self.rankingNoticeInfoView addSubview:rightIndicatorImgView];
    
    [rightIndicatorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.rankingNoticeInfoView).with.offset(-14);
        make.centerY.equalTo(self.rankingNoticeInfoView);
    }];
   
    [rankingInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-(CGRectGetHeight(self.tabBarController.tabBar.frame)));
        make.height.equalTo(@0);
    }];
}

- (void)judgeWhetherURInRankingChart
{
    NSString *uid = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] uid];
    BOOL iAmInRankingChart = NO;
    for (MNUserRankingIncomeModel *model in self.rankingArray) {
        if ([model.uid isEqualToString:uid]) {
            
            iAmInRankingChart = YES;
            break;
        }
    }
    
    if (iAmInRankingChart) {
        [self.rankingNoticeInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    } else {
        [self resetNoticeText];
        [self.rankingNoticeInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(heightOfRankingNoticeInfoView));
        }];
    }
}

- (void)rankingNoticeInfoViewTapped
{
    if (self.segmentedControl.selectedSegmentIndex == MNRankingViewType_Income) {
        self.tabBarController.selectedIndex = MNTabBarControllerIndex_Task;
    } else if (self.segmentedControl.selectedSegmentIndex == MNRankingViewType_Apprentice) {
        self.tabBarController.selectedIndex = MNTabBarControllerIndex_Apprentice;
    }
}

- (void)resetRankingNoticeInfoViewHeight
{
    [self.rankingNoticeInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
}

- (void)resetNoticeText
{
    if (self.segmentedControl.selectedSegmentIndex == MNRankingViewType_Income) {
        self.noticeTextLabel.text = @"您还没有上榜，赶快赚钱吧！";
    } else if (self.segmentedControl.selectedSegmentIndex == MNRankingViewType_Apprentice) {
        self.noticeTextLabel.text = @"您还没有上榜，赶快收徒吧！";
    }
}

@end
