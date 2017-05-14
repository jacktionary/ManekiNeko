//
//  MNApprenticeHomeShareTableViewCell.m
//  ManekiNeko
//
//  Created by JackCheng on 16/4/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNApprenticeHomeShareTableViewCell.h"
#import "UILabel+ManekiNeko.h"
#import "UIButton+ManekiNeko.h"
#import "MNMacro.h"

@implementation MNApprenticeHomeShareTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        @weakify(self);
        // tips
        UILabel *tipsLabel = [UILabel labelWithType:LabelTypeDefault fontSize:10 textColor:UIColorFromRGB(0xfb7540)];
        
        tipsLabel.text = @"你会额外获得徒弟任务奖金的10%，徒弟越多，奖励金额越多";
        
        [self.contentView addSubview:tipsLabel];
        
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).with.offset(18);
        }];
        
        // share button
        UIButton *shareButton = [UIButton buttonWithButtonType:ButtonTypeOrange iconImageName:@"img_appre_share" title:@"分享好友收徒"];
        
        shareButton.tag = MNApprenticeShareCellButtonType_Share;
        
        [shareButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:shareButton];
        
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.contentView).with.offset(51);
            make.right.equalTo(self.contentView).with.offset(-51);
            make.top.equalTo(tipsLabel.mas_bottom).with.offset(15);
            make.centerX.equalTo(self.contentView);
            make.height.equalTo(@39);
        }];
        
        // scan qrcode button
        ({
            UIButton *button = [UIButton buttonWithButtonType:ButtonTypeOrange iconImageName:@"img_appre_scan_qrcode" title:@"扫一扫收徒"];
            
            [self.contentView addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.equalTo(self.contentView).with.offset(51);
                make.right.equalTo(self.contentView).with.offset(-51);
                make.top.equalTo(shareButton.mas_bottom).with.offset(14);
                make.centerX.equalTo(self.contentView);
                make.height.equalTo(@39);
            }];
            
            button.tag = MNApprenticeShareCellButtonType_Scan;
            
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        });
        
        [self addBottomLineToCell];
    }
    
    return self;
}

- (void)buttonClicked:(UIButton *)button
{
    if (self.callback) {
        self.callback((MNApprenticeShareCellButtonType)button.tag);
    }
}

@end
