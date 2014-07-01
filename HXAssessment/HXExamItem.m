//
//  HXExamItem.m
//  HXAssessment
//
//  Created by Felix_Y on 14-6-13.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "HXExamItem.h"

@implementation HXExamItem

- (void)intentionDic:(NSDictionary *)dic{
    self.examName = dic[@"title"];
    self.id    = [dic[@"id"] integerValue];
    self.canExam = [dic[@"canExam"] boolValue];
    self.userExamNum = [dic[@"userExamNum"] integerValue];
    self.maxExamNum = [dic[@"maxExamNum"] integerValue];
    self.beginTime = dic[@"beginTime"];
    self.endTime = dic[@"endTime"];
    self.limiteTime = dic[@"limiteTime"];
}

@end

@implementation HXExamCell

+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager{

    return 150;
}

- (void)cellWillAppear
{
    [super cellWillAppear];

    self.title.text = self.item.examName;
    self.beginTime.text   = self.item.beginTime;
    self.endTime.text  = self.item.endTime;
    self.limiteTime.text    = [@(self.item.maxExamNum - self.item.userExamNum) stringValue];
    [self.beginExam setEnabled: self.item.canExam];
    [self.beginExam setRac_command:self.item.rac_command];

    if (iOS_Version >=7.0) {
        [self.contentView removeFromSuperview];
    }
}

@end