//
//  HXSingletonMaker.h
//  HXAssessment
//
//  Created by Felix_Y on 14-5-28.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#ifndef HXAssessment_HXSingletonMaker_h
#define HXAssessment_HXSingletonMaker_h

#ifndef SYNTHESIZE_SINGLETON_FOR_CLASS

#import <objc/runtime.h>


#pragma mark -
#pragma mark Singleton

#define SYNTHESIZE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;


#define SYNTHESIZE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#endif

#endif
