//
//  MenuViewController.m
//  iCare
//
//  Created by ido zamberg on 1/10/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import "MenuViewController.h"
#import "ExerciseCell.h"

@implementation MenuViewController
{
    NSMutableArray* questionsArray;
    NSMutableArray* informationArray;
}

@synthesize tableType = _tableType;


# pragma mark macro menu
#define REGLAGES_ROW 0
#define EXERCISES 1
#define STORMS_RECENT 2
#define INFORMATIONS 3


# pragma mark macro settings
#define SECURITE 0
#define URGENCY 1
#define SHAKE 2

#pragma mark macro exercies
#define AUDIO 0
#define VIDEO 1



- (id) init
{
    self = [super init];
    
    if (self)
    {
        _tableType = menuTablePrincipal;
    }
    
    return self;
}

- (id) initWithTableType : (menuTableType) type
{
    self = [super init];
    
    if (self)
    {
        _tableType = type;
    }
    
    return self;
}

- (IBAction)creditsClicked:(id)sender {
    [[FlowManager sharedInstance] showCreditsVC];
}

- (void) viewDidLoad{
    [self.tblMenu reloadData];
    
    [AppData sharedInstance].currentLevel = 0;

    
    // Waiting for pin entry
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPinConfiguration) name:@"PinEntered" object:Nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.tblMenu reloadData];
    
    // If we are informations mode
    if (_tableType == menuTableInformations)
    {
        // Load arrays
        [self loadInformationsArrays];
    }
   
}

- (void) loadInformationsArrays
{
    // Getting the dictionary
    NSDictionary* infoDictionary = [UIHelper dictionaryFromPlistWithName:@"InformationsList"];
    
    // Getting arrays form dictionary
    questionsArray = [infoDictionary objectForKey:@"Questions"];
    informationArray = [infoDictionary objectForKey:@"Informations"];
    
}
# pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableType == menuTablePrincipal)
    {
        return 4;
    }
    else if (_tableType == menuTableSettings)
    {
        return 3;
    }
    else if (_tableType == menuTableExercises)
    {
        return 2;
    }
    else if (_tableType == menuTableInformations)
    {
        return 7;
    }
    
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* EXERCISE_CELL = @"ExerciseCell";
    
    
    ExerciseCell* cell = [tableView dequeueReusableCellWithIdentifier:EXERCISE_CELL];
    
    // Checking if we are reusing
    if (cell == Nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExerciseCell" owner:self options:nil] objectAtIndex:0];
        
    }
    
    // Pricipal menu
    if (_tableType == menuTablePrincipal)
    {
        switch (indexPath.row) {
            case REGLAGES_ROW:
                cell.lblName.text = @"PARAMÈTRES";
                break;
            case EXERCISES:
                cell.lblName.text = @"EXERCICES";
                break;
            case STORMS_RECENT:
                cell.lblName.text = @"DONNÉES";
                break;
            case INFORMATIONS:
                cell.lblName.text = @"INFORMATIONS";
                break;
            default:
                break;
        }
    }
    // Settings
    else if (_tableType == menuTableSettings)
    {
        switch (indexPath.row) {
            case SECURITE:
                cell.lblName.text = @"SECURITÉ";
                break;
            case URGENCY:
                cell.lblName.text = @"APPEL D'URGENCE";
                break;
            case SHAKE:
                cell.lblName.text = @"SHAKE";
                break;
            default:
                break;
        }
    }
    else if (_tableType == menuTableExercises)
    {
        
        switch (indexPath.row) {
            case 0:
                cell.lblName.text = @"AUDIO";
                break;
            case 1:
                cell.lblName.text = @"VIDEO";
                break;
            default:
                break;
        }
    }
    else if (_tableType == menuTableInformations)
    {
        // Changing font size
        [cell.lblName setFont:[UIFont fontWithName:@"ITCAvantGardeMM" size:12]];
        
        // Setting question
        cell.lblName.text = [questionsArray objectAtIndex:indexPath.row];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (_tableType == menuTablePrincipal)
    {
        switch (indexPath.row) {
            case REGLAGES_ROW:
                [[FlowManager sharedInstance] showMenuVCWithType:menuTableSettings];
                break;
            case EXERCISES:
                [AppData sharedInstance].currentLevel = 0;
                [[FlowManager sharedInstance] showMenuVCWithType:menuTableExercises];
                break;
            case STORMS_RECENT:
                
                // Reset level
                [AppData sharedInstance].currentLevel = 0;
                
                if ([AppData sharedInstance].pinCode == Nil || [[AppData sharedInstance].pinCode isEqualToString:@""])
                {
                    [[FlowManager sharedInstance] showRecentStormsAnimated:YES];
                }
                else
                {
                    [[FlowManager sharedInstance] showRecentStormsAnimated:NO];
                    [[FlowManager sharedInstance] showEnterPinVC:YES];
                }
                break;
            case INFORMATIONS:
                [[FlowManager sharedInstance] showMenuVCWithType:menuTableInformations];
                break;
            default:
                break;
        }
    }
    else if (_tableType == menuTableSettings)
    {
        switch (indexPath.row) {
            case SECURITE:
                if ([AppData sharedInstance].pinCode == Nil || [[AppData sharedInstance].pinCode isEqualToString:@""])
                {
                    [[FlowManager sharedInstance] showPinConfigurationVCanimated:YES];
                }
                else
                {
                    [[FlowManager sharedInstance] showPinConfigurationVCanimated:NO];
                    [[FlowManager sharedInstance] showEnterPinVC:YES];
                }
                break;
            case URGENCY:
                [[FlowManager sharedInstance] showEmergencySettings];
                break;
            case SHAKE:
                [[FlowManager sharedInstance] showShakeVC];
                break;
            default:
                break;
        }

    }
    else if (_tableType == menuTableExercises)
    {
        switch (indexPath.row) {
            case AUDIO:
                [[FlowManager sharedInstance] showExerciseListWithList:[[AppData sharedInstance] getAllAudios] forLevel:Nil andType:audioType WithColorTherapy:YES];
                break;
            case VIDEO:
                [[FlowManager sharedInstance] showExerciseListWithList:[[AppData sharedInstance] getAllVideos] forLevel:Nil andType:videoType WithColorTherapy:YES];
                break;
            default:
                break;
        }
    }
    else if (_tableType == menuTableInformations)
    {
        // Getting title and text
        NSString* question = [questionsArray objectAtIndex:indexPath.row];
        NSString* information = [informationArray objectAtIndex:indexPath.row];
        
        // Showing info
        [[FlowManager sharedInstance] showInformationsViewControllerWithText:information andTitle:question];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 29;
}


- (void) setTableType:(menuTableType)newTableType
{
    _tableType = newTableType;
    
    [self.tblMenu reloadData];
}


- (void) showPinConfiguration
{
 //   [[FlowManager sharedInstance] showPinConfigurationVC];

}

- (BOOL) shouldAutorotate
{
    return NO;
}
@end
