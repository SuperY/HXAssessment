//
//  HXAnswer.h
//  HXAssessment
//
//  Created by Felix_Y on 14-5-29.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "JSONModel.h"

@protocol HXRightAnswer
@end

@interface HXRightAnswer : JSONModel

@property (assign, nonatomic) NSInteger questionId;
@property (assign, nonatomic) BOOL sub;
@property (assign, nonatomic) NSInteger parentId;
@property (strong, nonatomic) NSNumber *score;
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSString<Optional> *hint;

@property (strong, nonatomic) NSString *answer;


@end

@interface HXRightAnswers : JSONModel

@property (strong, nonatomic) NSArray<HXRightAnswer> *anwsers;

@end


