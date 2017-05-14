//
//  MNLoadMoreFooterTableViewCell.m
//  ManekiNeko
//
//  Created by JackCheng on 16/3/3.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNLoadMoreFooterTableViewCell.h"
#import "MNMacro.h"
#import "Masonry.h"
#import "UILabel+ManekiNeko.h"

@interface MNLoadMoreFooterTableViewCell()

@property (nonatomic, weak)UIActivityIndicatorView *loadingView;

@end

@implementation MNLoadMoreFooterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        __weak MNLoadMoreFooterTableViewCell *weakself = self;
        // 按钮
        UIView *buttonView = [UIView new];
        buttonView.backgroundColor = UIColorFromRGB(0xf9f9f9);
        buttonView.layer.cornerRadius = 3.0;
        buttonView.layer.borderWidth = 0.5;
        buttonView.layer.borderColor = UIColorFromRGB(0xd3d3d3).CGColor;
        
        [self.contentView addSubview:buttonView];
        
        [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself.contentView).with.offset(20);
            make.top.equalTo(weakself.contentView).with.offset(10);
            make.right.equalTo(weakself.contentView).with.offset(-20);
            make.bottom.equalTo(weakself.contentView).with.offset(-10);
        }];
        
        // 正在加载
        UILabel *loadingLabel = [UILabel labelWithType:LabelTypeDefault fontSize:15 textColor:UIColorFromRGB(0x999898)];
        
        loadingLabel.text = @"正在加载...";
        
        [buttonView addSubview:loadingLabel];
        
        [loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(buttonView);
        }];
        
        // loading
        UIActivityIndicatorView *loadingActIndView = [UIActivityIndicatorView new];
        loadingActIndView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        loadingActIndView.backgroundColor = [UIColor clearColor];
        
        [buttonView addSubview:loadingActIndView];
        
        [loadingActIndView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(loadingLabel);
            make.right.equalTo(loadingLabel.mas_left).with.offset(-5);
        }];
        
        self.loadingView = loadingActIndView;
        
        [self addBottomLineToCell];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (![self.loadingView isAnimating]) {
        [self.loadingView startAnimating];
    }
}

@end
