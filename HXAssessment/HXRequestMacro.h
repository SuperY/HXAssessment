//
//  HXRequestPath.h
//  HXAssessment
//
//  Created by Felix_Y on 14-5-27.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#ifndef HXAssessment_HXRequestMacro_h
#define HXAssessment_HXRequestMacro_h

#define kHXDomain  @"http://eplatform.edu-edu.com.cn"

typedef UIImage *(^HXImgBlock)();
typedef void(^HXErrorBlock)(NSError *error);


typedef void(^HXBlock)(void);
typedef void(^HXBlockBlock)(HXBlock block);

typedef void(^HXObjectBlock)(id obj);
typedef void(^HXArrayBlock)(NSArray *array);
typedef void(^HXMutableArrayBlock)(NSMutableArray *array);
typedef void(^HXDictionaryBlock)(NSDictionary *dic);

typedef void(^HXIndexBlock)(NSInteger index);
typedef void(^HXFloatBlock)(CGFloat afloat);

typedef void(^HXCancelBlock)(id viewController);
typedef void(^HXFinishedBlock)(id viewController, id object);

typedef void(^HXSendRequestAndResendRequestBlock)(id sendBlock, id resendBlock);

#endif
