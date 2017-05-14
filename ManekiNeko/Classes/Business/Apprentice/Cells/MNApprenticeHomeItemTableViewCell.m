//
//  MNApprenticeHomeItemTableViewCell.m
//  ManekiNeko
//
//  Created by JackCheng on 16/4/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNApprenticeHomeItemTableViewCell.h"
#import "UILabel+ManekiNeko.h"
#import "MNMacro.h"

@interface MNApprenticeHomeItemTableViewCell()

@property (nonatomic, weak)UIImageView *cellImgView;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UILabel *subtitleLabel;

@end

@implementation MNApprenticeHomeItemTableViewCell

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
        
        UIImageView *indicatorImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_appre_gray_indicator"]];
        
        [self.contentView addSubview:indicatorImgView];
        
        [indicatorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self.contentView).with.offset(-14);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@10);
            make.height.equalTo(@15);
        }];
        
        UILabel *subtitleLabel = [UILabel labelWithType:LabelTypeDefault fontSize:16 textColor:UIColorFromRGB(0xfb7540)];
        
        [self.contentView addSubview:subtitleLabel];
        
        [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right);
            make.centerY.equalTo(indicatorImgView);
        }];
        
        self.subtitleLabel = subtitleLabel;
        
        [self addBottomLineToCell];
    }
    
    return self;
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    
    self.titleLabel.text = [dict objectForKey:@"title"];
    self.cellImgView.image = [UIImage imageNamed:[dict objectForKey:@"img"]];
    self.subtitleLabel.text = [dict objectForKey:@"subtitle"];
}

@end
