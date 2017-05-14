//
//  MNCashingRecordTableViewCell.m
//  ManekiNeko
//
//  Created by JackCheng on 16/3/30.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNCashingRecordTableViewCell.h"
#import "MNUserExpendRecordModel.h"
#import "UILabel+ManekiNeko.h"
#import "MNMacro.h"

typedef enum {
    MNUserExpendRecordState_Processing = 0,
    MNUserExpendRecordState_Done,
    MNUserExpendRecordState_Failure,
} MNUserExpendRecordState;

@interface MNCashingRecordTableViewCell()

@property (nonatomic, weak)UILabel *cashingTimeLabel;
@property (nonatomic, weak)UILabel *cashingTypeLabel;
@property (nonatomic, weak)UILabel *cashingNumLabel;
@property (nonatomic, weak)UILabel *stateLabel;

@end

@implementation MNCashingRecordTableViewCell

@synthesize model = _model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UILabel *cashingTimeLabel = [UILabel labelWithType:LabelTypeDefault fontSize:14 textColor:UIColorFromRGB(0x808080)];
        
        [self.contentView addSubview:cashingTimeLabel];
        
        [cashingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView).multipliedBy(1.0/4.0);
        }];
        
        self.cashingTimeLabel = cashingTimeLabel;
        
        UILabel *cashingTypeLabel = [UILabel labelWithType:LabelTypeDefault fontSize:14 textColor:UIColorFromRGB(0x808080)];
        
        [self.contentView addSubview:cashingTypeLabel];
        
        [cashingTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView).multipliedBy(3.0/4.0);
        }];
        
        self.cashingTypeLabel = cashingTypeLabel;
        
        UILabel *cashingNumLabel = [UILabel labelWithType:LabelTypeDefault fontSize:14 textColor:UIColorFromRGB(0x808080)];
        
        [self.contentView addSubview:cashingNumLabel];
        
        [cashingNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView).multipliedBy(5.0/4.0);
        }];
        
        self.cashingNumLabel = cashingNumLabel;
        
        UILabel *stateLabel = [UILabel labelWithType:LabelTypeDefault fontSize:14 textColor:UIColorFromRGB(0x808080)];
        
        [self.contentView addSubview:stateLabel];
        
        [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView).multipliedBy(7.0/4.0);
        }];
        
        self.stateLabel = stateLabel;
        
        [self addBottomLineToCell];
    }
    
    return self;
}

- (void)setModel:(MNUserExpendRecordModel *)model
{
    _model = model;
    
    self.cashingTimeLabel.text = model.updatedate;
    self.cashingTypeLabel.text = model.paytypename;
    self.cashingNumLabel.text = [NSString stringWithFormat:@"%@元", model.expend];
    self.stateLabel.text = model.statename;
    
    if ([model.state integerValue] == MNUserExpendRecordState_Processing) {
        self.stateLabel.textColor = UIColorFromRGB(0xfb7540);
    } else {
        self.stateLabel.textColor = UIColorFromRGB(0x808080);
    }
}

@end
