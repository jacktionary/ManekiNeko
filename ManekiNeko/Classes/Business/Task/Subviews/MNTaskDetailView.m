//
//  MNTaskDetailView.m
//  ManekiNeko
//
//  Created by JackCheng on 16/3/4.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNTaskDetailView.h"
#import "Masonry.h"
#import "MNMacro.h"
#import "UILabel+ManekiNeko.h"
#import "UIButton+ManekiNeko.h"
#import "UIImageView+AFNetworking.h"
#import "MNToastUtils.h"

@interface MNTaskDetailView()

@property (nonatomic, assign)BOOL hasLoaded;

@property (nonatomic, weak)UIScrollView *scrollView;
@property (nonatomic, weak)UIView *contentView;
@property (nonatomic, weak)UIImageView *taskIconImgView;
@property (nonatomic, weak)UILabel *taskNameLabel;
@property (nonatomic, weak)UILabel *taskNameInDescriptionLabel;
@property (nonatomic, weak)UILabel *taskDurationInDescriptionLabel;
@property (nonatomic, weak)UIButton *taskStartButton;
@property (nonatomic, weak)UIButton *taskAbortButton;
@property (nonatomic, weak)UIButton *fingerPressImgView;
@property (nonatomic, weak)UILabel *keywordToBeCopyLabel;

@end

@implementation MNTaskDetailView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // case exception of load view twice
    if (!self.hasLoaded) {
        self.hasLoaded = YES;
    } else {
        return;
    }
    
    CGFloat cornerRadius = 15.0;
    
    // 设置背景颜色
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = cornerRadius;
    
    @weakify(self);
    
    // scroll view
    UIScrollView *scrollView = [UIScrollView new];
    
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.layer.cornerRadius = cornerRadius;
    scrollView.bounces = NO;
    
    [self addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self).with.offset(40);
        make.left.bottom.right.equalTo(self);
    }];
    
    // content view of scroll view, make the scroll view content size that large.
    UIView *contentView = [UIView new];
    
    contentView.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:contentView];
    
    self.contentView = contentView;
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    @weakify(contentView);
    
    // task icon imageview
    UIImageView *taskIconImgView = [UIImageView new];
    
    __weak UIImageView * theImageView = taskIconImgView;
    
    [taskIconImgView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.icon]]
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
    
    [self addSubview:taskIconImgView];
    
    self.taskIconImgView = taskIconImgView;
    
    CGFloat marginSide = 27;
    [self.taskIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).with.offset(marginSide);
        make.top.equalTo(self).with.offset(-30);
        make.width.height.equalTo(@68);
    }];
    
    // task name sitting at the left side of icon image view
    UILabel *taskNameLabel = [UILabel labelWithType:LabelTypeDefault fontSize:18 textColor:UIColorFromRGB(0x999898)];
    
    taskNameLabel.font = [UIFont boldSystemFontOfSize:18];
    
    taskNameLabel.text = [self.model name];
    
    [self addSubview:taskNameLabel];
    
    self.taskNameLabel = taskNameLabel;
    
    [self.taskNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(12);
        make.left.equalTo(self.taskIconImgView.mas_right).with.offset(11);
    }];
    
    // task description
    NSInteger taskDescriptionLabelFontSize = 15;
    UILabel *lastDescriptionLabel = nil;
    // description first line
    UILabel *taskDescriptionLabel = [UILabel labelWithType:LabelTypeDefault fontSize:taskDescriptionLabelFontSize textColor:UIColorFromRGB(0x575656)];
    taskDescriptionLabel.text = @"1.点击“复制关键字”按钮，复制并跳转；";
    taskDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    
    [contentView addSubview:taskDescriptionLabel];
    
    [taskDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(contentView);
        @strongify(self);
        make.top.equalTo(contentView).with.offset(15);
        make.left.equalTo(@(marginSide));
        make.width.equalTo(self).with.offset(- marginSide * 2);
    }];
    
    lastDescriptionLabel = taskDescriptionLabel;
    
    // description second line
    taskDescriptionLabel = [UILabel labelWithType:LabelTypeDefault fontSize:taskDescriptionLabelFontSize textColor:UIColorFromRGB(0x575656)];
    taskDescriptionLabel.text = @"2.在AppStore中，粘贴搜索；";
    taskDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    
    [contentView addSubview:taskDescriptionLabel];
    
    [taskDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(lastDescriptionLabel.mas_bottom).with.offset(12);
        make.left.equalTo(@(marginSide));
        make.width.equalTo(self).with.offset(- marginSide * 2);
    }];
    
    lastDescriptionLabel = taskDescriptionLabel;
    
    // description third line
    taskDescriptionLabel = [UILabel labelWithType:LabelTypeDefault fontSize:taskDescriptionLabelFontSize textColor:UIColorFromRGB(0x575656)];
    taskDescriptionLabel.text = [NSString stringWithFormat:@"3.找到“%@”，安装下载；", self.model.name];
    taskDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    
    [contentView addSubview:taskDescriptionLabel];
    
    [taskDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(lastDescriptionLabel.mas_bottom).with.offset(12);
        make.left.equalTo(@(marginSide));
        make.width.equalTo(self).with.offset(- marginSide * 2);
    }];
    
    lastDescriptionLabel = taskDescriptionLabel;
    
    // description forth line
    taskDescriptionLabel = [UILabel labelWithType:LabelTypeDefault fontSize:taskDescriptionLabelFontSize textColor:UIColorFromRGB(0x575656)];
    taskDescriptionLabel.text = [NSString stringWithFormat:@"4. 打开应用，前台运行，真实体验%@分钟！", self.model.condition];
    taskDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    
    [contentView addSubview:taskDescriptionLabel];
    
    [taskDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(lastDescriptionLabel.mas_bottom).with.offset(12);
        make.left.equalTo(@(marginSide));
        make.width.equalTo(self).with.offset(- marginSide * 2);
    }];
    
    lastDescriptionLabel = taskDescriptionLabel;
    
    // task start button
    UIButton *taskStartButton = [UIButton buttonWithButtonType:ButtonTypeBlue];
    
    [taskStartButton setTitle:[NSString stringWithFormat:@"复制关键字：%@", self.model.keyword] forState:UIControlStateNormal];
    [taskStartButton addTarget:self action:@selector(copyKeywordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:taskStartButton];
    
    self.taskStartButton = taskStartButton;
    
    [self.taskStartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(contentView);
        make.top.equalTo(lastDescriptionLabel.mas_bottom).with.offset(25);
        make.left.equalTo(contentView).with.offset(22);
        make.right.equalTo(contentView).with.offset(-22);
        make.height.equalTo(@44);
    }];
    
    // task confirm
    UIButton *taskConfirmButton = [UIButton buttonWithButtonType:ButtonTypeOrange];
    
    [taskConfirmButton setTitle:@"完成后点此提交" forState:UIControlStateNormal];
    [taskConfirmButton addTarget:self action:@selector(taskConfirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:taskConfirmButton];
    
    self.taskAbortButton = taskConfirmButton;
    
    [self.taskAbortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(contentView);
        make.top.equalTo(taskStartButton.mas_bottom).with.offset(15);
        make.left.equalTo(contentView).with.offset(22);
        make.right.equalTo(contentView).with.offset(-22);
        make.height.equalTo(@44);
    }];
    
    // task abort
    UIButton *taskAbortButton = [UIButton buttonWithButtonType:ButtonTypeGray];
    
    [taskAbortButton setTitle:@"放弃（留给其他人）" forState:UIControlStateNormal];
    [taskAbortButton addTarget:self action:@selector(taskAbortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:taskAbortButton];
    
    [taskAbortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(contentView);
        make.top.equalTo(taskConfirmButton.mas_bottom).with.offset(15);
        make.left.equalTo(contentView).with.offset(22);
        make.right.equalTo(contentView).with.offset(-22);
        make.height.equalTo(@44);
    }];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(taskAbortButton).with.offset(18);
    }];
}

- (void)taskConfirmButtonClicked:(UIButton *)button
{
    if (self.viewCloseCallback) {
        self.viewCloseCallback(MNTaskDetailViewCallbackType_Commit, self.model);
    }
}

- (void)taskAbortButtonClicked:(UIButton *)button
{
    if (self.viewCloseCallback) {
        self.viewCloseCallback(MNTaskDetailViewCallbackType_Aboart, self.model);
    }
}

- (void)copyKeywordButtonClicked:(UIButton *)button
{
    UIPasteboard *pastBoard = [UIPasteboard generalPasteboard];
    
    [pastBoard setString:self.model.keyword];
    
    [MNToastUtils showToastViewWithMessage:@"已复制，即将跳转。" ForView:self forTimeInterval:2 completionBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?media=software&term="]];
        });
    }];
}

@end
