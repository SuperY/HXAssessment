//
//  HXExamItem.h
//  HXAssessment
//
//  Created by Felix_Y on 14-6-13.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "RETableViewItem.h"
#import <ReactiveCocoa.h>

typedef void(^HXExamCanBegin)();

@interface HXExamItem : RETableViewItem

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *examName;
@property (nonatomic, assign) BOOL canExam;
@property (nonatomic, assign) NSInteger userExamNum;
@property (nonatomic, assign) NSInteger maxExamNum;
@property (nonatomic, strong) NSString *beginTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *limiteTime;
@property (nonatomic, strong) RACCommand *rac_command;


- (void)intentionDic:(NSDictionary *)dic;

@end

@interface HXExamCell : RETableViewCell

@property (strong, readwrite, nonatomic) HXExamItem *item;

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *beginTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *limiteTime;
@property (weak, nonatomic) IBOutlet UIButton *beginExam;

@end