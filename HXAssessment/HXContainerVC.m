//
//  HXContainerVC.m
//  HXAssessment
//
//  Created by Felix_Y on 14-6-11.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "HXContainerVC.h"

@interface HXContainerVC ()
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIButton *aboutUs;

@end

@implementation HXContainerVC

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)settingBtnSelect:(id)sender{
    HXEvent(kHXSetting, nil);
}

- (IBAction)aboutUsSelect:(id)sender{
    HXEvent(kAboutUs, self);
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
