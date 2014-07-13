//
//  SecurityConfigurationViewController.m
//  iCare
//
//  Created by ido zamberg on 6/17/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import "SecurityConfigurationViewController.h"
#import "AppData.h"
#import "AppManager.h"

@interface SecurityConfigurationViewController ()

@end

@implementation SecurityConfigurationViewController

@synthesize isPinActive = _isPinActive;

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
    
    _isPinActive = ( [AppData sharedInstance].pinCode != Nil && ![[AppData sharedInstance].pinCode isEqualToString:@""] )? YES:NO;
    
    self.txtPin.text = [AppData sharedInstance].pinCode;
    
    [self toggleButton];
    [self handleControls];
    
    self.btnSave.hidden = NO;
    self.txtPin.hidden = NO;
    self.lblSave.hidden = NO;
    
    // Do any additional setup after loading the view.
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

- (IBAction)activeClicked:(id)sender {
    
    _isPinActive = !_isPinActive;
    
    [self toggleButton];
    [self handleControls];
    
    if (!_isPinActive)
    {
        [[AppManager sharedInstance] deletePin];
        self.txtPin.text = @"";
    }

}

- (IBAction)saveClicked:(id)sender {
    
    if ([self.txtPin.text length] == 4)
    {
        [[AppData sharedInstance] setPinCode:self.txtPin.text];
    
        [UIHelper showMessage:@"LE PIN A ÉTÉ CONFIGURÉ CORRECTEMENT"];
        [self.txtPin resignFirstResponder];
    }
    else
    {
        [UIHelper showMessage:@"LE PIN DOIT ÊTRE CONSTRUI DE 4 CIFRES"];
    }
    
}

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)creditsClicked:(id)sender {
    [[FlowManager sharedInstance] showCreditsVC];
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txtPin resignFirstResponder];
}


- (void) toggleButton
{
    // Setting image
    if (_isPinActive)
    {
        [self.btnActive setBackgroundImage:[UIImage imageNamed:@"button_on"] forState:UIControlStateNormal];
        [self.btnActive setBackgroundImage:[UIImage imageNamed:@"button_on"] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.btnActive setBackgroundImage:[UIImage imageNamed:@"button_off"] forState:UIControlStateNormal];
        [self.btnActive setBackgroundImage:[UIImage imageNamed:@"button_off"] forState:UIControlStateHighlighted];
    }

}

- (void) handleControls
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    
    if (_isPinActive)
    {
        self.btnSave.alpha = 1;
        self.txtPin.alpha = 1;
        self.lblSave.alpha = 1;
    }
    else
    {
        self.btnSave.alpha = 0;
        self.txtPin.alpha = 0;
        self.lblSave.alpha = 0;
    }
    [UIView commitAnimations];
    
   // self.btnSave.hidden = !_isPinActive;
    //self.txtPin.hidden = !_isPinActive;
   // self.lblSave.hidden = !_isPinActive;
}

#pragma mark text field

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 4) ? NO : YES;
}

- (BOOL) shouldAutorotate
{
    return NO;
}

@end
