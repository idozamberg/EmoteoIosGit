//
//  SpecificInformationViewController.h
//  iCare
//
//  Created by ido zamberg on 1/12/15.
//  Copyright (c) 2015 ido zamberg. All rights reserved.
//

#import "ViewController.h"

@interface SpecificInformationViewController : ViewController


- (void) setTextAndTitle : (NSString*) text andTitle : (NSString*) title;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextView *tvInformationText;
@property (strong,nonatomic) NSString* questionTitle;
@property (strong,nonatomic) NSString* text;

- (IBAction)backClicked:(id)sender;
- (IBAction)emergencyClicked:(id)sender;

@end
