//
//  HXExamPaper.h
//  HXAssessment
//
//  Created by Felix_Y on 14-6-23.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSectionQuestion.h"
@interface HXExamPaper : NSObject

@property (nonatomic, copy) NSString *examPaperName;
@property (nonatomic, assign) NSInteger moduleID;
@property (nonatomic, assign) NSInteger examID;

@property (nonatomic, strong) NSArray *sectionQuestions; //HXSectionQuestion

@end
