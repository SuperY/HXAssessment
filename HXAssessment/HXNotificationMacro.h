//
//  HXNotificationMacro.h
//  HXAssessment
//
//  Created by Felix_Y on 14-5-27.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#ifndef HXAssessment_HXNotificationMacro_h
#define HXAssessment_HXNotificationMacro_h

#define kHXSetting @"setting"
#define kAboutUs   @"aboutus"

#endif

#import <Foundation/Foundation.h>

@interface HXNotificationMacro : NSObject

/** 快速UIAlertView*/
void HXAlert(NSString *title, NSString *msg, NSString *buttonText);
//封装Alert
void HXAlerView(NSString *title, NSString *msg,id<UIAlertViewDelegate> delegate, NSString *buttonText,NSString *cancleString);

/** Notification*/
void HXEvent(NSString *eventName,id data);
void HXListenEvent(NSString *eventName,id target,SEL method);

void HXForgetEvent(NSString *eventName,id target);

@end




