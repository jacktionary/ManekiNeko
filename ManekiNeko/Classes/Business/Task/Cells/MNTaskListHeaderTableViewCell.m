//
//  MNTaskListHeaderTableViewCell.m
//  ManekiNeko
//
//  Created by JackCheng on 15/10/20.
//  Copyright © 2015年 HardTime. All rights reserved.
//

#import "MNTaskListHeaderTableViewCell.h"
#import "Masonry.h"
#import "MNMacro.h"

#import "UILabel+ManekiNeko.h"

@interface MNTaskListHeaderTableViewCell()

@end

@implementation MNTaskListHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        __weak MNTaskListHeaderTableViewCell *weakself = self;
        // 今日收入视图
        UIView *incomeView = [UIView new];
        
        incomeView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:incomeView];
        
        [incomeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakself.contentView).multipliedBy(0.5);
            make.height.equalTo(weakself.contentView);
            make.width.lessThanOrEqualTo(weakself.contentView).multipliedBy(0.5);
        }];
        
        // 今日收入label
        UILabel *incomeLeftLabel = [UILabel labelWithType:LabelTypeDefault fontSize:15 textColor:UIColorFromRGB(0x808080)];
        incomeLeftLabel.text = @"今日收入";
        
        [incomeView addSubview:incomeLeftLabel];
        
        [incomeLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(incomeView);
            make.centerY.equalTo(incomeView);
        }];
        
        // 金额label
        UILabel *incomeLabel = [UILabel labelWithType:LabelTypeDefault fontSize:23 textColor:UIColorFromRGB(0xfb7540)];
        
        incomeLabel.text = @"****";
        
        [incomeView addSubview:incomeLabel];
        self.incomeLabel = incomeLabel;
        
        [incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(incomeLeftLabel.mas_right);
            make.baseline.equalTo(incomeLeftLabel);
        }];
        
        // 元label
        UILabel *incomeRightLabel = [UILabel labelWithType:LabelTypeDefault fontSize:15 textColor:UIColorFromRGB(0x808080)];
        
        incomeRightLabel.text = @"元";
        
        [incomeView addSubview:incomeRightLabel];
        [incomeRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(incomeView);
            make.left.equalTo(incomeLabel.mas_right);
            make.baseline.equalTo(incomeLeftLabel);
        }];
        
        // 今日收徒视图
        UIView *masterApprenticeView = [UIView new];
        
        masterApprenticeView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:masterApprenticeView];
        
        [masterApprenticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakself.contentView).multipliedBy(1.5);
            make.height.equalTo(weakself.contentView);
        }];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(masterApprenticeViewTapped:)];
        
        [masterApprenticeView addGestureRecognizer:gesture];
        
        // 今日收徒label
        UILabel *maLeftLabel = [UILabel labelWithType:LabelTypeDefault fontSize:15 textColor:UIColorFromRGB(0x808080)];
        maLeftLabel.text = @"收徒";
        
        [masterApprenticeView addSubview:maLeftLabel];
        
        [maLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(masterApprenticeView);
            make.centerY.equalTo(masterApprenticeView);
        }];
        
        // 人数label
        UILabel *maLabel = [UILabel labelWithType:LabelTypeDefault fontSize:23 textColor:UIColorFromRGB(0xfb7540)];
        
        maLabel.text = @"****";
        
        [masterApprenticeView addSubview:maLabel];
        self.apprenticeLabel = maLabel;
        
        [maLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(maLeftLabel.mas_right);
            make.baseline.equalTo(maLeftLabel);
        }];
        
        // 个label
        UILabel *maRightLabel = [UILabel labelWithType:LabelTypeDefault fontSize:15 textColor:UIColorFromRGB(0x808080)];
        
        maRightLabel.text = @"个";
        
        [masterApprenticeView addSubview:maRightLabel];
        [maRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(masterApprenticeView);
            make.left.equalTo(maLabel.mas_right);
            make.baseline.equalTo(maLeftLabel);
        }];
        
        // 中线
        UIView *middleGrayView = [UIView new];
        
        middleGrayView.backgroundColor = UIColorFromRGB(0xa7a7a7);
        
        [self.contentView addSubview:middleGrayView];
        
        [middleGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakself.contentView);
            make.height.equalTo(weakself.contentView.mas_height);
            make.width.equalTo(@0.5);
        }];
        
        [self addBottomLineToCell];
    }
    
    return self;
}

- (void)masterApprenticeViewTapped:(UIGestureRecognizer *)gesture
{
    if (self.callback) {
        self.callback();
    }
}

@end
