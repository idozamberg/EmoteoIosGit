//
//  UrgenceViewController.m
//  iCare
//
//  Created by ido zamberg on 11/12/13.
//  Copyright (c) 2013 ido zamberg. All rights reserved.
//

#import "UrgenceViewController.h"

@interface UrgenceViewController ()

@end

@implementation UrgenceViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backClicked:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:Nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)emergencyClicked:(id)sender {
    
    [AnalyticsManager sharedInstance].sendToGoogle =YES;
    [AnalyticsManager sharedInstance].sendToFlurry =YES;
    [[AnalyticsManager sharedInstance] sendEventWithName:@"Emergency Call button clicked" Category:@"Emergency" Label:Nil];
    
    // Creating calling string
    NSString* callingString = [NSString stringWithFormat:@"tel://%@",[AppData sharedInstance].emergencyNumber];
    
    // Calling
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callingString]];

}

- (BOOL) shouldAutorotate
{
    return NO;
}
@end
