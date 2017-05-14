//
//  MNUserRedpackView.m
//  ManekiNeko
//
//  Created by JackCheng on 16/2/24.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNUserRedpackView.h"
#import "Masonry.h"
#import "MNMacro.h"

#import "UILabel+ManekiNeko.h"
#import "UITextField+ManekiNeko.h"
#import "UIButton+ManekiNeko.h"

#import "MNNetWorking.h"

@interface MNUserRedpackView()

@property (nonatomic, weak)UITextField *textField;
@property (nonatomic, assign)BOOL hasLoaded;

@end

@implementation MNUserRedpackView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.hasLoaded) {
        self.hasLoaded = YES;
    } else {
        return;
    }
    
    // 设置背景颜色
    self.backgroundColor = [UIColor whiteColor];
    
    // 设置view圆角
    self.layer.cornerRadius = 5;
    
    // weak对象声明
    __weak MNBaseView *weakself = self;
    
    // 红包img
    UIImageView *redpackImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_task_redpack"]];
    
    [self addSubview:redpackImgV];
    
    [redpackImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself);
        make.top.equalTo(weakself).with.offset(15);
    }];
    
    // 红包label
    UILabel *redpackLabel = [UILabel labelWithType:LabelTypeDefault fontSize:32/2 textColor:UIColorFromRGB(0xfb7540)];
    
    redpackLabel.text = @"新来的，送你一个红包!";
    
    redpackLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [self addSubview:redpackLabel];
    
    [redpackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself);
        make.top.equalTo(redpackImgV.mas_bottom).with.offset(10);
    }];
    
    NSInteger itemHeight = 39;
    
    // 邀请者textfield
    UITextField *inviterTextField = [UITextField textFieldWithType:TextFieldTypeGrayBorder];
    
    inviterTextField.placeholder = @"输入邀请者ID(送4元)";
    
    [self addSubview:inviterTextField];
    
    [inviterTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself).with.offset(20);
        make.top.equalTo(redpackLabel.mas_bottom).with.offset(20);
        make.height.equalTo(@(itemHeight));
    }];
    
    self.textField = inviterTextField;
    
    // 确定button
    UIButton *confirmButton = [UIButton buttonWithButtonType:ButtonTypeOrange];
    
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    
    [confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:confirmButton];
    
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inviterTextField.mas_right).with.offset(3);
        make.height.equalTo(@(itemHeight));
        make.centerY.equalTo(inviterTextField);
        make.right.equalTo(weakself).with.offset(-20);

        make.width.equalTo(inviterTextField.mas_width).with.multipliedBy(0.5);
    }];
    
    // 无邀请ID button
    UIButton *noInviterButton = [UIButton buttonWithButtonType:ButtonTypeOrange];
    
    [noInviterButton setTitle:@"无邀请ID(送2元)" forState:UIControlStateNormal];
    
    [noInviterButton addTarget:self action:@selector(noInviterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:noInviterButton];
    
    [noInviterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakself).with.insets(UIEdgeInsetsMake(0, 20, 0, 20));
        make.top.equalTo(inviterTextField.mas_bottom).with.offset(10);
        make.height.equalTo(@(itemHeight));
    }];
}

- (void)confirmButtonClicked:(UIButton *)sender
{
    if (self.confirmRedPackCallBack) {
        self.confirmRedPackCallBack(self.textField.text, @"4.00");
    }
}

- (void)noInviterButtonClicked:(UIButton *)sender
{
    if (self.confirmRedPackCallBack) {
        self.confirmRedPackCallBack(@"", @"2.00");
    }
}

@end
