//
//  MNCashingHomeViewContrller.m
//  ManekiNeko
//
//  Created by JackCheng on 16/3/22.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNCashingHomeViewContrller.h"

#import "MNMacro.h"
#import "Masonry.h"
#import "UILabel+ManekiNeko.h"
#import "UIButton+ManekiNeko.h"
#import "MNGlobalSharedMemeroyCache.h"

@interface MNCashingHomeViewContrller()

@property (nonatomic, weak)UILabel *balanceNumLabel;

@end

@implementation MNCashingHomeViewContrller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf0efef);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // refresh account balance data
    self.balanceNumLabel.text = [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] balance];
}

- (void)initSubViews
{
    @weakify(self);
    
    // gold coin image view
    UIImageView *goldcoinImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_cashing_goldcoin"]];
    
    [self.view addSubview:goldcoinImgView];
    
    [goldcoinImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).with.offset(60);
        make.width.height.equalTo(@140);
        make.centerX.equalTo(self.view);
    }];
    
    // 我的余额label
    UILabel *myBalanceDiscriptionLabel = [UILabel labelWithType:LabelTypeDefault fontSize:16 textColor:UIColorFromRGB(0x575656)];
    
    myBalanceDiscriptionLabel.text = @"我的余额";
    
    [self.view addSubview:myBalanceDiscriptionLabel];
    
    [myBalanceDiscriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(goldcoinImgView.mas_bottom).with.offset(29);
        make.centerX.equalTo(self.view);
    }];
    
    // balance number label
    UILabel *balanceNumLabel = [UILabel labelWithType:LabelTypeDefault fontSize:48 textColor:UIColorFromRGB(0x575656)];
    
    balanceNumLabel.text = @"****";
    
    [self.view addSubview:balanceNumLabel];
    
    self.balanceNumLabel = balanceNumLabel;
    
    [balanceNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(myBalanceDiscriptionLabel.mas_bottom).with.offset(17);
        make.centerX.equalTo(self.view);
    }];
    
    // yuan label
    UILabel *yuanLabel = [UILabel labelWithType:LabelTypeDefault fontSize:16 textColor:UIColorFromRGB(0x575656)];
    
    yuanLabel.text = @"元";
    
    [self.view addSubview:yuanLabel];
    
    [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(balanceNumLabel.mas_right);
        make.baseline.equalTo(balanceNumLabel);
    }];
    
    // alipay cashing button
    UIButton *alipayButton = [UIButton buttonWithButtonType:ButtonTypeOrange];
    
    [alipayButton setTitle:@"支付宝提现" forState:UIControlStateNormal];
    
    [alipayButton addTarget:self action:@selector(alipayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:alipayButton];
    
    [alipayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(balanceNumLabel.mas_bottom).with.offset(34);
        make.left.equalTo(self.view).with.offset(14);
        make.right.equalTo(self.view).with.offset(-14);
        make.height.equalTo(@40);
    }];
    
    NSInteger offsetBetweenIconAndTitle = 12;
    alipayButton.titleEdgeInsets = UIEdgeInsetsMake(0, offsetBetweenIconAndTitle+8, 0, 0);
    
    // alipay icon imageview
    UIImageView *alipayIconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_cashing_alipay_normal"]];
    
    [alipayButton addSubview:alipayIconImgView];
    
    [alipayIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(alipayButton.titleLabel.mas_left).with.offset(-(offsetBetweenIconAndTitle));
        make.centerY.equalTo(alipayButton.titleLabel);
    }];
    
}

- (void)pushToViewControllerForClassName:(NSString *)className taskButtonClick:(void (^)())taskButtonClick
{
    MNBaseViewController *alipayViewController = [NSClassFromString(className) new];
    alipayViewController.pageClose = taskButtonClick;
    [self.navigationController pushViewController:alipayViewController animated:YES];
}

- (void)alipayButtonClicked:(UIButton *)button
{
    NSString *className = nil;
    void(^taskButtonClick)(void);
    if (![[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] alipayaccount] || [[[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] alipayaccount] isEqualToString:@""]) {
        className = @"MNAlipayBindingViewController";
        taskButtonClick = ^{
            NSLog(@"clickback");
            [self.navigationController popViewControllerAnimated:NO];
            
            [self pushToViewControllerForClassName:@"MNAlipayCashingViewController" taskButtonClick:NULL];
        };
        
    } else {
        className = @"MNAlipayCashingViewController";
    }
    
    [self pushToViewControllerForClassName:className taskButtonClick:taskButtonClick];
}

@end
