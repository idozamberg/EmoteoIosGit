//
//  RecentsChainsViewController.h
//  iCare
//
//  Created by ido zamberg on 4/7/15.
//  Copyright (c) 2015 ido zamberg. All rights reserved.
//

#import "SuperViewController.h"
#import "EmotionalChain.h"

@interface RecentsChainsViewController : SuperViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblChains;

@end
