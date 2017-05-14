//
//  MNBaseTableViewCell.m
//  ManekiNeko
//
//  Created by JackCheng on 15/10/20.
//  Copyright © 2015年 HardTime. All rights reserved.
//

#import "MNBaseTableViewCell.h"

@implementation MNBaseTableViewCell

- (void)addTopLineToCell
{
    @weakify(self);
    // 底线
    UIView *bottomGrayView = [UIView new];
    
    bottomGrayView.backgroundColor = UIColorFromRGB(0xa7a7a7);
    
    [self.contentView addSubview:bottomGrayView];
    
    [bottomGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentView.mas_top).with.offset(0.5);
        make.width.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

- (void)addBottomLineToCell
{
    @weakify(self);
    // 底线
    UIView *bottomGrayView = [UIView new];
    
    bottomGrayView.backgroundColor = UIColorFromRGB(0xa7a7a7);
    
    [self.contentView addSubview:bottomGrayView];
    
    [bottomGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-0.5);
        make.width.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

@end
