//
//  MNTaskListTableViewCell.m
//  ManekiNeko
//
//  Created by JackCheng on 15/10/20.
//  Copyright © 2015年 HardTime. All rights reserved.
//

#import "MNTaskListTableViewCell.h"
#import "Masonry.h"
#import "MNMacro.h"
#import "MNNetWorking.h"
#import "UILabel+ManekiNeko.h"
#import "UIButton+ManekiNeko.h"
#import "UIImageView+AFNetworking.h"
#import "MNConst.h"

typedef enum {
    // 当前用户状态：0未领取；1进行中；2已完成；3已放弃；
    TaskStatus_NotGet = 0,
    TaskStatus_InProcess,
    TaskStatus_Done,
    TaskStatus_Drop,
} TaskStatus;

@interface MNTaskListTableViewCell()

@property (nonatomic, weak)UIImageView *taskIconImgView;
@property (nonatomic, weak)UILabel *taskNameLabel;
@property (nonatomic, weak)UILabel *taskLeftAmountLabel;
@property (nonatomic, weak)UIButton *taskStatusButton;

@end

@implementation MNTaskListTableViewCell

@synthesize model = _model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        @weakify(self);
        
        // 任务图标
        UIImageView *taskIconImgView = [UIImageView new];
        taskIconImgView.image = [UIImage imageNamed:@"common_placeholder"];
        taskIconImgView.layer.cornerRadius = 5.0;
        
        [self.contentView addSubview:taskIconImgView];
        
        self.taskIconImgView = taskIconImgView;
        
        [self.taskIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(@13);
            make.centerY.equalTo(self.contentView);
            make.width.height.equalTo(@48);
        }];
        
        // 任务名称
        UILabel *taskNameLabel = [UILabel labelWithType:LabelTypeDefault fontSize:15 textColor:UIColorFromRGB(0x575656)];
        taskNameLabel.font = [UIFont boldSystemFontOfSize:15];
        
        [self.contentView addSubview:taskNameLabel];
        
        self.taskNameLabel = taskNameLabel;
        
        [self.taskNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(taskIconImgView.mas_right).with.offset(5);
            make.top.equalTo(taskIconImgView).with.offset(5);
        }];
        
        // 任务剩余
        UILabel *taskLeftAmountLabel = [UILabel labelWithType:LabelTypeDefault fontSize:10 textColor:UIColorFromRGB(0xa7a7a7)];
        
        [self.contentView addSubview:taskLeftAmountLabel];
        
        self.taskLeftAmountLabel = taskLeftAmountLabel;
        
        [self.taskLeftAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(taskNameLabel);
            make.bottom.equalTo(taskIconImgView).with.offset(-8);
        }];
        
        // 任务状态View
        UIButton *taskStatusButton = [UIButton buttonWithButtonType:ButtonTypeOrange];
        
        taskStatusButton.layer.cornerRadius = 3.0;
        
        [taskStatusButton addTarget:self action:@selector(taskStatusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:taskStatusButton];
        
        self.taskStatusButton = taskStatusButton;
        
        [self.taskStatusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self.contentView).with.offset(-13);
            make.top.equalTo(self.contentView).with.offset(16);
            make.bottom.equalTo(self.contentView).with.offset(-16);
            make.width.equalTo(self.contentView).multipliedBy(0.215);
        }];
        
        [self addBottomLineToCell];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAccelerometerInvoked:) name:kNotificationAccelerometerChanged object:nil];
    }
    
    return self;
}

- (void)setModel:(MNTaskListResponseModel *)model
{
    _model = model;
    
    __weak UIImageView * theImageView = self.taskIconImgView;
    
    [self.taskIconImgView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.icon]]
                                placeholderImage:[UIImage imageNamed:@"common_placeholder"]
                                         success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                             // I only attempt to apply this if an image has been returned.
                                             if (image) {
                                                 theImageView.image = image;
                                                 CALayer * layer = theImageView.layer;
                                                 layer.masksToBounds = YES;
                                                 layer.cornerRadius = 8.0f;
                                             }
                                         } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                             
                                         }];
    
    self.taskNameLabel.text = model.name;
    
    self.taskLeftAmountLabel.text = [NSString stringWithFormat:@"剩余 %@份", model.residue];
    
    [self setupTaskColorWithTaskStatus:(TaskStatus)model.userstate];
}

- (void)taskStatusButtonClicked:(UIButton *)button
{
    if (self.taskButtonClick) {
        self.taskButtonClick(self.model);
    }
}

- (void)setupTaskColorWithTaskStatus:(TaskStatus)taskStatus
{
    switch (taskStatus) {
        case TaskStatus_NotGet:
            self.taskStatusButton.backgroundColor = UIColorFromRGB(0xfb7540);
            [self.taskStatusButton setTitle:[NSString stringWithFormat:@"+%@元", _model.award] forState:UIControlStateNormal];
            break;
        case TaskStatus_InProcess:
            self.taskStatusButton.backgroundColor = UIColorFromRGB(0xffaf90);
            [self.taskStatusButton setTitle:@"进行中..." forState:UIControlStateNormal];
            break;
        case TaskStatus_Done:
            self.taskStatusButton.backgroundColor = UIColorFromRGB(0x999898);
            [self.taskStatusButton setTitle:@"已领取" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

-(void)notificationAccelerometerInvoked:(NSNotification *)notification
{
    UIAcceleration *acceleration = notification.object;
    
    [UIView animateWithDuration:1 animations:^{
        self.taskIconImgView.transform = CGAffineTransformMakeRotation(M_PI*(-acceleration.x/2));
    }];
}

@end
