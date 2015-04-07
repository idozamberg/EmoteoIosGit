//
//  StormDetailsViewController.h
//  iCare
//
//  Created by ido zamberg on 1/17/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StormDetailCell.h"
#import "Exercise.h"
#import "AppData.h"
#import "Storm.h"
#import "SuperViewController.h"

@interface StormDetailsViewController : SuperViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgLevel;
@property (nonatomic,strong) Storm* currentStorm;
@property (weak, nonatomic) IBOutlet UITableView *tblDetailes;
- (IBAction)graphClicked:(id)sender;
- (IBAction)emergencyClicked:(id)sender;

@end
