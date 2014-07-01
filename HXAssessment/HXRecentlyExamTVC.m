//
//  HXRecentlyExamTVC.m
//  HXAssessment
//
//  Created by Felix_Y on 14-6-6.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "HXRecentlyExamTVC.h"
#import "HXNetworkManager.h"
#import "HXRecentlyExamItem.h"
#import <RETableViewManager.h>

@interface HXRecentlyExamTVC ()<RETableViewManagerDelegate>

@property (nonatomic, strong, readwrite) RETableViewManager *manager;
@property (nonatomic, strong, readwrite) RETableViewSection *section;

@property (nonatomic, strong) NSDictionary *examsDic;
@property (nonatomic, strong) NSMutableArray *mutableArray;

@property (nonatomic, strong) NSString *showVCTitle;

@end

@implementation HXRecentlyExamTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager = [[RETableViewManager alloc]initWithTableView:self.tableView delegate:self];
    self.section = [RETableViewSection section];


    [self.manager addSection:self.section];
    self.manager[@"HXRecentlyExamItem"] = @"HXRecentlyExamCell";
    [self __addRefreshViewController];
    [self __loadData];

}


-(void)__addRefreshViewController{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];

    //[self.tableView addSubview:self.refreshControl];
}

- (void)__loadData{

    __weak HXRecentlyExamTVC *weakSelf = self;

    [[HXNetworkManager sharedHXNetworkManager]getLastExams:20 success:^(NSDictionary *dic) {
        weakSelf.examsDic = dic;

        [weakSelf __settingData];
        [weakSelf.refreshControl endRefreshing];

    } error:^(NSInteger index) {
        [weakSelf.refreshControl endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf.refreshControl endRefreshing];
    }];

}

- (void)__settingData{
    NSArray *infoArray = self.examsDic[@"latestExams"];

    self.mutableArray = [NSMutableArray arrayWithArray:infoArray];

    [self __settingTableView];
}

- (void)__settingTableView{

    [self.section removeAllItems];

    for (NSDictionary *dic in self.mutableArray) {

        HXRecentlyExamItem *theItem = [HXRecentlyExamItem new];
        [theItem intentionDic:dic];
        [self.section addItem:theItem];

        __weak HXRecentlyExamTVC *weakSelf = self;
        theItem.rac_continueCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            [weakSelf __beginExam:theItem.id withModuleID:theItem.id];
            return [RACSignal empty];
        }];

        theItem.rac_showRecordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            [weakSelf __showRecord:theItem.id];
            weakSelf.showVCTitle = theItem.examName;
            return [RACSignal empty];
        }];
        
    }

    [self.tableView reloadData];
}

- (void)__beginExam:(NSInteger)examID withModuleID:(NSInteger )moduleID{

}

- (void)__showRecord:(NSInteger)examID{
    [[HXNetworkManager sharedHXNetworkManager] getExamRecord:examID success:^(id obj) {

    } error:^(NSInteger index) {

    } failure:^(NSError *error) {

    }];
}


-(void)RefreshViewControlEventValueChanged{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中..."];
    [self performSelector:@selector(__loadData) withObject:nil afterDelay:2.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
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
