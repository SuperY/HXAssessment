//
//  HXCacheManager.h
//  HXAssessment
//
//  Created by Felix_Y on 14-6-23.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXCacheManager : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(HXCacheManager)

- (void)loadUserPath:(NSString *)userName;

- (NSString *)saveExam:(NSString *)examID withExamMudelID:(NSString *)mudelID;

@end
