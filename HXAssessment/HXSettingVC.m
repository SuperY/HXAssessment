//
//  HXSettingVC.m
//  HXAssessment
//
//  Created by Felix_Y on 14-6-1.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "HXSettingVC.h"
#import <RETableViewManager.h>

@interface HXSettingVC ()<RETableViewManagerDelegate>

@property (nonatomic, strong, readwrite) RETableViewManager *manager;
@property (nonatomic, strong, readwrite) RETableViewSection *cacheSection;
@property (nonatomic, strong, readwrite) RETableViewSection *accountSection;

@end

@implementation HXSettingVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager = [[RETableViewManager alloc]initWithTableView:self.tableView delegate:self];
    self.cacheSection = [RETableViewSection sectionWithHeaderTitle:@"缓存设置"];
    self.accountSection = [RETableViewSection sectionWithHeaderTitle:@"账号设置"];
    [self.manager addSectionsFromArray:@[self.cacheSection,self.accountSection]];

    [self.cacheSection addItem:[RETableViewItem itemWithTitle:@"清除缓存" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];

    }]];

    [self.accountSection addItem:[RETableViewItem itemWithTitle:@"切换账号" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
    }]];

    NSString *logoutString = [NSString stringWithFormat:@"注销："];
    [self.accountSection addItem:[RETableViewItem itemWithTitle:logoutString accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];

        [self.navigationController performSegueWithIdentifier:@"pushlogin" sender:self.navigationController];
    }]];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
