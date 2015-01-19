//
//  SpecificInformationViewController.m
//  iCare
//
//  Created by ido zamberg on 1/12/15.
//  Copyright (c) 2015 ido zamberg. All rights reserved.
//

#import "SpecificInformationViewController.h"
#import "FlowManager.h"

@interface SpecificInformationViewController ()

@end


@implementation SpecificInformationViewController
@synthesize lblTitle,tvInformationText;
@synthesize questionTitle = _questionTitle;
@synthesize text = _text;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setTextAndTitle : (NSString*) text andTitle : (NSString*) title
{
    _questionTitle = title;
    _text = text;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Setting information
    lblTitle.text = _questionTitle;
    tvInformationText.text = _text;
}

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)emergencyClicked:(id)sender {
    [[FlowManager sharedInstance] showEmergencyVC];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
