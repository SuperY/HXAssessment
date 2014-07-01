//
//  HXRecentlyExmaItem.m
//  HXAssessment
//
//  Created by Felix_Y on 14-6-7.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "HXRecentlyExamItem.h"

@implementation HXRecentlyExamItem

- (void)intentionDic:(NSDictionary *)dic{

//    beginTime = 1374123600000;
//    canExam = 1;
//    endTime = 1405486800000;
//    id = 40;
//    maxExamNum = 50;
//    moduleName = "Andriod\U5e94\U7528\U7a0b\U5e8f\U5f00\U53d1";
//    title = "\U7535\U5b50\U79d1\U6280";
//    userExamNum = 0;

    self.moduleName = dic[@"moduleName"];
    self.examName = dic[@"title"];

    self.beginTime = [self __transforTime: [dic[@"beginTime"] stringValue]];
    self.endTime = [self __transforTime: [dic[@"endTime"] stringValue]];

    self.remainCount = [dic[@"maxExamNum"] integerValue];

    self.canExam = [dic[@"canExam"] boolValue];
    self.userExamNum = [dic[@"userExamNum"] integerValue];

    self.id = [dic[@"id"] integerValue];
}

- (NSString *)__transforTime:(NSString *)time{
    NSString *timeString = [time substringToIndex:10];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];

    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeString intValue]];
    NSString *timeStr = [formatter stringFromDate:confromTimesp];
    return timeStr;
}

@end


@implementation HXRecentlyExamCell

+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager{

    return 160;
}

- (void)cellWillAppear
{
    [super cellWillAppear];

    self.moduleNameLabel.text = self.item.moduleName;
    self.examNameLabel.text   = self.item.examName;
    self.beginTimeLabel.text  = self.item.beginTime;
    self.endTimeLabel.text    = self.item.endTime;
    self.remainCountLabel.text= [@(self.item.remainCount) stringValue];
    [self.continueBtn setHidden:!self.item.canExam];
    [self.continueBtn setRac_command:self.item.rac_continueCommand];
    [self.showRecordBtn setRac_command:self.item.rac_showRecordCommand];

    if (iOS_Version >=7.0) {
        [self.contentView removeFromSuperview];
    }

}

@end
