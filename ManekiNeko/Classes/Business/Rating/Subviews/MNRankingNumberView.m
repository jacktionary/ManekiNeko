//
//  MNRankingNumberView.m
//  ManekiNeko
//
//  Created by JackCheng on 16/3/16.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNRankingNumberView.h"

@implementation MNRankingNumberView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *imgContentView = [UIView new];
    [self addSubview:imgContentView];
    
    NSArray *arrayOfImgNames = [self arrayOfImgNamesForNum:self.rankingNum];
    
    UIView *firstImgView = nil;
    UIView *lastImgView = nil;
    for (NSString *imgName in arrayOfImgNames) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        
        [imgContentView addSubview:imgView];
        
        if (!lastImgView) {
            @weakify(imgContentView);
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(imgContentView);
                make.left.equalTo(imgContentView);
                make.centerY.equalTo(imgContentView);
            }];
            
            firstImgView = imgView;
        } else {
            @weakify(lastImgView);
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(lastImgView);
                make.left.equalTo(lastImgView.mas_right);
                make.centerY.equalTo(lastImgView);
            }];
        }
        
        lastImgView = imgView;
    }
    
    @weakify(self);
    [imgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
}

- (NSArray *)arrayOfImgNamesForNum:(NSInteger)num
{
    NSMutableArray *arrayOfImgNames = [NSMutableArray array];
    
    BOOL isLargerOrGraterThanTen = (num >= 10);
    
    NSString *imgName = nil;
    
    if (isLargerOrGraterThanTen) {
        do {
            imgName = [self numberImageViewForNum:num % 10];
            
            [arrayOfImgNames insertObject:imgName atIndex:0];
        } while ((num /= 10) > 0);
    } else {
        imgName = [self numberImageViewForNumWithinTen:num];
        [arrayOfImgNames addObject:imgName];
    }
    
    return arrayOfImgNames;
}

- (NSString *)numberImageViewForNum:(NSInteger)num
{
    NSString *imgName = nil;
    
    switch (num) {
        case 0:
            imgName = @"img_ranking_num_0";
            break;
        case 1:
            imgName = @"img_ranking_num_1";
            break;
        case 2:
            imgName = @"img_ranking_num_2";
            break;
        case 3:
            imgName = @"img_ranking_num_3";
            break;
        case 4:
            imgName = @"img_ranking_num_4";
            break;
        case 5:
            imgName = @"img_ranking_num_5";
            break;
        case 6:
            imgName = @"img_ranking_num_6";
            break;
        case 7:
            imgName = @"img_ranking_num_7";
            break;
        case 8:
            imgName = @"img_ranking_num_8";
            break;
        case 9:
            imgName = @"img_ranking_num_9";
            break;
        default:
            break;
    }
    
    return imgName;
}

- (NSString *)numberImageViewForNumWithinTen:(NSInteger)num
{
    NSString *imgName = nil;
    
    switch (num) {
        case 0:
            imgName = @"img_ranking_num_0";
            break;
        case 1:
            imgName = @"img_ranking_num_top_1";
            break;
        case 2:
            imgName = @"img_ranking_num_top_2";
            break;
        case 3:
            imgName = @"img_ranking_num_top_3";
            break;
        case 4:
            imgName = @"img_ranking_num_4";
            break;
        case 5:
            imgName = @"img_ranking_num_5";
            break;
        case 6:
            imgName = @"img_ranking_num_6";
            break;
        case 7:
            imgName = @"img_ranking_num_7";
            break;
        case 8:
            imgName = @"img_ranking_num_8";
            break;
        case 9:
            imgName = @"img_ranking_num_9";
            break;
        default:
            break;
    }
    
    return imgName;
}

@end
