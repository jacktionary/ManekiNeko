//
//  MNUserTaskRecordTableViewCell.m
//  ManekiNeko
//
//  Created by JackCheng on 16/3/30.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNUserTaskRecordTableViewCell.h"
#import "MNUserTaskRecordModel.h"
#import "UILabel+ManekiNeko.h"
#import "MNMacro.h"

@interface MNUserTaskRecordTableViewCell()

@property (nonatomic, weak)UILabel *taskNameLabel;
@property (nonatomic, weak)UILabel *taskCompleteLabel;
@property (nonatomic, weak)UILabel *taskIncomeLabel;

@end

@implementation MNUserTaskRecordTableViewCell

@synthesize model = _model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UILabel *taskNameLabel = [UILabel labelWithType:LabelTypeDefault fontSize:14 textColor:UIColorFromRGB(0x575656)];
        
        [self.contentView addSubview:taskNameLabel];
        
        [taskNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView).multipliedBy(1.0/3.0);
        }];
        
        self.taskNameLabel = taskNameLabel;
        
        UILabel *taskCompleteLabel = [UILabel labelWithType:LabelTypeDefault fontSize:14 textColor:UIColorFromRGB(0x575656)];
        
        [self.contentView addSubview:taskCompleteLabel];
        
        [taskCompleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
        }];
        
        self.taskCompleteLabel = taskCompleteLabel;
        
        UILabel *taskIncomeLabel = [UILabel labelWithType:LabelTypeDefault fontSize:14 textColor:UIColorFromRGB(0x575656)];
        
        [self.contentView addSubview:taskIncomeLabel];
        
        [taskIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView).multipliedBy(5.0 / 3.0);
        }];
        
        self.taskIncomeLabel = taskIncomeLabel;
        
        [self addBottomLineToCell];
    }
    
    return self;
}

- (void)setModel:(MNUserTaskRecordModel *)model
{
    _model = model;
    
    self.taskNameLabel.text = model.tname;
    self.taskCompleteLabel.text = model.updatedate;
    self.taskIncomeLabel.text = [NSString stringWithFormat:@"%@元", model.income];
}

@end
