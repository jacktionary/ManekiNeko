//
//  MNScoreSheetViewController.m
//  ManekiNeko
//
//  Created by JackCheng on 16/4/13.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNScoreSheetViewController.h"
#import "Masonry.h"
#import "MNNetWorking.h"
#import "UILabel+ManekiNeko.h"
#import "UIButton+ManekiNeko.h"
#import "UIView+MNSnapShot.h"
#import "MNMacro.h"
#import "MNGlobalSharedMemeroyCache.h"
#import "WXApi.h"
#import "MNToastUtils.h"
#import "MNUserIdAndTokenModel.h"

@interface MNScoreSheetViewController()

@property (nonatomic, weak)UIScrollView *scrollView;
@property (nonatomic, weak)UIView *contentView;
@property (nonatomic, weak)UILabel *usageDaysLabel;
@property (nonatomic, weak)UILabel *taskAmountLabel;
@property (nonatomic, weak)UILabel *incomeRankingLabel;
@property (nonatomic, weak)UILabel *totalIncomeLabel;

@end

@implementation MNScoreSheetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSString *)title
{
    return @"成绩单";
}

- (void)initSubViews
{
    @weakify(self);
    // the whole page is a scroll view
    UIScrollView *scrollView = [UIScrollView new];
    
    scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view);
        make.left.bottom.right.equalTo(self.view);
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
    
    // top area is with the orange color for the background color
    UIView *topAreaView = [UIView new];
    
    topAreaView.backgroundColor = UIColorFromRGB(0xFB7540);
    
    [self.contentView addSubview:topAreaView];
    
    [topAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.contentView);
    }];
    
    UIView *lastObjInTopArea = nil;
    
    // maneki icon
    UIImageView *makekiImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_placeholder"]];
    
    makekiImgView.layer.cornerRadius = 50.0;
    makekiImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    makekiImgView.layer.borderWidth = 2.0;
    makekiImgView.clipsToBounds = YES;
    
    [topAreaView addSubview:makekiImgView];
    
    [makekiImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topAreaView);
        make.top.equalTo(topAreaView).with.offset(9);
        make.width.height.equalTo(@100);
    }];
    
    lastObjInTopArea = makekiImgView;
    
    // UID
    UILabel *uidLabel = [UILabel labelWithType:LabelTypeDefault fontSize:10 textColor:[UIColor whiteColor]];
    
    uidLabel.text = [NSString stringWithFormat:@"UID：%@", [[[MNGlobalSharedMemeroyCache sharedInstance] userInfoModel] uid]];
    
    [topAreaView addSubview:uidLabel];
    
    [uidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastObjInTopArea.mas_bottom).with.offset(9);
        make.centerX.equalTo(lastObjInTopArea);
    }];
    
    lastObjInTopArea = uidLabel;
    
    // 累计收入label
    UILabel *incomeDisplayLabel = [UILabel labelWithType:LabelTypeDefault fontSize:17 textColor:[UIColor whiteColor]];
    
    incomeDisplayLabel.text = @"累计收入";
    
    [topAreaView addSubview:incomeDisplayLabel];
    
    [incomeDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastObjInTopArea.mas_bottom).with.offset(18);
        make.centerX.equalTo(lastObjInTopArea);
    }];
    
    lastObjInTopArea = incomeDisplayLabel;
    
    // 累计收入line
    UIView *incomeDisplayLine = [UIView new];
    incomeDisplayLine.backgroundColor = [UIColor whiteColor];
    
    [topAreaView addSubview:incomeDisplayLine];
    
    [incomeDisplayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastObjInTopArea.mas_bottom).with.offset(11);
        make.centerX.equalTo(lastObjInTopArea);
        make.height.equalTo(@0.5);
        make.width.equalTo(topAreaView).multipliedBy(0.33);
    }];
    
    lastObjInTopArea = incomeDisplayLine;
    
    // 累计收入金额
    UILabel *incomeLabel = [UILabel labelWithType:LabelTypeDefault fontSize:55 textColor:[UIColor whiteColor]];
    
    incomeLabel.text = @"****";
    
    [topAreaView addSubview:incomeLabel];
    
    self.totalIncomeLabel = incomeLabel;
    
    [incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastObjInTopArea.mas_bottom).with.offset(9);
        make.centerX.equalTo(lastObjInTopArea);
    }];
    
    lastObjInTopArea = incomeLabel;
    
    UILabel *yuanLabel = [UILabel new];
    
    yuanLabel.text = @"元";
    yuanLabel.textColor = [UIColor whiteColor];
    yuanLabel.font = [UIFont systemFontOfSize:17];
    
    [topAreaView addSubview:yuanLabel];
    
    [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastObjInTopArea.mas_right);
        make.baseline.equalTo(lastObjInTopArea);
    }];
    
    // update top area view bottom constraint
    [topAreaView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastObjInTopArea.mas_bottom).with.offset(16);
    }];
    
    lastObjInTopArea = yuanLabel;
    
    // and the middle one allocating info of such as days of useage, ranking, task number accomplished.
    UIView *infopadView = [UIView new];
    
    infopadView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:infopadView];
    
    [infopadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topAreaView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@60);
    }];
    
    lastObjInTopArea = infopadView;
    
    // seperator lines
    ({
        UIView *lineView = [UIView new];
        lineView.backgroundColor = UIColorFromRGB(0x999898);
        
        [infopadView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0.5);
            make.height.equalTo(lastObjInTopArea.mas_height).with.offset(-10);
            make.centerY.equalTo(lastObjInTopArea);
            make.left.equalTo(lastObjInTopArea).with.offset(CGRectGetWidth(self.view.frame) * 0.33);
        }];
    });
    
    ({
        UIView *lineView = [UIView new];
        lineView.backgroundColor = UIColorFromRGB(0x999898);
        
        [infopadView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0.5);
            make.height.equalTo(lastObjInTopArea.mas_height).with.offset(-10);
            make.centerY.equalTo(lastObjInTopArea);
            make.left.equalTo(lastObjInTopArea).with.offset(CGRectGetWidth(self.view.frame) * 0.67);
        }];
    });
    
    ({
        UIView *lineView = [UIView new];
        lineView.backgroundColor = UIColorFromRGB(0x999898);
        
        [infopadView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.width.equalTo(lastObjInTopArea.mas_width);
            make.left.right.bottom.equalTo(lastObjInTopArea);
        }];
    });
    
    // usage days
    ({
        UILabel *despLabel = [UILabel labelWithType:LabelTypeDefault fontSize:11 textColor:UIColorFromRGB(0x999898)];
        despLabel.text = @"使用天数";
        
        [infopadView addSubview:despLabel];
        
        [despLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(infopadView).with.offset(8);
            make.centerX.equalTo(infopadView).multipliedBy(1.0/3.0);
        }];
    });
    
    ({
        UILabel *numberLabel = [UILabel labelWithType:LabelTypeDefault fontSize:24 textColor:UIColorFromRGB(0xfb7540)];
        numberLabel.text = @"**";
        
        [infopadView addSubview:numberLabel];
        
        self.usageDaysLabel = numberLabel;
        
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(infopadView).with.offset(-8);
            make.centerX.equalTo(infopadView).multipliedBy(1.0/3.0);
        }];
        lastObjInTopArea = numberLabel;
    });
    
    ({
        UILabel *unitLabel = [UILabel labelWithType:LabelTypeDefault fontSize:11 textColor:UIColorFromRGB(0x999898)];
        unitLabel.text = @"天";
        
        [infopadView addSubview:unitLabel];
        
        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.baseline.equalTo(lastObjInTopArea);
            make.left.equalTo(lastObjInTopArea.mas_right);
        }];
    });
    
    // income ranking
    ({
        UILabel *despLabel = [UILabel labelWithType:LabelTypeDefault fontSize:11 textColor:UIColorFromRGB(0x999898)];
        despLabel.text = @"金额排名";
        
        [infopadView addSubview:despLabel];
        
        [despLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(infopadView).with.offset(8);
            make.centerX.equalTo(infopadView);
        }];
    });
    
    ({
        UILabel *numberLabel = [UILabel labelWithType:LabelTypeDefault fontSize:24 textColor:UIColorFromRGB(0xfb7540)];
        numberLabel.text = @"**";
        
        [infopadView addSubview:numberLabel];
        
        self.incomeRankingLabel = numberLabel;
        
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(infopadView).with.offset(-8);
            make.centerX.equalTo(infopadView);
        }];
        lastObjInTopArea = numberLabel;
    });
    
    ({
        UILabel *unitLabel = [UILabel labelWithType:LabelTypeDefault fontSize:11 textColor:UIColorFromRGB(0x999898)];
        unitLabel.text = @"名";
        
        [infopadView addSubview:unitLabel];
        
        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.baseline.equalTo(lastObjInTopArea);
            make.left.equalTo(lastObjInTopArea.mas_right);
        }];
    });
    
    // task satistics
    ({
        UILabel *despLabel = [UILabel labelWithType:LabelTypeDefault fontSize:11 textColor:UIColorFromRGB(0x999898)];
        despLabel.text = @"完成任务";
        
        [infopadView addSubview:despLabel];
        
        [despLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(infopadView).with.offset(8);
            make.centerX.equalTo(infopadView).multipliedBy(5.0/3.0);
        }];
    });
    
    ({
        UILabel *numberLabel = [UILabel labelWithType:LabelTypeDefault fontSize:24 textColor:UIColorFromRGB(0xfb7540)];
        numberLabel.text = @"**";
        
        [infopadView addSubview:numberLabel];
        
        self.taskAmountLabel = numberLabel;
        
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(infopadView).with.offset(-8);
            make.centerX.equalTo(infopadView).multipliedBy(5.0/3.0);
        }];
        lastObjInTopArea = numberLabel;
    });
    
    ({
        UILabel *unitLabel = [UILabel labelWithType:LabelTypeDefault fontSize:11 textColor:UIColorFromRGB(0x999898)];
        unitLabel.text = @"个";
        
        [infopadView addSubview:unitLabel];
        
        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.baseline.equalTo(lastObjInTopArea);
            make.left.equalTo(lastObjInTopArea.mas_right);
        }];
    });
    
    // in the downer view is a QR code image view, which shows the QR code of the official account(wechat) of manekineko.
    UIImageView *qrcodeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_me_scoresheet_qrcode"]];
    
    [self.contentView addSubview:qrcodeImgView];
    
    [qrcodeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(lastObjInTopArea.mas_bottom).with.offset(23);
    }];
    
    lastObjInTopArea = qrcodeImgView;
    
    // lowerest lying a button of share the screen shot of this view to wechat app.
    UIButton *shareButton = [UIButton buttonWithButtonType:ButtonTypeOrange];
    
    [shareButton setTitle:@"晒一晒" forState:UIControlStateNormal];
    
    [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:shareButton];
    
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(contentView);
        make.left.equalTo(contentView).with.offset(14);
        make.right.equalTo(contentView).with.offset(-14);
        make.top.equalTo(lastObjInTopArea.mas_bottom).with.offset(23);
        make.height.equalTo(@40);
    }];
    
    lastObjInTopArea = shareButton;
    
    // don't forget updating the content bottom to modify the contentsize of our scrollview. otherwise, it'll be  an wizened scroll view
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(shareButton).with.offset(18);
    }];
    
    [self fetchData];
}

- (void)shareButtonClicked:(UIButton *)button
{
    UIImage *img = [self.contentView takeSnapshotForSize:CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMinY(button.frame))];
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(img, 1.0);
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_APP";
    message.messageExt = @"这是第三方带的测试字段";
    message.messageAction = @"<action>dotalist</action>";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

- (void)fetchData
{
    MNUserIdAndTokenModel *model = [MNUserIdAndTokenModel new];
    model.uid = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] uid];
    model.token = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] token];
    
    [[MNHttpSessionManager manager] POST:kUserTranscripts parameters:[model toDictionary]
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
                                         self.usageDaysLabel.text = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"result"] objectForKey:@"day"]];
                                         self.incomeRankingLabel.text = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"result"] objectForKey:@"incometop"]];
                                         self.taskAmountLabel.text = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"result"] objectForKey:@"taskcount"]];
                                         self.totalIncomeLabel.text = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"result"] objectForKey:@"income"]];
                                     }
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     
                                 }];
}

@end
