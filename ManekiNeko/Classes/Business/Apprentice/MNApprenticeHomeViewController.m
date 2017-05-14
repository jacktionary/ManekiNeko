//
//  MNApprenticeHomeViewController.m
//  ManekiNeko
//
//  Created by JackCheng on 16/4/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNApprenticeHomeViewController.h"
#import "MNApprenticeHomeTableViewData.h"
#import "MNApprenticeHomeTotalTableViewCell.h"
#import "MNApprenticeHomeShareTableViewCell.h"
#import "MNApprenticeHomeItemTableViewCell.h"
#import "MNGlobalSharedMemeroyCache.h"
#import "WXApi.h"
#import "JCAlertView.h"
#import "UILabel+ManekiNeko.h"

#define vURLOfShareWechat [NSString stringWithFormat:@"%@%@", baseActivityPageURL, @"download.jsp"]

static NSString *const cellIdentifierForApprenticeHomeTotalTableViewCell = @"cellIdentifierForApprenticeHomeTotalTableViewCell";
static NSString *const cellIdentifierForApprenticeHomeShareTableViewCell = @"cellIdentifierForApprenticeHomeShareTableViewCell";
static NSString *const cellIdentifierForApprenticeHomeItemTableViewCell = @"cellIdentifierForApprenticeHomeItemTableViewCell";

@interface MNApprenticeHomeViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, strong)MNApprenticeHomeTableViewData *data;

@end

@implementation MNApprenticeHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.data = [MNApprenticeHomeTableViewData new];
    
    MNUserInfoModel *userInfoModel = [[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel];
    
    [self.data addDataArray:@[@{@"img":@"img_appre_totalawards", @"title":@"累计收徒奖励", @"subtitle":@"", @"num":userInfoModel.disciplerewards, @"unit":@"元", @"indicator": @(NO), @"destinationViewControllerName":@""},
                              @{@"img":@"img_appre_numbers", @"title":@"收徒个数", @"subtitle":@"", @"num":userInfoModel.disciplecount, @"unit":@"个", @"destinationViewControllerName":@""},]
                  arrayFlag:@"汇总数据"]; // section1
    [self.data addDataArray:@[@"none"]
                  arrayFlag:@"分享"]; // section2
    [self.data addDataArray:@[@{@"img":@"img_appre_list", @"title":@"徒弟列表", @"subtitle":@"", @"num":@"", @"unit":@"", @"indicator": @(YES), @"destinationViewControllerName":@"MNApprenticeListViewController"},]
                  arrayFlag:@"徒弟列表"]; // section3
    [self.data addDataArray:@[@{@"img":@"img_appre_whyhow", @"title":@"为什么要收徒", @"subtitle":@"（必读）", @"num":@"", @"unit":@"", @"indicator": @(YES), @"destinationViewControllerName":@"MNApprenticeDescriptionWhyViewController"},
                              @{@"img":@"img_appre_whyhow", @"title":@"如何收更多的徒弟", @"subtitle":@"（必读）", @"num":@"", @"unit":@"", @"indicator": @(YES), @"destinationViewControllerName":@"MNApprenticeDescriptionHowViewController"}]
                  arrayFlag:@"readme"]; // section4
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(-45, 0, 30, 0);
    
    [self.tableView reloadData];
}

- (void)initSubViews
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    [tableView registerClass:[MNApprenticeHomeTotalTableViewCell class] forCellReuseIdentifier:cellIdentifierForApprenticeHomeTotalTableViewCell];
    [tableView registerClass:[MNApprenticeHomeShareTableViewCell class] forCellReuseIdentifier:cellIdentifierForApprenticeHomeShareTableViewCell];
    [tableView registerClass:[MNApprenticeHomeItemTableViewCell class] forCellReuseIdentifier:cellIdentifierForApprenticeHomeItemTableViewCell];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MNBaseTableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForApprenticeHomeTotalTableViewCell];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        MNApprenticeHomeTotalTableViewCell *tableViewCell = (MNApprenticeHomeTotalTableViewCell *)cell;
        
        NSDictionary *dict = [self.data dataInIndexPath:indexPath];
        
        [tableViewCell setDict:dict];
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForApprenticeHomeShareTableViewCell];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        MNApprenticeHomeShareTableViewCell *tableViewCell = (MNApprenticeHomeShareTableViewCell *)cell;
        
        tableViewCell.callback = ^void(MNApprenticeShareCellButtonType type) {
            switch (type) {
                case MNApprenticeShareCellButtonType_Share:
                    [self shareToGetApprentices];
                    break;
                case MNApprenticeShareCellButtonType_Scan:
                    [self scanToGetApprentices];
                    break;
                default:
                    break;
            }
        };
    } else if (indexPath.section == 2 || indexPath.section == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForApprenticeHomeItemTableViewCell];
        
        MNApprenticeHomeItemTableViewCell *tableViewCell = (MNApprenticeHomeItemTableViewCell *)cell;
        
        NSDictionary *dict = [self.data dataInIndexPath:indexPath];
        
        [tableViewCell setDict:dict];
    }
    
    if (indexPath.row == 0) {
        [cell addTopLineToCell];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 51.0;
    switch (indexPath.section) {
        case 0:
            height = 58.0;
            break;
        case 1:
            height = 151.0;
            break;
        default:
            break;
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data numberOfSections];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2 || indexPath.section == 3) {
        NSDictionary *dict = [self.data dataInIndexPath:indexPath];
        
        UIViewController *viewController = [NSClassFromString([dict objectForKey:@"destinationViewControllerName"]) new];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

#pragma mark - Private Methods

- (void)shareToGetApprentices
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [NSString stringWithFormat:@"加入招财猫！立拿2元，月入上千！ID：%@", [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] uid]];
    message.description = @"加入招财猫，您的赚钱您做主。";
    [message setThumbImage:[UIImage imageNamed:@"common_placeholder"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = vURLOfShareWechat;
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void)scanToGetApprentices
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    customView.layer.cornerRadius = 5.0;
    customView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *qrcodeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_appre_qrcode"]];
    
    [customView addSubview:qrcodeImgView];
    
    [qrcodeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(customView);
        make.width.height.equalTo(@116);
    }];
    
    UILabel *uidLabel = [UILabel labelWithType:LabelTypeDefault fontSize:15 textColor:UIColorFromRGB(0xfb7540)];
    
    uidLabel.font = [UIFont boldSystemFontOfSize:15];
    
    uidLabel.text = [NSString stringWithFormat:@"邀请ID：%@", [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] uid]];
    
    [customView addSubview:uidLabel];
    
    [uidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(customView);
        make.top.equalTo(qrcodeImgView).with.offset(-(22));
    }];
    
    ({
        UILabel *label = [UILabel labelWithType:LabelTypeDefault fontSize:13 textColor:UIColorFromRGB(0x999898)];
        
        label.text = @"扫一扫加入招财猫";
        
        [customView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(customView);
            make.top.equalTo(qrcodeImgView.mas_bottom).with.offset(6);
        }];
    });
    
    JCAlertView *customAlert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [customAlert show];
}

@end
