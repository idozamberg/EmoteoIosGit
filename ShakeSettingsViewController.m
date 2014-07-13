//
//  ShakeSettingsViewController.m
//  iCare
//
//  Created by ido zamberg on 1/10/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import "ShakeSettingsViewController.h"

@implementation ShakeSettingsViewController

- (void) viewWillAppear:(BOOL)animated
{
    self.lblLevel.text = [NSString stringWithFormat:@"Niveau \"Shake\": %i",[[AppData sharedInstance].shakeLevel integerValue]];

    [self.pkrLevels selectRow:[[AppData sharedInstance].shakeLevel integerValue]-1 inComponent:0 animated:NO];
    [self.pkrLevels setAlpha:0];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return ([NSString stringWithFormat:@"%i",row + 1]);
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.lblLevel.text = [NSString stringWithFormat:@"Niveau \"Shake\": %i",row + 1];
    
    currentLevel = row + 1;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [self.pkrLevels setAlpha:0];
    //self.lblLevelNumber.alpha = 1.0;
    
    [UIView commitAnimations];
}

- (IBAction)textClicked:(id)sender {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [self.pkrLevels setAlpha:1];
    //self.lblLevelNumber.alpha = 1.0;
    
    [UIView commitAnimations];}
- (IBAction)saveClicked:(id)sender {
    
    [[AppData sharedInstance] setShakeLevel:[NSString stringWithFormat:@"%i",currentLevel]];
    
    [UIHelper showMessage:@"Le niveau de tension shake a été enregistré"];
}

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) shouldAutorotate
{
    return NO;
}
- (IBAction)creditsClicked:(id)sender {
    [[FlowManager sharedInstance] showCreditsVC];
}
@end
