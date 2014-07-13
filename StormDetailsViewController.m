//
//  StormDetailsViewController.m
//  iCare
//
//  Created by ido zamberg on 1/17/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import "StormDetailsViewController.h"
#import "FlowManager.h"

@interface StormDetailsViewController ()

@end

@implementation StormDetailsViewController
@synthesize currentStorm = _currentStorm;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    if (_currentStorm.exercises.count > 0)
    {
        // Getting first exercise
        Exercise* firstExercise = [_currentStorm.exercises objectAtIndex:0];
        
        // Setting title
        self.lblDate.text = [NSString stringWithFormat:@"ÉVÈNEMENT DU %@", [DateTimeHelper getDate:_currentStorm.date withDateFormat:@"dd.MM.yyyy"]];
        self.imgLevel.image = [UIImage imageNamed:[NSString stringWithFormat:@"dot%i.png",[firstExercise.level integerValue]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currentStorm.exercises.count;
}

- (void) setCurrentStorm:(Storm *)currentStorm
{
    _currentStorm = currentStorm;
    
    [self.tblDetailes reloadData];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* STORM_DET_CELL = @"StormDetCell";
    
    // Getting current exercise
    Exercise* currentExerice = [_currentStorm.exercises objectAtIndex:indexPath.row];
    
    StormDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:STORM_DET_CELL];
    
    // Checking if we are reusing
    if (cell == Nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StormDetailCell" owner:self options:nil] objectAtIndex:0];
    }
    
    // Setting date
    cell.lblTime.text = [NSString stringWithFormat:@"%@", [DateTimeHelper getDate:currentExerice.practiceTime withDateFormat:@"HH:mm:ss"]];
    cell.imgLevel.image = [UIImage imageNamed:[NSString stringWithFormat:@"dot%i.png",[currentExerice.level integerValue]]];
    cell.lblName.text = currentExerice.name;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}


- (IBAction)graphClicked:(id)sender {
    [[FlowManager sharedInstance] showGraphForStorm:self.currentStorm];;
}
- (IBAction)emergencyClicked:(id)sender {
    [[FlowManager sharedInstance] showEmergencyVC];
}

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) shouldAutorotate
{
    return NO;
}

@end
