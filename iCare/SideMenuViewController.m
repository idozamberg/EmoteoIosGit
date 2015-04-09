//
//  SideMenuViewController.m
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import "SideMenuViewController.h"
#import "MFSideMenu.h"
#import "SideMenuTableViewCell.h"
#import "SideMenuHeader.h"
#import "FlowManager.h"

@implementation SideMenuViewController

#pragma mark -
#pragma mark - UITableViewDataSource

# pragma mark macro menu
#define HOME_ROW 0
#define REGLAGES_ROW 1
#define EXERCISES 2
#define STORMS_RECENT 3
#define INFORMATIONS 4

#pragma mark macro home
#define ECHELLE 0
#define URGENCE 1

# pragma mark macro settings
#define SECURITE 0
#define URGENCY 1
#define SHAKE 2

#pragma mark macro exercies
#define AUDIO 0
#define VIDEO 1

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    switch (section) {
        case REGLAGES_ROW:
            return @"PARAMÈTRES";
            break;
        case EXERCISES:
            return @"EXERCICES";
            break;
        case STORMS_RECENT:
            return @"DONNÉES";
            break;
        case INFORMATIONS:
            return @"INFORMATIONS";
            break;
        default:
            ;
            break;
    }
 
    return @"";
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (void) viewWillAppear:(BOOL)animated
{
    //[self.tableView setHeight:(44*10) + (40*5)];
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    switch (section) {
        case HOME_ROW:
            return 2;
        case REGLAGES_ROW:
            return 3;
            break;
        case EXERCISES:
            return 2;
            break;
        case STORMS_RECENT:
            return 2;
            break;
        case INFORMATIONS:
            return 2;
            break;
        default:
            ;
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SideCell";
    
    SideMenuTableViewCell * cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[SideMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
   
    
    switch (indexPath.section) {
        case HOME_ROW:
            if (indexPath.row == 0)
            {
                cell.lblTitle.text = @"ÉCHELLE DE TENSION";
                [cell.imgIcon setImage:[UIImage imageNamed:@"Ladder-100"]];
            }
            else
            {
                cell.lblTitle.text = @"APPEL D'URGENCE";
                [cell.imgIcon setImage:[UIImage imageNamed:@"Phone-100"]];
            }
            break;
        case REGLAGES_ROW:
            if (indexPath.row == SECURITE)
            {
                cell.lblTitle.text = @"SECURITÉ";
                [cell.imgIcon setImage:[UIImage imageNamed:@"Key-100"]];
            }
            else if (indexPath.row == URGENCY)
            {
                cell.lblTitle.text = @"APPEL D'URGENCE";
                [cell.imgIcon setImage:[UIImage imageNamed:@"Ambulance-100"]];

            }
            else if (indexPath.row == SHAKE)
            {
                cell.lblTitle.text = @"SHAKE";
                [cell.imgIcon setImage:[UIImage imageNamed:@"shake"]];

            }
            break;
        case EXERCISES:
            if (indexPath.row == 0)
            {
                cell.lblTitle.text = @"AUDIO";
                [cell.imgIcon setImage:[UIImage imageNamed:@"Treble Clef-100"]];
            }
            else
            {
                cell.lblTitle.text = @"VIDEO";
                [cell.imgIcon setImage:[UIImage imageNamed:@"Video Camera-100"]];
            }
            break;
        case STORMS_RECENT:
            
            if (indexPath.row == 0)
            {
                cell.lblTitle.text = @"RÉSUMÉ TENSION";
                [cell.imgIcon setImage:[UIImage imageNamed:@"Line Chart-100"]];
            }
            else
            {
                cell.lblTitle.text = @"RÉSUMÉ OBSERVATION";
                [cell.imgIcon setImage:[UIImage imageNamed:@"Link-100-2"]];
            }
            
            break;
        case INFORMATIONS:
            if (indexPath.row == 0)
            {
                cell.lblTitle.text = @"À PROPOS DE CETTE APPLICATION";
                [cell.imgIcon setImage:[UIImage imageNamed:@"Faq-100"]];
            }
            else
            {
                cell.lblTitle.text = @"CRÉDITS";
                [cell.imgIcon setImage:[UIImage imageNamed:@"Good Quality-100"]];
            }
            break;
        default:
            ;
            break;
    }

    return cell;
}

- (SideMenuHeader*) getHeaderView
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * controller = [storyBoard instantiateViewControllerWithIdentifier:@"SideMenuHeader"];
    
    SideMenuHeader * vw = (SideMenuHeader*)controller.view;
    return vw;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SideMenuHeader* headerView = [self getHeaderView];
    
    // Setting headers
    switch (section) {
        case HOME_ROW:
            headerView.lblTitle.text = @"ACCUEIL";
            [headerView.imgMenu setImage:[UIImage imageNamed:@"Home-100"]];
            break;
        case REGLAGES_ROW:
            headerView.lblTitle.text = @"PARAMÈTRES";
            [headerView.imgMenu setImage:[UIImage imageNamed:@"Settings-100-2"]];
            break;
        case EXERCISES:
            headerView.lblTitle.text =  @"EXERCICES";
            [headerView.imgMenu setImage:[UIImage imageNamed:@"Meditation Guru-100-2"]];

            break;
        case STORMS_RECENT:
            headerView.lblTitle.text =  @"JOURNAL";
            [headerView.imgMenu setImage:[UIImage imageNamed:@"Literature-100"]];

            break;
        case INFORMATIONS:
            headerView.lblTitle.text =  @"INFORMATIONS";
            [headerView.imgMenu setImage:[UIImage imageNamed:@"About-100"]];

            break;
        default:
            ;
            break;
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.section != STORMS_RECENT)
    {
         self.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
    }
    
    switch (indexPath.section) {
        case HOME_ROW:
            if (indexPath.row == ECHELLE)
            {
                [[FlowManager sharedInstance] showScaleVC];
            }
            else
            {
                [[FlowManager sharedInstance] showEmergencyVC];
            }
            break;
        case REGLAGES_ROW:
            if (indexPath.row == SECURITE)
            {
                if ([AppData sharedInstance].pinCode == Nil || [[AppData sharedInstance].pinCode isEqualToString:@""])
                {
                    [[FlowManager sharedInstance] showPinConfigurationVCanimated:YES];
                }
                else
                {
                    [[FlowManager sharedInstance] showPinConfigurationVCanimated:NO];
                    [[FlowManager sharedInstance] showEnterPinVC:YES];
                }

            }
            else if (indexPath.row == URGENCY)
            {
              
                [[FlowManager sharedInstance] showEmergencySettings];
            }
            else if (indexPath.row == SHAKE)
            {
                [[FlowManager sharedInstance] showShakeVC];
            }
            break;
            
        case EXERCISES:
           
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

            break;
        case STORMS_RECENT:
            // Reset level
            [AppData sharedInstance].currentLevel = 0;
            
            if ([AppData sharedInstance].pinCode == Nil || [[AppData sharedInstance].pinCode isEqualToString:@""])
            {
                if (indexPath.row == 0)
                {
                    [[FlowManager sharedInstance] showRecentStormsAnimated:YES];
                }
                else
                {
                    [[FlowManager sharedInstance] showRecentChains];
                }
            }
            else
            {
                if (indexPath.row == 0)
                {
                    [[FlowManager sharedInstance] showRecentStormsAnimated:NO];
                }
                else
                {
                    [[FlowManager sharedInstance] showRecentChains];
                }
                
                [[FlowManager sharedInstance] showEnterPinVC:YES];
            }

            break;
        case INFORMATIONS:
            if (indexPath.row == 0)
            {
                [[FlowManager sharedInstance] showMenuVCWithType:menuTableInformations];
            }
            else
            {
                // Showing credits
                [[FlowManager sharedInstance] showCreditsVC];
            }
            break;
        default:
            ;
            break;
    }
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

@end