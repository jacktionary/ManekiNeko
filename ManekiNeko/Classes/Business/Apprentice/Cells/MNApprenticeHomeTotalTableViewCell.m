//
//  MNApprenticeHomeTotalTableViewCell.m
//  ManekiNeko
//
//  Created by JackCheng on 16/4/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNApprenticeHomeTotalTableViewCell.h"
#import "UILabel+ManekiNeko.h"
#import "MNMacro.h"

@interface MNApprenticeHomeTotalTableViewCell()

@property (nonatomic, weak)UIImageView *cellImgView;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UILabel *numberLabel;
@property (nonatomic, weak)UILabel *unitLabel;

@end

@implementation MNApprenticeHomeTotalTableViewCell

@synthesize dict = _dict;

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
        
        UILabel *unitLabel = [UILabel labelWithType:LabelTypeDefault fontSize:16 textColor:UIColorFromRGB(0x808080)];
        
        [self.contentView addSubview:unitLabel];
        
        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-14);
            make.centerY.equalTo(titleLabel);
        }];
        
        self.unitLabel = unitLabel;
        
        UILabel *numberLabel = [UILabel labelWithType:LabelTypeDefault fontSize:24 textColor:UIColorFromRGB(0xfb7540)];
        
        [self.contentView addSubview:numberLabel];
        
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(unitLabel.mas_left).with.offset(-18);
            make.centerY.equalTo(unitLabel);
        }];
        
        self.numberLabel = numberLabel;
        
        [self addBottomLineToCell];
    }
    
    return self;
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    
    self.titleLabel.text = [dict objectForKey:@"title"];
    self.cellImgView.image = [UIImage imageNamed:[dict objectForKey:@"img"]];
    self.numberLabel.text = [dict objectForKey:@"num"];
    self.unitLabel.text = [dict objectForKey:@"unit"];
}

@end
