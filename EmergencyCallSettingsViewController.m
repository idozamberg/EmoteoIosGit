//
//  EmergencyCallSettingsViewController.m
//  iCare
//
//  Created by ido zamberg on 1/10/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import "EmergencyCallSettingsViewController.h"

@implementation EmergencyCallSettingsViewController


- (void) viewWillAppear:(BOOL)animated
{
    self.txtNumber.text = [AppData sharedInstance].emergencyNumber;
    self.txtNumber.delegate = self;
}

- (IBAction)saveClicked:(id)sender {
    
    [self.txtNumber resignFirstResponder];
    [[AppData sharedInstance] setEmergencyNumber:self.txtNumber.text];
    
    [UIHelper showMessage:@"Le numéro a été enregistré"];
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txtNumber resignFirstResponder];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.txtNumber resignFirstResponder];
    return YES;
}



- (IBAction)backClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)creditsClicked:(id)sender {
    [[FlowManager sharedInstance] showCreditsVC];
}

- (BOOL) shouldAutorotate
{
    return NO;
}
@end
