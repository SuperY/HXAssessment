//
//  HXMudleItem.h
//  HXAssessment
//
//  Created by Felix_Y on 14-6-6.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "RETableViewItem.h"

@interface HXMudleItem : RETableViewItem

@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, assign) NSInteger moduleExamCount;
@property (nonatomic, copy) NSString *expireTime;
@property (nonatomic, copy) NSString *authSourceAlias;
@property (nonatomic, copy) NSString *moduleDescription;

@property (nonatomic, assign) NSInteger moduleId;
@property (nonatomic, assign) NSInteger id;

- (void)intentionDic:(NSDictionary *)dic;
@end


@interface HXMudleCell : RETableViewCell
@property (strong, readwrite, nonatomic) HXMudleItem *item;
@property (weak, readwrite, nonatomic) IBOutlet UILabel *moduleNameLabel;
@property (weak, readwrite, nonatomic) IBOutlet UILabel *moduleExamCountLabel;
@property (weak, readwrite, nonatomic) IBOutlet UILabel *expireTimeLabel;

@property (weak, readwrite, nonatomic) IBOutlet UILabel *authSourceAliasLabel;

@end