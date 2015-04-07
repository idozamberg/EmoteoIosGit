//
//  MenuViewController.h
//  iCare
//
//  Created by ido zamberg on 1/10/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Globals.h"
#import "FlowManager.h"
#import "SuperViewController.h"

@interface MenuViewController : SuperViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblMenu;
- (IBAction)menuClicked:(id)sender;

@property (nonatomic) menuTableType tableType;
- (id) initWithTableType : (menuTableType) type;
- (IBAction)creditsClicked:(id)sender;

@end
