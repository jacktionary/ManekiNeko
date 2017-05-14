//
//  MNUserGotRedpackView.m
//  ManekiNeko
//
//  Created by JackCheng on 16/3/1.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNUserGotRedpackView.h"
#import "Masonry.h"
#import "MNMacro.h"

#import "UILabel+ManekiNeko.h"
#import "UIButton+ManekiNeko.h"

@interface MNUserGotRedpackView()

@property (nonatomic, assign)BOOL hasLoaded;

@end

@implementation MNUserGotRedpackView

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
    UIImageView *redpackImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_task_got_redpack"]];
    
    [self addSubview:redpackImgV];
    
    [redpackImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself);
        make.top.equalTo(weakself).with.offset(30);
    }];
    
    // 红包view
    UIView *redpackView = [UIView new];
    
    [self addSubview:redpackView];
    
    [redpackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself);
        make.top.equalTo(redpackImgV.mas_bottom).with.offset(10);
        
        make.height.equalTo(@26);
    }];
    
    __weak UIView *weakRedPackView = redpackView;
    
    // 红包label
    UILabel *redpackLabel = [UILabel labelWithType:LabelTypeDefault fontSize:32/2 textColor:UIColorFromRGB(0x999898)];
    
    redpackLabel.text = @"恭喜！获得现金";
    
    redpackLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [redpackView addSubview:redpackLabel];
    
    [redpackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakRedPackView);
        make.top.equalTo(weakRedPackView);
    }];
    
    // xx元
    UILabel *packAmountLabel = [UILabel labelWithType:LabelTypeDefault fontSize:32/2 textColor:UIColorFromRGB(0xfb7540)];
    
    packAmountLabel.text = self.redpackAmount;
    
    packAmountLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [redpackView addSubview:packAmountLabel];
    
    [packAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(redpackLabel);
        make.left.equalTo(redpackLabel.mas_right);
    }];
    
    // 元label
    UILabel *yuanLabel = [UILabel labelWithType:LabelTypeDefault fontSize:32 / 2 textColor:UIColorFromRGB(0x999898)];
    
    yuanLabel.text = @"元";
    
    yuanLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [redpackView addSubview:yuanLabel];
    
    [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(redpackLabel);
        make.left.equalTo(packAmountLabel.mas_right);
        make.right.equalTo(redpackView.mas_right);
    }];
    
    NSInteger itemHeight = 39;
    
    // 现在赚钱 button
    UIButton *makeMoneyButton = [UIButton buttonWithButtonType:ButtonTypeOrange];
    
    [makeMoneyButton setTitle:@"现在赚钱" forState:UIControlStateNormal];
    
    [makeMoneyButton addTarget:self action:@selector(makeMoneyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:makeMoneyButton];
    
    [makeMoneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakself).with.insets(UIEdgeInsetsMake(0, 20, 0, 20));
        make.top.equalTo(redpackView.mas_bottom).with.offset(15);
        make.height.equalTo(@(itemHeight));
    }];
}

- (void)makeMoneyButtonClicked:(UIButton *)button
{
    if (self.confirmRedPackCallBack) {
        self.confirmRedPackCallBack();
    }
}

@end
