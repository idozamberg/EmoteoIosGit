//
//  EmergencyCallSettingsViewController.h
//  iCare
//
//  Created by ido zamberg on 1/10/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppData.h"
#import "FlowManager.h"
#import "SuperViewController.h"

@interface EmergencyCallSettingsViewController : SuperViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtNumber;
- (IBAction)backClicked:(id)sender;
- (IBAction)creditsClicked:(id)sender;

@end
