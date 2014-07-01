//
//  HXContinueExamInfo.h
//  HXAssessment
//
//  Created by Felix_Y on 14-5-29.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "JSONModel.h"

@interface HXContinueExamInfo : JSONModel

@property (strong, nonatomic) NSURL *context;       //考试服务器url
@property (strong, nonatomic) NSURL *examUrl;       //试卷相关信息url
@property (strong, nonatomic) NSString *examName;   //试卷名称

@end
