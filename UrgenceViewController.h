//
//  UrgenceViewController.h
//  iCare
//
//  Created by ido zamberg on 11/12/13.
//  Copyright (c) 2013 ido zamberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppData.h"
#import "SuperViewController.h"

@interface UrgenceViewController : SuperViewController
@property (weak, nonatomic) IBOutlet UIButton *btnUrgence;
@property (weak, nonatomic) IBOutlet UIButton *btnBackToMainPage;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
- (IBAction)backClicked:(id)sender;
- (IBAction)emergencyClicked:(id)sender;

@end
