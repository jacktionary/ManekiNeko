//
//  MNAlipayCashingViewController.m
//  ManekiNeko
//
//  Created by JackCheng on 16/3/22.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNAlipayCashingViewController.h"

#import "MNMacro.h"
#import "MNNetWorking.h"
#import "UILabel+ManekiNeko.h"
#import "UIButton+ManekiNeko.h"
#import "Masonry.h"
#import "MNGlobalSharedMemeroyCache.h"
#import "MNUserExpendModel.h"
#import "MNToastUtils.h"

@interface MNAlipayCashingViewController()

@property (nonatomic, weak)UIView *overageView;
@property (nonatomic, weak)UILabel *overageLabel;
@property (nonatomic, weak)UILabel *myOverageDisplayLabel;
@property (nonatomic, weak)UILabel *alipayAccountLabel;
@property (nonatomic, weak)UILabel *alipayNameLabel;
@property (nonatomic, weak)UIButton *selectedButton;

@end

@implementation MNAlipayCashingViewController

static CGFloat const heightOfOverageView = 127.0;
static CGFloat const offsetYOfOverageViewBottom = -20.0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf0efef);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.overageLabel.text = [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] balance];
    self.alipayAccountLabel.text = [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] alipayaccount];
    self.alipayNameLabel.text = [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] alipayname];
}

- (NSString *)title
{
    return @"支付宝提现";
}

- (void)initSubViews
{
    @weakify(self);
    
    // 余额部分
    UIView *overageView = [UIView new];
    
    overageView.backgroundColor = UIColorFromRGB(0xFB7540);
    
    [self.view addSubview:overageView];
    
    [overageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(heightOfOverageView));
    }];
    
    self.overageView = overageView;
    
    UILabel *myOverageDisplayLabel = [UILabel new];
    
    myOverageDisplayLabel.text = @"当前余额";
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
        @strongify(self);
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
    
    // alipay info background
    UIView *alipayInfoBackgroundView = [UIView new];
    
    alipayInfoBackgroundView.backgroundColor = [UIColor whiteColor];
    alipayInfoBackgroundView.layer.borderWidth = 0.5;
    alipayInfoBackgroundView.layer.borderColor = UIColorFromRGB(0xb2b1b1).CGColor;
    
    [self.view addSubview:alipayInfoBackgroundView];
    
    // alipay account description
    UILabel *alipayAccountDescriptionLabel = [UILabel labelWithType:LabelTypeDefault fontSize:16 textColor:UIColorFromRGB(0x575656)];
    alipayAccountDescriptionLabel.font = [UIFont boldSystemFontOfSize:16];
    alipayAccountDescriptionLabel.text = @"支付宝帐号：";
    
    [alipayInfoBackgroundView addSubview:alipayAccountDescriptionLabel];
    
    [alipayAccountDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alipayInfoBackgroundView).with.offset(14);
        make.top.equalTo(alipayInfoBackgroundView).with.offset(14);
    }];
    
    // alipay account label
    UILabel *alipayAccountLabel = [UILabel labelWithType:LabelTypeDefault fontSize:16 textColor:UIColorFromRGB(0x575656)];
    alipayAccountLabel.font = [UIFont boldSystemFontOfSize:16];
    alipayAccountLabel.text = @"****";
    
    [alipayInfoBackgroundView addSubview:alipayAccountLabel];
    
    [alipayAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alipayAccountDescriptionLabel.mas_right);
        make.centerY.equalTo(alipayAccountDescriptionLabel);
    }];
    
    self.alipayAccountLabel = alipayAccountLabel;
    
    // alipay name description
    UILabel *alipayNameDescriptionLabel = [UILabel labelWithType:LabelTypeDefault fontSize:16 textColor:UIColorFromRGB(0x575656)];
    alipayNameDescriptionLabel.font = [UIFont boldSystemFontOfSize:16];
    alipayNameDescriptionLabel.text = @"支付宝实名：";
    
    [alipayInfoBackgroundView addSubview:alipayNameDescriptionLabel];
    
    [alipayNameDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alipayAccountDescriptionLabel);
        make.top.equalTo(alipayAccountDescriptionLabel.mas_bottom).with.offset(18);
    }];
    
    // alipay name label
    UILabel *alipayNameLabel = [UILabel labelWithType:LabelTypeDefault fontSize:16 textColor:UIColorFromRGB(0x575656)];
    alipayNameLabel.font = [UIFont boldSystemFontOfSize:16];
    alipayNameLabel.text = @"****";
    
    [alipayInfoBackgroundView addSubview:alipayNameLabel];
    
    [alipayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(alipayNameDescriptionLabel);
        make.left.equalTo(alipayNameDescriptionLabel.mas_right);
    }];
    
    self.alipayNameLabel = alipayNameLabel;
    
    [alipayInfoBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(overageView.mas_bottom).with.offset(11);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(alipayNameLabel.mas_bottom).with.offset(14);
    }];
    
    // select cashing number
    UILabel *selectCashingNumberLabel = [UILabel labelWithType:LabelTypeDefault fontSize:15 textColor:UIColorFromRGB(0x999898)];
    selectCashingNumberLabel.text = @"选择提现金额";
    
    [self.view addSubview:selectCashingNumberLabel];
    
    [selectCashingNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alipayInfoBackgroundView.mas_bottom).with.offset(8);
        make.left.equalTo(self.view).with.offset(14);
    }];
    
    // buttons of cashing number
    NSArray *cashNumArr = @[@10, @30, @50, @100];
    
    __block NSInteger paddingLeft = 14;
    __block UIView *lastView = nil;
    __block NSInteger counter = 0;
    
    for (NSNumber *num in cashNumArr) {
        UIButton *btn = [self buttonOfCashing];
        
        [btn setTitle:[NSString stringWithFormat:@"%@元", num] forState:UIControlStateNormal];
        btn.tag = counter;
        btn.tintColor = UIColorFromRGB(0xfb7540);
        
        [btn addTarget:self action:@selector(cashNumButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
        
        CGFloat multiRate = 0.93;
        
        if (CGRectGetWidth([[UIScreen mainScreen] bounds]) == 320) {
            multiRate = 0.93;
        } else if (iPhone6) {
            multiRate = 1.13;
        } else if (iPhone6Plus) {
            multiRate = 1.28;
        }
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            if (!lastView) {
                make.left.equalTo(self.view).with.offset(paddingLeft);
            } else {
                make.left.equalTo(lastView.mas_right).with.offset(paddingLeft);
            }
            
            make.top.equalTo(selectCashingNumberLabel.mas_bottom).with.offset(12);
            make.width.equalTo(@(68 * multiRate));
            make.height.equalTo(@(43 * multiRate));
        }];
        
        if (!lastView) {
            btn.selected = YES;
            self.selectedButton = btn;
        }
        
        lastView = btn;
        
        paddingLeft = 12;
        counter ++;
    }
    
    // commit button
    UIButton *commitButton = [UIButton buttonWithButtonType:ButtonTypeOrange];
    
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:commitButton];
    
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view).with.offset(14);
        make.right.equalTo(self.view).with.offset(-14);
        make.top.equalTo(lastView.mas_bottom).with.offset(39);
        make.height.equalTo(@40);
    }];
}

- (UIButton *)buttonOfCashing
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[UIImage imageNamed:@"img_cashing_number_normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"img_cashing_number_selected"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"img_cashing_number_selected"] forState:UIControlStateSelected];
    
    [button setTitleColor:UIColorFromRGB(0x999898) forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xfb7540) forState:UIControlStateHighlighted];
    [button setTitleColor:UIColorFromRGB(0xfb7540) forState:UIControlStateSelected];
    
    return button;
}

- (void)cashNumButtonClicked:(UIButton *)button
{
    self.selectedButton.selected = NO;
    
    button.selected = YES;
    self.selectedButton = button;
}

- (void)commitButtonClicked:(UIButton *)button
{
    MNUserExpendModel *model = [MNUserExpendModel new];
    model.uid = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] uid];
    model.token = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] token];
    model.sum = [NSString stringWithFormat:@"%ld", (long)self.selectedButton.tag];
    
    [[MNHttpSessionManager manager] POST:kUserExpend parameters:[model toDictionary]
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     [MNToastUtils showToastViewWithMessage:[responseObject objectForKey:@"info"] ForView:self.view forTimeInterval:3 completionBlock:^{
                                         if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
                                             [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] setBalance:[responseObject objectForKey:@"result"]];
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }
                                     }];
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     
                                 }];
}

@end
