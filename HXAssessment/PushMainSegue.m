//
//  PushMainSegue.m
//  QFQYB
//
//  Created by Felix_Y on 14-2-13.
//  Copyright (c) 2014年 qfpay. All rights reserved.
//

/**
 *  自定义Storyboard切换时动作类型以及其他操作，未被引用，但在Storyboard中被使用
 *
 *
 */


#import "PushMainSegue.h"

@implementation PushMainSegue
- (void)perform
{
    UINavigationController *current = self.sourceViewController;

    UIViewController *next = self.destinationViewController;

    //[current.navigationController pushViewController:next animated:YES];
    NSMutableArray *conVC = [NSMutableArray arrayWithArray: current.viewControllers];
    [conVC removeAllObjects];
    [conVC addObject:next];
    [current setViewControllers:conVC animated:YES];
}
@end
