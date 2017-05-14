//
//  MNModifyNickNameViewController.m
//  ManekiNeko
//
//  Created by JackCheng on 16/3/29.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNModifyNickNameViewController.h"
#import "MNMacro.h"
#import "Masonry.h"
#import "MNNetWorking.h"
#import "MNUserUpdateNicknameModel.h"
#import "MNGlobalSharedMemeroyCache.h"
#import "UILabel+ManekiNeko.h"
#import "UIButton+ManekiNeko.h"
#import "UITextField+ManekiNeko.h"
#import "MNToastUtils.h"

@interface MNModifyNickNameViewController()

@property (nonatomic, weak)UITextField *nicknameTextField;

@end

@implementation MNModifyNickNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf0efef);
}

- (NSString *)title
{
    return @"修改昵称";
}

- (void)initSubViews
{
    @weakify(self);
    // background
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = UIColorFromRGB(0xffffff);
    backgroundView.layer.borderWidth = 0.5;
    backgroundView.layer.borderColor = UIColorFromRGB(0xb2b1b1).CGColor;
    
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(14);
        make.height.equalTo(@40);
    }];
    
    // label
    UILabel *nicknameLabel = [UILabel labelWithType:LabelTypeDefault
                                                fontSize:16 textColor:UIColorFromRGB(0x888787)];
    nicknameLabel.text = @"昵称";
    
    [backgroundView addSubview:nicknameLabel];
    
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView).with.offset(14);
        make.centerY.equalTo(backgroundView);
    }];
    
    // text field
    UITextField *nicknameTextField = [UITextField textFieldWithType:TextFieldTypeDefault];
    
    nicknameTextField.placeholder = @"请输入新的昵称";
    
    [backgroundView addSubview:nicknameTextField];
    
    [nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nicknameLabel.mas_right).with.offset(18);
        
        make.centerY.equalTo(backgroundView);
    }];
    
    self.nicknameTextField = nicknameTextField;
    
    self.nicknameTextField.text = [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] nickname];
    
    // 确定按钮
    UIButton *confirmButton = [UIButton buttonWithButtonType:ButtonTypeOrange];
    
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmButton];
    
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(14);
        make.right.equalTo(self.view).with.offset(-14);
        make.height.equalTo(@40);
        make.top.equalTo(backgroundView.mas_bottom).with.offset(28);
    }];
}

- (void)confirmButtonClicked:(UIButton *)button
{
    MNUserUpdateNicknameModel *model = [MNUserUpdateNicknameModel new];
    model.uid = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] uid];
    model.token = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] token];
    model.nickname = self.nicknameTextField.text;
    
    @weakify(self);
    [[MNHttpSessionManager manager] POST:kUserUpdateNickname parameters:[model toDictionary]
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     @strongify(self);
                                     if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
                                         [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] setNickname:self.nicknameTextField.text];
                                         [self.navigationController popViewControllerAnimated:YES];
                                     } else {
                                         [MNToastUtils showToastViewWithMessage:[responseObject objectForKey:@"info"] ForView:self.view forTimeInterval:3];
                                     }
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     
                                 }];
}

@end
