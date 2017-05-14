//
//  MNMeHomeViewController.m
//  ManekiNeko
//
//  Created by JackCheng on 16/3/28.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNMeHomeViewController.h"
#import "Masonry.h"
#import "MNMacro.h"
#import "MNToastUtils.h"
#import "UILabel+ManekiNeko.h"
#import "MNMeHomeCellDataModel.h"
#import "MNMeHomeTableViewCell.h"
#import "JSONModelArray.h"
#import "MNGlobalSharedMemeroyCache.h"
#import "JCAlertView.h"

static NSString *cellIdentifierForMeTableViewCell = @"cellIdentifierForMeTableViewCell";

@interface MNMeHomeViewController()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, weak)UITableView *tableView;

@end

@implementation MNMeHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self constructDataArrayAndReloadTableView];
}

- (void)initSubViews
{
    UIView *userInfoView = [UIView new];
    
    userInfoView.backgroundColor = UIColorFromRGB(0xFB7540);
    
    [self.view addSubview:userInfoView];
    
    [userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(104));
    }];
    
    UIImageView *avatarImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_me_user_avatar"]];
    
    [userInfoView addSubview:avatarImgView];
    
    [avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@61);
        make.right.equalTo(userInfoView).multipliedBy(0.5).with.offset(-22);
        make.centerY.equalTo(userInfoView);
    }];
    
    UILabel *userIDLabel = [UILabel labelWithType:LabelTypeDefault fontSize:20 textColor:[UIColor whiteColor]];
    
    userIDLabel.text = [NSString stringWithFormat:@"ID:%@", [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] uid]];
    
    [userInfoView addSubview:userIDLabel];
    
    [userIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userInfoView.mas_right).multipliedBy(0.5);
        make.centerY.equalTo(userInfoView);
    }];
    
    // table view
    UITableView *tableView = [[UITableView alloc] init];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView registerClass:[MNMeHomeTableViewCell class] forCellReuseIdentifier:cellIdentifierForMeTableViewCell];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userInfoView.mas_bottom);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-(CGRectGetHeight(self.tabBarController.tabBar.frame)));
        make.left.equalTo(self.view);
    }];
}

- (void)constructDataArrayAndReloadTableView
{
    NSArray *tableViewDataDictArray = @[@{@"imgName" : @"img_me_nickname",
                                          @"title" : @"昵称",
                                          @"indicatorName" : [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] nickname] ? [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] nickname] : @"",
                                          @"nextViewControllerClassName" : @"MNModifyNickNameViewController"},
                                        @{@"imgName" : @"img_me_binding_alipay",
                                          @"title" : @"绑定支付宝",
                                          @"indicatorName" : [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] alipayname] ? [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] alipayname] : @"",
                                          @"nextViewControllerClassName" : [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] alipayname] ? @"" : @"MNAlipayBindingViewController"},
                                        @{@"imgName" : @"img_me_scoresheet",
                                          @"title" : @"成绩单",
                                         @"indicatorName" : @"",
                                         @"nextViewControllerClassName" : @"MNScoreSheetViewController"},
                                        
                                        @{@"imgName" : @"img_me_tasklist",
                                          @"title" : @"任务记录",
                                          @"indicatorName" : @"",
                                          @"nextViewControllerClassName" : @"MNUserTaskRecordViewController"},
                                        @{@"imgName" : @"img_me_cashingrecord",
                                          @"title" : @"提现记录",
                                          @"indicatorName" : @"",
                                          @"nextViewControllerClassName" : @"MNUserCashingRecordViewController"},
                                        @{@"imgName" : @"img_me_apprenticelist",
                                          @"title" : @"徒弟列表",
                                          @"indicatorName" : @"",
                                          @"nextViewControllerClassName" : @"MNApprenticeListViewController"},
                                        @{@"imgName" : @"img_me_contact_customerservice",
                                          @"title" : @"联系客服",
                                          @"indicatorName" : @"",
                                          @"nextViewControllerClassName" : @"customerservice"},
                                        ];
   
    self.dataArray = [[[[JSONValueTransformer alloc] init] NSArrayFromJSONModelArray:[[JSONModelArray alloc] initWithArray:tableViewDataDictArray modelClass:[MNMeHomeCellDataModel class]]] mutableCopy];
    
    [self.tableView reloadData];
}

#pragma mark - table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MNMeHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForMeTableViewCell];
    
    MNMeHomeCellDataModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell setModel:model];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MNMeHomeCellDataModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    if (model.nextViewControllerClassName && ![model.nextViewControllerClassName isEqualToString:@""]) {
        
        if (![model.nextViewControllerClassName isEqualToString:@"customerservice"]) {
            MNBaseViewController *vc = [NSClassFromString(model.nextViewControllerClassName) new];
            
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [JCAlertView showOneButtonWithTitle:@"提示" Message:@"请联系客服QQ:100010" ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"确定" Click:^{
            }];
        }
    }
}

@end
