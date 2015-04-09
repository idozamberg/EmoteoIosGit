//
//  RecentsChainsViewController.m
//  iCare
//
//  Created by ido zamberg on 4/7/15.
//  Copyright (c) 2015 ido zamberg. All rights reserved.
//

#import "RecentsChainsViewController.h"
#import "StormCell.h"
#import "FlowManager.h"
#import "MFSideMenu.h"


@interface RecentsChainsViewController ()

@end

@implementation RecentsChainsViewController
{
    NSMutableArray* allChains;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    allChains = [AppData sharedInstance].chainsHistory;
}

- (void) viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = MFSideMenuPanModeSideMenu;
}

- (void) viewWillDisappear:(BOOL)animated
{
     self.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allChains.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* STORM_CELL = @"StormCell";
    
    // Getting current chain
    EmotionalChain* currentChain = [allChains objectAtIndex:indexPath.row];
    
    StormCell* cell = [tableView dequeueReusableCellWithIdentifier:STORM_CELL];
    
    // Checking if we are reusing
    if (cell == Nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StormCell" owner:self options:nil] objectAtIndex:0];
    }
    
        
    // Setting date and tension image
    cell.imgLevel.image = [UIImage imageNamed:[NSString stringWithFormat:@"dot%i.png",[currentChain.tension integerValue]]];
    cell.lblDate.text = [NSString stringWithFormat:@"ÉVÈNEMENT DU %@", [DateTimeHelper getDate:currentChain.date withDateFormat:@"dd.MM.yyyy"]];
    
    
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
      
        [[AppData sharedInstance].chainsHistory removeObjectAtIndex:indexPath.row];
        
        // Remove rows from table
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [[AppData sharedInstance] saveChains];
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

    // Getting current chain and show it's resume
    EmotionalChain* currentChain = [allChains objectAtIndex:indexPath.row];
    [[FlowManager sharedInstance] showNotesResumeWithChain:currentChain];

}

- (BOOL) shouldAutorotate
{
    return NO;
}


@end
