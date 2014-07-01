//
//  HXRegisterVC.m
//  HXAssessment
//
//  Created by Felix_Y on 14-5-30.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "HXRegisterVC.h"
#import "HXNetworkManager.h"
#import <AFNetworking/UIButton+AFNetworking.h>

NSString * const kCodeImage = @"http://eplatform.edu-edu.com.cn/cas/captcha.png?";

@interface HXRegisterVC ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdConfirmTF;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *refreshCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;


@end

@implementation HXRegisterVC

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
    [self clickRefreshCode:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)checkUserState{

}

- (void)updateInfo{

}

- (IBAction)clickRefreshCode:(id)sender {

    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];
    NSDate *localeDate = [[NSDate date] dateByAddingTimeInterval: interval];

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];

    NSString *urlString = [kCodeImage stringByAppendingString:timeSp];

    [self.refreshCodeBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:urlString]];
}

- (IBAction)clickLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickRegister:(id)sender {
    NSDictionary *registerDic = @{@"userid":self.userNameTF.text,
                                  @"password":self.pwdTF.text,
                                  @"passwordConfirm":self.pwdConfirmTF.text,
                                  @"nick":self.userNameTF.text,
                                  @"__captcha_str_key":self.checkCodeTF.text
                                  };

    [[HXNetworkManager sharedHXNetworkManager]registerWithParams:registerDic success:^(NSDictionary *dic) {

    } error:^(NSInteger index) {

    } failure:^(NSError *error) {

    }];


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
