//
//  RecentStormesViewController.m
//  iCare
//
//  Created by ido zamberg on 1/17/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import "RecentStormesViewController.h"
#import "StormCell.h"
#import "FlowManager.h"

@interface RecentStormesViewController ()

@end

@implementation RecentStormesViewController
{
    NSMutableArray* stormsWithExercises;
}

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

- (void) filterStorms
{
    stormsWithExercises = [NSMutableArray new];
    
    for (Storm* currStrom in [AppData sharedInstance].stormsHistory)
    {
        if (currStrom.exercises.count > 0)
        {
            [stormsWithExercises addObject:currStrom];
        }
    }

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Removing empty storms
    [self filterStorms];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return stormsWithExercises.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* STORM_CELL = @"StormCell";
    
    // Getting current storm
    Storm* currentStorm = [stormsWithExercises objectAtIndex:indexPath.row];
    
  
    
    StormCell* cell = [tableView dequeueReusableCellWithIdentifier:STORM_CELL];
    
    // Checking if we are reusing
    if (cell == Nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StormCell" owner:self options:nil] objectAtIndex:0];
    }
    
    if (currentStorm.exercises.count > 0)
    {
        Exercise* firstExercise = [currentStorm.exercises objectAtIndex:0];
        
        // Setting date
        cell.imgLevel.image = [UIImage imageNamed:[NSString stringWithFormat:@"dot%i.png",[firstExercise.level integerValue]]];
    }

    cell.lblDate.text = [NSString stringWithFormat:@"ÉVÈNEMENT DU %@", [DateTimeHelper getDate:currentStorm.date withDateFormat:@"dd.MM.yyyy"]];

    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        // Getting object to delete
        NSInteger objectIndex = [[AppData sharedInstance].stormsHistory indexOfObject:
                                 [stormsWithExercises objectAtIndex:indexPath.row]];
        
        [[AppData sharedInstance].stormsHistory removeObjectAtIndex:objectIndex];
        
        // Removing row from local array
        [stormsWithExercises removeObjectAtIndex:indexPath.row];
        
        // Remove rows from table
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [[AppData sharedInstance] saveStorms];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"EFFACER";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 29;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Getting selected storm
    Storm* selectedStorm = [stormsWithExercises objectAtIndex:indexPath.row];
    
    [[FlowManager sharedInstance] showStormDetailesForStorm:selectedStorm];
}


- (IBAction)emergencyClicked:(id)sender {
    [[FlowManager sharedInstance] showEmergencyVC];
}

- (BOOL) shouldAutorotate
{
    return NO;
}
@end
