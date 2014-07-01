//
//  HXUserAnswers.h
//  HXAssessment
//
//  Created by Felix_Y on 14-5-29.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "JSONModel.h"

@protocol HXUserAnswer
@end

@interface HXUserAnswer : JSONModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *answer;
@property (assign, nonatomic) BOOL right;

@end


@interface HXUserAnswers : JSONModel

@property (strong, nonatomic) NSArray<HXUserAnswer> *answers;

@end
