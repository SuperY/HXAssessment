//
//  HXExamsTVC.m
//  HXAssessment
//
//  Created by Felix_Y on 14-6-13.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "HXExamsTVC.h"
#import "HXNetworkManager.h"
#import <RETableViewManager.h>
#import "HXExamItem.h"
#import "HXExamingVC.h"

@interface HXExamsTVC ()<RETableViewManagerDelegate>

@property (nonatomic, strong, readwrite) RETableViewManager *manager;
@property (nonatomic, strong, readwrite) RETableViewSection *examsSection;

@property (nonatomic, strong) UITextField *disField;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger countNum;

@property (nonatomic, strong) NSMutableArray *mutableArray;

@property (nonatomic, assign) NSInteger examId;
@property (nonatomic, copy)   NSString *theTitle;
@property (nonatomic, copy)   NSString *theURL;
@end

@implementation HXExamsTVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void) __loadExams{

    __weak HXExamsTVC *weakSelf = self;
    
    [[HXNetworkManager sharedHXNetworkManager]getExmas:self.moduleId withPage:self.pageNum andPageCount:self.countNum success:^(NSArray *array) {
        [weakSelf __settingData:array];
    } error:^(NSInteger index) {

    } failure:^(NSError *error) {

    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *myBarButtonItem = [[UIBarButtonItem alloc] init];
    myBarButtonItem.title = @"返回"; 
    self.navigationItem.backBarButtonItem = myBarButtonItem;


    self.pageNum = 1;
    self.countNum = 10;

    self.mutableArray = [NSMutableArray array];

    self.manager = [[RETableViewManager alloc]initWithTableView:self.tableView delegate:self];
    self.examsSection = [RETableViewSection sectionWithHeaderView:[self __textView]];
    [self.examsSection.headerView setBackgroundColor:[UIColor lightGrayColor]];
    [self.manager addSection:self.examsSection];
    self.manager[@"HXExamItem"] = @"HXExamCell";
    [self __loadExams];

}

- (UIView *)__textView{
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, 0, 0)]; //290 230
    msgLabel.backgroundColor = [UIColor lightTextColor];
    [msgLabel setNumberOfLines:0];
    msgLabel.lineBreakMode =  NSLineBreakByWordWrapping;// UILineBreakModeWordWrap;
    UIFont *fonts = [UIFont fontWithName:@"Arial" size:14];
    msgLabel.font = fonts;
    CGSize size = CGSizeMake(280, 300);
    msgLabel.text = self.mudleDescription;
    CGSize msgSie = [msgLabel.text sizeWithFont:fonts constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [msgLabel setFrame:CGRectMake(10, 10, 280, msgSie.height)];
    return msgLabel;
}

- (void)__settingData:(NSArray *)array{

    for (NSDictionary *dic in array) {

        NSMutableDictionary *muDic = [NSMutableDictionary new];
        [muDic setObject:dic[@"id"] forKey:@"id"];

        NSArray *dicArray = dic[@"columns"];
        for (NSDictionary *dicSub in dicArray) {
            if([dicSub[@"name"]isEqualToString:@"title"]){
                [muDic setObject:dicSub[@"value"] forKey:@"title"];
            }else if([dicSub[@"name"]isEqualToString:@"canExam"]){
                [muDic setObject:dicSub[@"value"] forKey:@"canExam"];
            }else if([dicSub[@"name"]isEqualToString:@"userExamNum"]){
                [muDic setObject:dicSub[@"value"] forKey:@"userExamNum"];
            }else if([dicSub[@"name"]isEqualToString:@"maxExamNum"]){
                [muDic setObject:dicSub[@"value"] forKey:@"maxExamNum"];
            }else if([dicSub[@"name"]isEqualToString:@"beginTime"]){
                [muDic setObject:dicSub[@"value"] forKey:@"beginTime"];
            }else if([dicSub[@"name"]isEqualToString:@"endTime"]){
                [muDic setObject:dicSub[@"value"] forKey:@"endTime"];
            }else if([dicSub[@"name"]isEqualToString:@"limitTime"]){
                [muDic setObject:dicSub[@"value"] forKey:@"limitTime"];
            }
        }


        [self.mutableArray addObject:muDic];
    }

    [self __settingTableView];
}

- (void)__settingTableView{

    [self.examsSection removeAllItems];

    for (NSDictionary *dic in self.mutableArray) {

        HXExamItem *theItem = [HXExamItem new];
        [theItem intentionDic:dic];

        __weak HXExamsTVC *weakSelf = self;
        theItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            [weakSelf __getExamStartInfo:theItem.id];
            weakSelf.theTitle = theItem.examName;
            return [RACSignal empty];
        }];

        [self.examsSection addItem:theItem];
    }

    [self.tableView reloadData];
}

- (void)__getExamStartInfo:(NSInteger)examId{
    __weak HXExamsTVC *weakSelf = self;
    self.examId = examId;
    [[HXNetworkManager sharedHXNetworkManager]getExamStartInfo:examId success:^(id urlString) {
        [weakSelf __downloadExamInfo:[NSURL URLWithString:urlString]];

//        NSURL *url = [NSURL URLWithString:urlString];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        UIWebView *view = [[UIWebView alloc]initWithFrame:self.view.frame];
//        [view loadRequest:request];
//        [self.view addSubview:view];

    } error:^(NSInteger index) {

    } failure:^(NSError *error) {

    }];
}

- (void)__downloadExamInfo:(NSURL *)url{

    __weak HXExamsTVC *weakSelf = self;
    [[HXNetworkManager sharedHXNetworkManager]loadExamInfo:url success:^(id obj) {
        weakSelf.theURL = obj[@"url"];
        [weakSelf performSegueWithIdentifier:@"goexaming" sender:self.navigationController];
    } error:^(NSInteger index) {

    } failure:^(NSError *error) {

    }];
}

- (void)__goExam:(NSString *)url{


}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [(HXExamingVC *)[segue destinationViewController] setTheURL:self.theURL];
    [(HXExamingVC *)[segue destinationViewController] setExamID:self.examId];
    [(HXExamingVC *)[segue destinationViewController] setModuleID:self.moduleId];
    [(HXExamingVC *)[segue destinationViewController] setUrl:self.theURL];
    [[segue destinationViewController] setTitle:self.theTitle];

}


@end
