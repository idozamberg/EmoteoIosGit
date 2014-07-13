//
//  RecentStormesViewController.h
//  iCare
//
//  Created by ido zamberg on 1/17/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppData.h"
#import "Exercise.h"

@interface RecentStormesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblRecents;
- (IBAction)backClicked:(id)sender;
- (IBAction)emergencyClicked:(id)sender;

@end
