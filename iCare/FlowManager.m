//
//  FlowManager.m
//  iCare
//
//  Created by ido zamberg on 1/3/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import "FlowManager.h"
#import "LevelViewController.h"


@implementation FlowManager

@synthesize storyBoard,navigationController;

static FlowManager* manager;

+ (FlowManager*) sharedInstance
{
    if (!manager)
    {
        manager = [FlowManager new];
        manager.storyBoard = [UIStoryboard storyboardWithName:@"NavigationBoard" bundle:nil];
        manager.navigationController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    return manager;
}

- (void) showEmergencyVC
{
    UrgenceViewController* uVC = [storyBoard instantiateViewControllerWithIdentifier:@"emergencyVC"];
    
    // Showing view controls
    [navigationController pushViewController:uVC animated:YES];
   // navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    //[navigationController presentViewController:uVC animated:YES completion:Nil];
}

- (void) showExerciseListWithList : (NSArray*) list forLevel : (NSNumber*) level andType :(exerciseListType) type
{
    ExerciseListViewController* vcExercise = [storyBoard instantiateViewControllerWithIdentifier:@"vcExercise"];
    
    vcExercise.shouldPerformColorTherapy = NO;
    
    // Setting vc properties
    vcExercise.exerciseList = list;
    vcExercise.listType = type;
    [vcExercise setLevel:level];
    
    [navigationController pushViewController:vcExercise animated:YES];
}

- (void) showExerciseListWithList : (NSArray*) list forLevel : (NSNumber*) level andType :(exerciseListType) type WithColorTherapy : (BOOL) shouldShowColorTherapy
{
    ExerciseListViewController* vcExercise = [storyBoard instantiateViewControllerWithIdentifier:@"vcExercise"];
    
    vcExercise.shouldPerformColorTherapy = shouldShowColorTherapy;
    
    if (shouldShowColorTherapy)
    {
        vcExercise.imgBg.hidden = YES;
    }
    else
    {
        vcExercise.imgBg.hidden = NO;
    }
    
    // Setting vc properties
    vcExercise.exerciseList = list;
    vcExercise.listType = type;
    [vcExercise setLevel:level];
    
    [navigationController pushViewController:vcExercise animated:YES];
}

- (void) showVideoViewControllerWithVideo : (VideoFile*) video
{
    // Go to next screen
    LevelViewController* vcLevel = [storyBoard instantiateViewControllerWithIdentifier:@"levelVC"];
    
    vcLevel.imgBg.hidden = NO;
    vcLevel.shouldPerformColorTherapy = NO;
    
    // Setting the video to load
    [vcLevel setVideo:video];
    
   // [navigationController popToRootViewControllerAnimated:NO];
    
    [navigationController pushViewController:vcLevel animated:YES];
    
}

- (void) showVideoViewControllerWithVideo : (VideoFile*) video WithBackgroundColor : (UIColor*) color
{
    // Go to next screen
    LevelViewController* vcLevel = [storyBoard instantiateViewControllerWithIdentifier:@"levelMenuVC"];
    
    // Setting bgcolor
    [vcLevel.view setBackgroundColor:color];
    
    vcLevel.shouldPerformColorTherapy = YES;
    
    vcLevel.imgBg.hidden = YES;
    
    // Setting the video to load
    [vcLevel setVideo:video];
    
    //[navigationController popToRootViewControllerAnimated:NO];
    
    [navigationController pushViewController:vcLevel animated:YES];
    
}

- (void) showAudioViewControllerWithAudioFile : (AudioFile*) file
{
    // Go to next screen
    AudioVideoControllerViewController* vcLevel = [storyBoard instantiateViewControllerWithIdentifier:@"audioVC"];
    
     vcLevel.shouldPerformColorTherapy = NO;
    
    [vcLevel setAudioFile:file];
    
  //  [navigationController popToRootViewControllerAnimated:NO];
    
    [navigationController pushViewController:vcLevel animated:YES];
}

- (void) showAudioViewControllerWithAudioFile : (AudioFile*) file withBackgroundColor : (UIColor*) color
{
    // Go to next screen
    AudioVideoControllerViewController* vcLevel = [storyBoard instantiateViewControllerWithIdentifier:@"audioMenuVC"];
    
    // Setting bgcolor
    [vcLevel.vwFrame setBackgroundColor:color];
    vcLevel.frameColor = color;
    
    vcLevel.shouldPerformColorTherapy = YES;
    
    vcLevel.imgBg.hidden = YES;
    
    [vcLevel setAudioFile:file];
    
  //  [navigationController popToRootViewControllerAnimated:NO];
    
    [navigationController pushViewController:vcLevel animated:YES];
}

- (void) showMenuVCWithType : (menuTableType) type
{
  //  MenuViewController
    
    MenuViewController* menuVC = [storyBoard instantiateViewControllerWithIdentifier:@"menuVC"];
    
    menuVC.tableType = type;
    
    [navigationController pushViewController:menuVC animated:YES];

}

- (void) showInformationsViewControllerWithText : (NSString*) text andTitle : (NSString*) title
{
    UIStoryboard* autoBoard = [UIStoryboard storyboardWithName:@"NavigationBoard" bundle:nil];

    SpecificInformationViewController* infoVC = [autoBoard instantiateViewControllerWithIdentifier:@"InformationVC"];
    
    // Setting text and title
    [infoVC setTextAndTitle:text andTitle:title];
    
    [navigationController pushViewController:infoVC animated:YES];
}

- (void) showEmergencySettings
{
    EmergencyCallSettingsViewController* ecVC = [storyBoard instantiateViewControllerWithIdentifier:@"emergencySettingsVC"];
    
    [navigationController pushViewController:ecVC animated:YES];

}

- (void) showShakeVC
{
    ShakeSettingsViewController* shakeVC = [storyBoard instantiateViewControllerWithIdentifier:@"shakeVC"];
    
    [navigationController pushViewController:shakeVC animated:YES];

}

- (void) showRecentStormsAnimated : (BOOL) animated
{
    UIStoryboard* autoBoard = [UIStoryboard storyboardWithName:@"NavigationBoard" bundle:nil];
    //stormsVC
    
    RecentStormesViewController* stormsVC = [autoBoard instantiateViewControllerWithIdentifier:@"stormsVC"];
    [stormsVC.tblRecents reloadData];
    
    [navigationController pushViewController:stormsVC animated:animated];
    
}

- (void) showStormDetailesForStorm : (Storm*) storm
{
    UIStoryboard* autoBoard = [UIStoryboard storyboardWithName:@"NavigationBoard" bundle:nil];
    //stormsVC
    
    StormDetailsViewController* stormVC = [autoBoard instantiateViewControllerWithIdentifier:@"stormsDetVC"];
    [stormVC setCurrentStorm:storm];
    
    [navigationController pushViewController:stormVC animated:YES];
    
}

- (void) showGraphForStorm : (Storm*) storm
{
    UIStoryboard* autoBoard = [UIStoryboard storyboardWithName:@"NavigationBoard" bundle:nil];
    //stormsVC
    
    CPTStormGraphViewController* stormVC = [autoBoard instantiateViewControllerWithIdentifier:@"graphVC"];
    [stormVC setCurrentStorm:storm];
    
    [navigationController pushViewController:stormVC animated:YES];

}

- (void) showPinConfigurationVCanimated : (BOOL) animated
{
    SecurityConfigurationViewController* vcPIN = [storyBoard instantiateViewControllerWithIdentifier:@"pinVC"];
    
    [navigationController pushViewController:vcPIN animated:animated];
}

- (void) showEnterPinVC : (BOOL) animated
{

    THPinViewController *pinViewController = [[THPinViewController alloc] initWithDelegate:self];
    pinViewController.promptTitle = @"PIN DE SECURITÉ";
    UIColor *darkBlueColor = [UIColor colorWithRed:0.3f green:0.80f blue:0.98f alpha:1.0f];
    pinViewController.promptColor = [UIColor whiteColor];
    pinViewController.view.tintColor = [UIColor whiteColor];
    
    // for a solid background color, use this:
    pinViewController.backgroundColor = darkBlueColor;
    
    [navigationController presentViewController:pinViewController animated:animated completion:nil];

}

- (void) showCreditsVC
{
    UIStoryboard* autoBoard = [UIStoryboard storyboardWithName:@"NavigationBoard" bundle:nil];

    
    CreditsViewController* credits = [autoBoard instantiateViewControllerWithIdentifier:@"creditsVC"];
    
    [navigationController pushViewController:credits animated:YES];
}

- (void) ShowTutorialVC
{
    UIStoryboard* autoBoard = [UIStoryboard storyboardWithName:@"AutoLayoutBoard" bundle:nil];
    
    TutorialViewController* tutorial = [autoBoard instantiateViewControllerWithIdentifier:@"tutorialVC"];
    
    [tutorial setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    // Create segue
    //UIStoryboardSegue* segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"tutorialVC" source:tutorial destination:navigationController];
    
    
    //[UIStoryboardSegue segueWithIdentifier:@"tutorialVC" source:[[navigationController viewControllers] objectAtIndex:0] destination:tutorial performHandler:Nil];

    //[segue perform];
    [navigationController presentViewController:tutorial animated:NO completion:Nil];
    //[navigationController presentModalViewController:tutorial animated:YES];
    
}


- (void) showNoteVC
{
   
    UIStoryboard* autoBoard = [UIStoryboard storyboardWithName:@"NavigationBoard" bundle:nil];
    
    NoteViewController* noteVC = [autoBoard instantiateViewControllerWithIdentifier:@"NoteViewController"];
    
    [navigationController pushViewController:noteVC animated:YES];
    
}

- (void) showEstimateViewController
{
    UIStoryboard* autoBoard = [UIStoryboard storyboardWithName:@"NavigationBoard" bundle:nil];
    
    EstimateFeelingViewController* noteVC = [autoBoard instantiateViewControllerWithIdentifier:@"EstimateFeelingViewController"];
    
    [navigationController pushViewController:noteVC animated:YES];
}

- (void) showFeelingsViewController
{
    UIStoryboard* autoBoard = [UIStoryboard storyboardWithName:@"NavigationBoard" bundle:nil];
    
    FeelingsViewController* noteVC = [autoBoard instantiateViewControllerWithIdentifier:@"FeelingsViewController"];
    
    [navigationController pushViewController:noteVC animated:YES];
}

- (void) showCotationViewController
{
    UIStoryboard* autoBoard = [UIStoryboard storyboardWithName:@"NavigationBoard" bundle:nil];
    
    CotationViewController* noteVC = [autoBoard instantiateViewControllerWithIdentifier:@"CotationViewController"];
    
    [navigationController pushViewController:noteVC animated:YES];
}


- (void) showNoteBehaviorVC
{
    
    UIStoryboard* autoBoard = [UIStoryboard storyboardWithName:@"NavigationBoard" bundle:nil];
    
    NoteBehaviorViewController* noteVC = [autoBoard instantiateViewControllerWithIdentifier:@"NoteBehaviorViewController"];
    
    [navigationController pushViewController:noteVC animated:YES];
 
}

//NoteBehaviorViewController
#pragma mark - THPinViewControllerDelegate

- (NSUInteger)pinLengthForPinViewController:(THPinViewController *)pinViewController
{
    return 4;
}

- (BOOL)pinViewController:(THPinViewController *)pinViewController isPinValid:(NSString *)pin
{
    if ([pin isEqualToString:[AppData sharedInstance].pinCode])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PinEntered" object:Nil];
        return YES;
    } else {
        return NO;
    }
}


- (BOOL)userCanRetryInPinViewController:(THPinViewController *)pinViewController
{
    return YES;
}

- (void)incorrectPinEnteredInPinViewController:(THPinViewController *)pinViewController
{
    
}

- (void)pinViewControllerWillDismissAfterPinEntryWasSuccessful:(THPinViewController *)pinViewController
{
}

- (void)pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:(THPinViewController *)pinViewController
{
   }

- (void)pinViewControllerWillDismissAfterPinEntryWasCancelled:(THPinViewController *)pinViewController
{
    [navigationController popViewControllerAnimated:NO];
}


@end
