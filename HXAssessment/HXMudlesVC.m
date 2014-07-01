//
//  HXMudlesVC.m
//  HXAssessment
//
//  Created by Felix_Y on 14-6-1.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "HXMudlesVC.h"
#import <RETableViewManager.h>
#import "HXNetworkManager.h"

#import "KWPopoverView.h"
#import "HXMudleItem.h"
#import "HXContainerVC.h"
#import "HXExamsTVC.h"

@interface HXMudlesVC ()<RETableViewManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *recentlyExamBtn;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, strong, readwrite) RETableViewManager *manager;
@property (nonatomic, strong, readwrite) RETableViewSection *mudlesSection;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSDictionary *mudlesDic;

@property (nonatomic, strong) NSMutableArray *mutableArray;

@property (nonatomic, assign) NSInteger selectModuleId;

@property (nonatomic, copy) NSString *mudleDescription;

@end

@implementation HXMudlesVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    HXListenEvent(kHXSetting, self, @selector(__settingViewShow:));
    HXListenEvent(kAboutUs, self, @selector(__aboutusShow:));
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    HXForgetEvent(kHXSetting, self);
    HXForgetEvent(kAboutUs, self);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.containerView setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_right_bar"] style:UIBarButtonItemStyleDone target:self action:@selector(__showMenu:forEvent:)];

    [self.navigationItem setRightBarButtonItems:@[rightItem]];
    

    self.mutableArray = [NSMutableArray new];

    self.manager = [[RETableViewManager alloc]initWithTableView:self.tableView delegate:self];

    self.manager[@"HXMudleItem"] = @"HXMudleCell";
    self.mudlesSection = [RETableViewSection section];
    [self.manager addSection:self.mudlesSection];

    [self __addRefreshViewController];
    [self __loadData];

}

- (void)__showMenu:(id)sender forEvent:(UIEvent *)event{
    //[KWPopoverView showPopoverAtPoint:CGPointMake(300, 50) inView:self.view withContentView:self.containerView];
    [self.containerView setHidden: !self.containerView.isHidden];
}

- (void)__settingViewShow:(NSNotification *)notification{
    [self.containerView setHidden:YES];
    [self performSegueWithIdentifier:@"settingpage" sender:self];
}

- (void)__aboutusShow:(NSNotification *)notification{
    [self.containerView setHidden:YES];
    [self performSegueWithIdentifier:@"aboutpage" sender:self];
}

-(void)__addRefreshViewController{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];

    [self.tableView addSubview:self.refreshControl];
}

- (void)__loadData{

    __weak HXMudlesVC *weakSelf = self;

    [[HXNetworkManager sharedHXNetworkManager]getExmaModulesWithPage:1 andPageCount:10 success:^(NSDictionary *dic) {
        weakSelf.mudlesDic = dic;

        [weakSelf __settingData];
        [weakSelf.refreshControl endRefreshing];

    } error:^(NSInteger index) {
        [weakSelf.refreshControl endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf.refreshControl endRefreshing];
    }];

}

- (void)__settingData{
    NSArray *infoArray = self.mudlesDic[@"body"];

    [self.mutableArray removeAllObjects];

    for (NSDictionary *dicInfo in infoArray) {
        NSArray *mudelinfo =  dicInfo[@"columns"];

        NSMutableDictionary *mutableDic = [NSMutableDictionary new];
        [mutableDic setObject:dicInfo[@"id"] forKey:@"id"];

        for (NSDictionary *dic in mudelinfo) {

            if([dic[@"name"]isEqualToString:@"moduleName"]){
                [mutableDic setObject:dic[@"value"] forKey:@"moduleName"];
            }
            else if([dic[@"name"]isEqualToString:@"moduleId"]){
                [mutableDic setObject:dic[@"value"] forKey:@"moduleId"];
            }
            else if([dic[@"name"]isEqualToString:@"moduleExamCount"]){
                [mutableDic setObject:dic[@"value"] forKey:@"moduleExamCount"];
            }
            else if([dic[@"name"]isEqualToString:@"expireTime"]){
                [mutableDic setObject:dic[@"value"] forKey:@"expireTime"];
            }
            else if([dic[@"name"]isEqualToString:@"authSourceAlias"]){
                [mutableDic setObject:dic[@"value"] forKey:@"authSourceAlias"];
            }
            else if([dic[@"name"]isEqualToString:@"moduleDescription"]){
                [mutableDic setObject:dic[@"value"] forKey:@"moduleDescription"];
            }

        }
        [self.mutableArray addObject:mutableDic];
    }

    [self __settingTableView];
}

- (void)__settingTableView{

    [self.mudlesSection removeAllItems];
    __weak HXMudlesVC *weakSelf = self;
    for (NSDictionary *dic in self.mutableArray) {

        HXMudleItem *theItem = [HXMudleItem new];
        [theItem intentionDic:dic];
        [weakSelf.mudlesSection addItem:theItem];
        [theItem setSelectionHandler:^(HXMudleItem *item) {
            [item deselectRowAnimated:YES];
            [weakSelf __loadExams:item.moduleId withDescription:item.moduleDescription];
        }];

        //eplatform.edu-edu.com.cn/exam-admin/home/my/module/exams/list/1?moduleId=2&pageCount=5&site_preference=mobile&ct=clien
    }
    [self.tableView reloadData];
}

- (void)__loadExams:(NSInteger)moduleId withDescription:(NSString *)description{
    self.selectModuleId = moduleId;
    self.mudleDescription = description;
    [self performSegueWithIdentifier:@"examspage" sender:self.navigationController];
}

- (void)RefreshViewControlEventValueChanged{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中..."];
    [self performSelector:@selector(__loadData) withObject:nil afterDelay:2.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"examspage"]){
        HXExamsTVC *examsTVC = [segue destinationViewController];
        examsTVC.moduleId = self.selectModuleId;
        examsTVC.mudleDescription = self.mudleDescription;
    }
}


@end
