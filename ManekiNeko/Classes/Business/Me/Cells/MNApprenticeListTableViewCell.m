//
//  MNApprenticeListTableViewCell.m
//  ManekiNeko
//
//  Created by JackCheng on 16/4/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNApprenticeListTableViewCell.h"
#import "MNApprenticeListModel.h"
#import "UILabel+ManekiNeko.h"
#import "MNMacro.h"

@interface MNApprenticeListTableViewCell()

@property (nonatomic, weak)UILabel *nickNameLabel;
@property (nonatomic, weak)UILabel *timeLabel;
@property (nonatomic, weak)UILabel *incomeLabel;

@end

@implementation MNApprenticeListTableViewCell

@synthesize model = _model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UILabel *nickNameLabel = [UILabel labelWithType:LabelTypeDefault fontSize:14 textColor:UIColorFromRGB(0x575656)];
        
        [self.contentView addSubview:nickNameLabel];
        
        [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView).multipliedBy(1.0/3.0);
        }];
        
        self.nickNameLabel = nickNameLabel;
        
        UILabel *timeLabel = [UILabel labelWithType:LabelTypeDefault fontSize:14 textColor:UIColorFromRGB(0x575656)];
        
        [self.contentView addSubview:timeLabel];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
        }];
        
        self.timeLabel = timeLabel;
        
        UILabel *incomeLabel = [UILabel labelWithType:LabelTypeDefault fontSize:14 textColor:UIColorFromRGB(0x575656)];
        
        [self.contentView addSubview:incomeLabel];
        
        [incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView).multipliedBy(5.0 / 3.0);
        }];
        
        self.incomeLabel = incomeLabel;
        
        [self addBottomLineToCell];
    }
    
    return self;
}

- (void)setModel:(MNApprenticeListModel *)model
{
    _model = model;
    
    self.nickNameLabel.text = model.nickname;
    self.timeLabel.text = model.registerdate;
    self.incomeLabel.text = [NSString stringWithFormat:@"%@元", model.rewards];
}

@end
