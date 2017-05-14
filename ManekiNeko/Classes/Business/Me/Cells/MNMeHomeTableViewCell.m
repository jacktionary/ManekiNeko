//
//  MNMeHomeTableViewCell.m
//  ManekiNeko
//
//  Created by JackCheng on 16/3/29.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNMeHomeTableViewCell.h"
#import "MNMeHomeCellDataModel.h"
#import "UILabel+ManekiNeko.h"
#import "MNMacro.h"

@interface MNMeHomeTableViewCell()

@property (nonatomic, weak)UIImageView *cellImgView;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UILabel *indicatorLabel;

@end

@implementation MNMeHomeTableViewCell

@synthesize model = _model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        @weakify(self);
        UIImageView *cellImgView = [UIImageView new];
        
        [self.contentView addSubview:cellImgView];
        
        [cellImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.contentView).with.offset(14);
            make.centerY.equalTo(self.contentView);
            make.width.height.equalTo(@22);
        }];
        
        self.cellImgView = cellImgView;
        
        UILabel *titleLabel = [UILabel labelWithType:LabelTypeDefault fontSize:16 textColor:UIColorFromRGB(0x575656)];
        
        [self.contentView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cellImgView.mas_right).with.offset(19);
            make.centerY.equalTo(cellImgView.mas_centerY);
        }];
        
        self.titleLabel = titleLabel;
        
        UIImageView *indicatorImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_back_gray_normal"]];
        
        [self.contentView addSubview:indicatorImgView];
        
        [indicatorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self.contentView).with.offset(-14);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@10);
            make.height.equalTo(@15);
        }];
        
        UILabel *indicatorLabel = [UILabel labelWithType:LabelTypeDefault fontSize:13 textColor:UIColorFromRGB(0xB2B1B1)];
        
        [self.contentView addSubview:indicatorLabel];
        
        [indicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(indicatorImgView.mas_left).with.offset(-18);
            make.centerY.equalTo(indicatorImgView);
        }];
        
        self.indicatorLabel = indicatorLabel;
        
        [self addBottomLineToCell];
    }
    
    return self;
}

- (void)setModel:(MNMeHomeCellDataModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.title;
    self.cellImgView.image = [UIImage imageNamed:model.imgName];
    self.indicatorLabel.text = model.indicatorName;
}

@end
