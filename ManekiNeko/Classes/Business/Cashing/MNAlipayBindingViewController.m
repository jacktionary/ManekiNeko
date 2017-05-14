//
//  MNAlipayBindingViewController.m
//  ManekiNeko
//
//  Created by JackCheng on 16/3/22.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNAlipayBindingViewController.h"

#import "MNMacro.h"
#import "MNNetWorking.h"
#import "UILabel+ManekiNeko.h"
#import "UIButton+ManekiNeko.h"
#import "UITextField+ManekiNeko.h"
#import "Masonry.h"
#import "MNUserBindingAlipayModel.h"
#import "MNGlobalSharedMemeroyCache.h"
#import "MNToastUtils.h"

@interface MNAlipayBindingViewController()<UITextFieldDelegate>

@property (nonatomic, weak)UITextField *alipayAccountTextField;
@property (nonatomic, weak)UITextField *alipayTrueNameTextField;
@property (nonatomic, weak)UIButton *confirmButton;

@end

@implementation MNAlipayBindingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf0efef);
}

- (NSString *)title
{
    return @"绑定支付宝";
}

- (void)initSubViews
{
    @weakify(self);
    
    // 支付宝帐号
    // background
    UIView *alipayAccountBackgroundView = [UIView new];
    alipayAccountBackgroundView.backgroundColor = UIColorFromRGB(0xffffff);
    alipayAccountBackgroundView.layer.borderWidth = 0.5;
    alipayAccountBackgroundView.layer.borderColor = UIColorFromRGB(0xb2b1b1).CGColor;
    
    [self.view addSubview:alipayAccountBackgroundView];
    [alipayAccountBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(14);
        make.height.equalTo(@40);
    }];
    
    // label
    UILabel *alipayAccountLabel = [UILabel labelWithType:LabelTypeDefault
                                                fontSize:16 textColor:UIColorFromRGB(0x888787)];
    alipayAccountLabel.text = @"支付宝帐号";
    
    [alipayAccountBackgroundView addSubview:alipayAccountLabel];
    
    [alipayAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alipayAccountBackgroundView).with.offset(14);
        make.centerY.equalTo(alipayAccountBackgroundView);
    }];
    
    // text field
    UITextField *alipayAccountTextField = [UITextField textFieldWithType:TextFieldTypeDefault];
    
    alipayAccountTextField.placeholder = @"请输入您的支付宝帐号";
    
    [alipayAccountBackgroundView addSubview:alipayAccountTextField];
    
    [alipayAccountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alipayAccountLabel.mas_right).with.offset(18);
        
        make.centerY.equalTo(alipayAccountBackgroundView);
    }];
    
    self.alipayAccountTextField = alipayAccountTextField;
    self.alipayAccountTextField.delegate = self;
    
    // 支付宝实名
    // background
    UIView *alipayTrueNameBackgroundView = [UIView new];
    alipayTrueNameBackgroundView.backgroundColor = UIColorFromRGB(0xffffff);
    alipayTrueNameBackgroundView.layer.borderWidth = 0.5;
    alipayTrueNameBackgroundView.layer.borderColor = UIColorFromRGB(0xb2b1b1).CGColor;
    
    [self.view addSubview:alipayTrueNameBackgroundView];
    
    [alipayTrueNameBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self.view);
        make.height.equalTo(alipayAccountBackgroundView);
        make.top.equalTo(alipayAccountBackgroundView.mas_bottom).with.offset(14);
    }];
    
    // label
    UILabel *alipayTrueNameLabel = [UILabel labelWithType:LabelTypeDefault fontSize:16 textColor:UIColorFromRGB(0x888787)];
    alipayTrueNameLabel.text = @"支付宝实名";
    
    [alipayTrueNameBackgroundView addSubview:alipayTrueNameLabel];
    
    [alipayTrueNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alipayTrueNameBackgroundView).with.offset(14);
        make.centerY.equalTo(alipayTrueNameBackgroundView);
    }];
    
    // text field
    UITextField *alipayTrueNameTextField = [UITextField textFieldWithType:TextFieldTypeDefault];
    
    alipayTrueNameTextField.placeholder = @"请输入您的支付宝实名";
    
    [alipayTrueNameBackgroundView addSubview:alipayTrueNameTextField];
    
    [alipayTrueNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alipayTrueNameLabel.mas_right).with.offset(18);
        
        make.centerY.equalTo(alipayTrueNameBackgroundView);
    }];
    
    self.alipayTrueNameTextField = alipayTrueNameTextField;
    self.alipayTrueNameTextField.delegate = self;
    
    // 说明label
    UITextView *descriptionTextView = [UITextView new];
    descriptionTextView.text = @"请注意：\n1.请确认支付宝帐号和支付宝实名真实有效，绑定后无法修改。\n2.每笔提现支付宝会收取1元手续费，大额提现更实惠。";
    descriptionTextView.backgroundColor = [UIColor clearColor];
    descriptionTextView.textColor = UIColorFromRGB(0xb2b1b1);
    descriptionTextView.userInteractionEnabled = NO;
    descriptionTextView.font = [UIFont systemFontOfSize:12];
    
    [self.view addSubview:descriptionTextView];
    
    [descriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view).with.offset(14);
        make.right.equalTo(self.view).with.offset(-14);
        make.top.equalTo(alipayTrueNameBackgroundView.mas_bottom).with.offset(14);
        make.height.equalTo(@50);
    }];
    
    // 确定按钮
    UIButton *confirmButton = [UIButton buttonWithButtonType:ButtonTypeOrange];
    
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmButton];
    
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(14);
        make.right.equalTo(self.view).with.offset(-14);
        make.height.equalTo(@40);
        make.top.equalTo(descriptionTextView.mas_bottom).with.offset(20);
    }];
    
    self.confirmButton = confirmButton;
    self.confirmButton.enabled = NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![self.alipayTrueNameTextField.text isEqualToString:@""] &&
        ![self.alipayAccountTextField.text isEqualToString:@""]) {
        self.confirmButton.enabled = YES;
    }
    
    return YES;
}

- (void)confirmButtonClicked:(UIButton *)button
{
    MNUserBindingAlipayModel *model = [MNUserBindingAlipayModel new];
    model.uid = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] uid];
    model.token = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] token];
    model.alipayaccount = self.alipayAccountTextField.text;
    model.alipayname = self.alipayTrueNameTextField.text;
    
    @weakify(self);
    [[MNHttpSessionManager manager] POST:kUserBindingAlipay parameters:[model toDictionary]
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     @strongify(self);
                                     if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
                                         [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] setAlipayaccount:self.alipayAccountTextField.text];
                                         [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] setAlipayname:self.alipayTrueNameTextField.text];
                                         if (self.pageClose) {
                                             self.pageClose();
                                         }
                                     } else {
                                         [MNToastUtils showToastViewWithMessage:[responseObject objectForKey:@"info"] ForView:self.view forTimeInterval:3];
                                     }
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     
                                 }];
}

@end
