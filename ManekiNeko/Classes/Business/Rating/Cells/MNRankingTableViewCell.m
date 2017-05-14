//
//  MNRatingTableViewCell.m
//  ManekiNeko
//
//  Created by JackCheng on 16/3/15.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNRankingTableViewCell.h"
#import "MNRankingNumberView.h"
#import "UILabel+ManekiNeko.h"
#import "MNGlobalSharedMemeroyCache.h"

@interface MNRankingTableViewCell()

@property (nonatomic, weak)MNRankingNumberView *rankingNumberView;
@property (nonatomic, weak)UILabel *incomeDescriptionLabel;
@property (nonatomic, weak)UILabel *incomeLabel;
@property (nonatomic, weak)UILabel *yuanLabel;
@property (nonatomic, weak)UILabel *nicknameLabel;

@end

@implementation MNRankingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        @weakify(self);
        
        // 名次
        MNRankingNumberView *rankingNumberView = [MNRankingNumberView new];
        
        [self.contentView addSubview:rankingNumberView];
        
        [rankingNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.contentView).with.offset(20);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        
        self.rankingNumberView = rankingNumberView;
        
        // 总收入label
        UILabel *incomeDescriptionLabel = [UILabel labelWithType:LabelTypeDefault fontSize:14 textColor:UIColorFromRGB(0x575656)];
        
        [self.contentView addSubview:incomeDescriptionLabel];
        
        [incomeDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@70);
            make.centerY.equalTo(self.contentView);
        }];
        
        self.incomeDescriptionLabel = incomeDescriptionLabel;
        
        // 总收入金额label
        UILabel *incomeLabel = [UILabel labelWithType:LabelTypeDefault fontSize:14 textColor:UIColorFromRGB(0x575656)];
        
        [self.contentView addSubview:incomeLabel];
        
        [incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(incomeDescriptionLabel.mas_right);
            make.centerY.equalTo(self.contentView);
        }];
        self.incomeLabel = incomeLabel;
        
        // 总收入元label
        UILabel *yuanLabel = [UILabel labelWithType:LabelTypeDefault fontSize:14 textColor:UIColorFromRGB(0x575656)];
        
        [self.contentView addSubview:yuanLabel];
        
        [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(incomeLabel.mas_right);
            make.centerY.equalTo(self.contentView);
        }];
        
        self.yuanLabel = yuanLabel;
        
        // 昵称label
        UILabel *nicknameLabel = [UILabel labelWithType:LabelTypeDefault fontSize:14 textColor:UIColorFromRGB(0x575656)];
        
        [self.contentView addSubview:nicknameLabel];
        
        [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_right).multipliedBy(0.7);
            make.centerY.equalTo(self.contentView);
        }];
        
        self.nicknameLabel = nicknameLabel;
        
        [self addBottomLineToCell];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.rankingNumberView.rankingNum = self.rankingNum;
    [self.rankingNumberView setNeedsLayout];
    
    if ([self.model isKindOfClass:[MNUserRankingApprenticeModel class]]) {
        self.incomeDescriptionLabel.text = @"徒弟数：";
        self.incomeLabel.text = [(MNUserRankingApprenticeModel *)self.model disciplecount];
        
        self.nicknameLabel.text = [(MNUserRankingApprenticeModel *)self.model nickname];
        self.yuanLabel.text = @"人";
        
    } else if ([self.model isKindOfClass:[MNUserRankingIncomeModel class]]) {
        self.incomeDescriptionLabel.text = @"总收入：￥";
        self.incomeLabel.text = [(MNUserRankingIncomeModel *)self.model income];
        
        self.nicknameLabel.text = [(MNUserRankingIncomeModel *)self.model nickname];
        self.yuanLabel.text = @"元";
    }
    
    if ([[(MNUserRankingIncomeModel *)self.model uid] isEqualToString:[[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] uid]]) {
        self.incomeDescriptionLabel.textColor = UIColorFromRGB(0xfb7540);
        self.incomeLabel.textColor = UIColorFromRGB(0xfb7540);
        self.yuanLabel.textColor = UIColorFromRGB(0xfb7540);
        self.nicknameLabel.textColor = UIColorFromRGB(0xfb7540);
    } else {
        self.incomeDescriptionLabel.textColor = UIColorFromRGB(0x575656);
        self.incomeLabel.textColor = UIColorFromRGB(0x575656);
        self.yuanLabel.textColor = UIColorFromRGB(0x575656);
        self.nicknameLabel.textColor = UIColorFromRGB(0x575656);
    }
}

@end
