//
//  ExerciseListViewController.h
//  iCare
//
//  Created by ido zamberg on 1/3/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import "ViewController.h"
#import "ExerciseCell.h"
#import "FlowManager.h"
#import "Globals.h"
#import "SuperViewController.h"

@interface ExerciseListViewController : SuperViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblExercises;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel;
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;
@property (weak, nonatomic) IBOutlet UIView *vwFrame;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic) BOOL shouldPerformColorTherapy;
@property (strong, nonatomic) NSArray* exerciseList;
@property (nonatomic)         exerciseListType listType;

- (IBAction)backClicked:(id)sender;
- (void) setLevel : (NSNumber*) numLevel;
- (IBAction)emergencyClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *backClicked;

@end
