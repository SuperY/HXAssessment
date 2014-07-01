//
//  HXMudleItem.m
//  HXAssessment
//
//  Created by Felix_Y on 14-6-6.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "HXMudleItem.h"

@implementation HXMudleItem

- (void)intentionDic:(NSDictionary *)dic{

    self.moduleName = dic[@"moduleName"];
    self.moduleExamCount = [dic[@"moduleExamCount"] integerValue];
    self.expireTime = dic[@"expireTime"];
    self.authSourceAlias = dic[@"authSourceAlias"];
    self.moduleDescription = dic[@"moduleDescription"];
    self.moduleId = [dic[@"moduleId"] integerValue];
    self.id = [dic[@"id"] integerValue];

}

@end


@implementation HXMudleCell
+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager{

    return 72;
}

- (void)cellWillAppear
{
    [super cellWillAppear];

    self.moduleNameLabel.text = self.item.moduleName;
    self.moduleExamCountLabel.text = [@(self.item.moduleExamCount) stringValue];

    self.expireTimeLabel.text = self.item.expireTime;
    self.authSourceAliasLabel.text = self.item.authSourceAlias;
}

@end