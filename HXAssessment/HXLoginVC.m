//
//  HXLoginVC.m
//  HXAssessment
//
//  Created by Felix_Y on 14-5-29.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "HXLoginVC.h"

#import <SSKeychain.h>
#import "HXNetworkManager.h"

@interface HXLoginVC ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *remeberPwdBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (assign, nonatomic) BOOL isRemeber;
@end

@implementation HXLoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES];

    self.isRemeber = YES;
    [self.remeberPwdBtn setImage:[UIImage imageNamed:@"btn_remebered"] forState:UIControlStateNormal];

    [self __checkUserState];
    [self __updateInfo];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundColor)];
}

- (void)__checkUserState{
    if ([[[SSKeychain allAccounts]lastObject]objectForKey:@"acct"]) {
        self.userNameTF.text = [[[SSKeychain allAccounts]lastObject]objectForKey:@"acct"];
        self.pwdTF.text = [SSKeychain passwordForService:kHXExamKeychain account:[[[SSKeychain allAccounts]lastObject]objectForKey:@"acct"]];
    }else{
        self.userNameTF.text = [USER_DEFAULTS valueForKey:@"lastUserName"];
    }

}

- (void)__updateInfo{

}

- (IBAction)clickRemeberPwd:(id)sender {
    self.isRemeber = !(self.isRemeber);
    
    if (self.isRemeber) {
        [self.remeberPwdBtn setImage:[UIImage imageNamed:@"btn_remebered"] forState:UIControlStateNormal];
    }else{
        [self.remeberPwdBtn setImage:[UIImage imageNamed:@"btn_noremeber"] forState:UIControlStateNormal];
    }

}

- (IBAction)clickLogin:(id)sender {

    if (![self __checkTexts]) {
        return ;
    }

    __weak HXLoginVC *weakSelf = self;


    [[HXNetworkManager sharedHXNetworkManager] loginWithParams:@{@"userid":self.userNameTF.text,@"password":self.pwdTF.text} success:^(NSDictionary *dic) {

        [weakSelf __remeberPwd];

        if (dic[@"st"]) {
            [weakSelf __verifyST:dic[@"st"]];
        }else if(dic[@"tgt"]){
            [weakSelf __getSTValue:dic[@"tgt"]];
        }else{

        }

    } error:^(NSInteger index) {

    } failure:^(NSError *error) {

    }];

}

- (void)__getSTValue:(NSString *)tgt{

    __weak HXLoginVC *weakSelf = self;

    [[HXNetworkManager sharedHXNetworkManager] getSTCodeParams:@{@"tgt":tgt} success:^(NSDictionary *dic) {

        [weakSelf __verifyST:dic[@"st"]];

    } error:^(NSInteger index) {

    } failure:^(NSError *error) {

    }];
}

- (void)__verifyST:(NSString *)STString{

    __weak HXLoginVC *weakSelf = self;

    [[HXNetworkManager sharedHXNetworkManager] verifyST:STString success:^(NSDictionary *dic) {
         [weakSelf __gotoMudlesView];
    } error:^(NSInteger index) {

    } failure:^(NSError *error) {

        if (error.userInfo[@"NSErrorFailingURLKey"]) {
            NSURL *url = (NSURL *)(error.userInfo[@"NSErrorFailingURLKey"]);
            if ([[url absoluteString] isEqualToString:@"http://eplatform.edu-edu.com.cn/exam-admin/home/index"]) {
                [weakSelf __gotoMudlesView];
            }
        }
    }];

}

- (BOOL)__checkTexts{

    if ([self.userNameTF.text length]>0 && [self.pwdTF.text length]>0) {
        return YES;
    }

    return NO;
}

- (void)__remeberPwd{
    NSError *error = nil;
    if (self.isRemeber) {
        [SSKeychain setPassword:self.pwdTF.text forService:kHXExamKeychain account:self.userNameTF.text error:&error];
    }else{
        [SSKeychain deletePasswordForService:kHXExamKeychain account:self.userNameTF.text];
        [USER_DEFAULTS setValue:self.userNameTF.text forKey:@"lastUserName"];
    }
}

- (void)__gotoMudlesView{
    [self.navigationController performSegueWithIdentifier:@"mainpage" sender:self.navigationController];
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
