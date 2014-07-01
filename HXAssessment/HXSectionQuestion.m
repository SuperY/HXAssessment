//
//  HXSectionQuestion.m
//  HXAssessment
//
//  Created by Felix_Y on 14-6-23.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "HXSectionQuestion.h"

@implementation HXSectionQuestion

- (void)setTitle:(NSString *)title{
    if ([title isEqualToString:@"ui-question-group question-group-1"]) {
        title = @"单选题";
    }else if ([title isEqualToString:@"ui-question-group question-group-2"]) {
        title = @"多选题";
    }else if ([title isEqualToString:@"ui-question-group question-group-3"]) {
        title = @"填空题";
    }else if ([title isEqualToString:@"ui-question-group question-group-4"]) {
        title = @"复合题";
    }
}

@end
