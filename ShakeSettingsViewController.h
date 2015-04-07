//
//  ShakeSettingsViewController.h
//  iCare
//
//  Created by ido zamberg on 1/10/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppData.h"
#import "FlowManager.h"
#import "SuperViewController.h"

@interface ShakeSettingsViewController : SuperViewController <UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSInteger currentLevel;
}
@property (weak, nonatomic) IBOutlet UIPickerView *pkrLevels;
- (IBAction)textClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel;
- (IBAction)saveClicked:(id)sender;
- (IBAction)backClicked:(id)sender;
- (IBAction)creditsClicked:(id)sender;

@end
