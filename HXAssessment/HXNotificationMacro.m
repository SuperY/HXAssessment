//
//  HX.m
//  HXAssessment
//
//  Created by Felix_Y on 14-6-11.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "HXNotificationMacro.h"

@implementation HXNotificationMacro

/** 快速UIAlertView*/
void HXAlert(NSString *title, NSString *msg, NSString *buttonText){

	UIAlertView *av=[[UIAlertView alloc] initWithTitle:title
											   message:msg
											  delegate:nil
									 cancelButtonTitle:buttonText
									 otherButtonTitles:nil];
	[av show];
}

//封装Alert
void HXAlerView(NSString *title, NSString *msg,id<UIAlertViewDelegate> delegate, NSString *buttonText,NSString *cancleString){
    UIAlertView *av=[[UIAlertView alloc] initWithTitle:title
											   message:msg
											  delegate:delegate
									 cancelButtonTitle:buttonText
									 otherButtonTitles:cancleString,nil];
	[av show];
};

/** Notification*/
void HXEvent(NSString *eventName,id data){
	[[NSNotificationCenter defaultCenter] postNotificationName:eventName object:data];
}

void HXListenEvent(NSString *eventName,id target,SEL method){
	[[NSNotificationCenter defaultCenter] addObserver:target selector:method name:eventName object:nil];
}

void HXForgetEvent(NSString *eventName,id target){
	[[NSNotificationCenter defaultCenter] removeObserver:target name:eventName object:nil];
}

@end
