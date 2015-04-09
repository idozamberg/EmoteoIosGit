//
//  SuperViewController.h
//  iCare
//
//  Created by ido zamberg on 4/5/15.
//  Copyright (c) 2015 ido zamberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppData.h"

@interface SuperViewController : UIViewController
- (IBAction)menuClicked:(id)sender;
- (IBAction)backClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@end
