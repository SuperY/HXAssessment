//
//  HXRecentlyExmaItem.h
//  HXAssessment
//
//  Created by Felix_Y on 14-6-7.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "RETableViewItem.h"
#import <ReactiveCocoa.h>

@interface HXRecentlyExamItem : RETableViewItem

@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, assign) NSInteger remainCount;
@property (nonatomic, copy) NSString *examName;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, assign) BOOL canExam;
@property (nonatomic, assign) NSInteger userExamNum;

@property (nonatomic,assign) NSInteger id;

@property (nonatomic, strong) RACCommand *rac_continueCommand;
@property (nonatomic, strong) RACCommand *rac_showRecordCommand;
- (void)intentionDic:(NSDictionary *)dic;


@end


@interface HXRecentlyExamCell : RETableViewCell
@property (strong, readwrite, nonatomic) HXRecentlyExamItem *item;
@property (weak, nonatomic) IBOutlet UILabel *moduleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *examNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (weak, nonatomic) IBOutlet UIButton *showRecordBtn;

@end
