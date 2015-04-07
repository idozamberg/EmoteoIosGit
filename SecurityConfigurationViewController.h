//
//  SecurityConfigurationViewController.h
//  iCare
//
//  Created by ido zamberg on 6/17/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

@interface SecurityConfigurationViewController : SuperViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnActive;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UITextField *txtPin;
@property (weak, nonatomic) IBOutlet UILabel *lblSave;

@property (nonatomic) BOOL isPinActive;

- (IBAction)activeClicked:(id)sender;
- (IBAction)saveClicked:(id)sender;
- (IBAction)backClicked:(id)sender;
- (IBAction)creditsClicked:(id)sender;

@end
