//
//  HXQuestion.h
//  HXAssessment
//
//  Created by Felix_Y on 14-6-23.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXAnswer.h"

@interface HXQuestion : NSObject

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSString* stringAnswer;
@property (nonatomic, assign) NSInteger intAnswer;
@property (nonatomic, assign) NSString *score;


@property (nonatomic, strong) NSArray *answers;
@property (nonatomic, strong) NSDictionary *others;

@property (nonatomic, strong) NSArray *subQuestions;

@end
