//
//  HXSectionQuestion.h
//  HXAssessment
//
//  Created by Felix_Y on 14-6-23.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXQuestion.h"
@interface HXSectionQuestion : NSObject

@property (nonatomic, strong) NSArray *questions;//question
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy)   NSString *title;

@end
