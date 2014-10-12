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
    
    //[navigationController pushViewController:uVC animated:YES];
    
    //[navigationController presen];
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
    
    [navigationController popToRootViewControllerAnimated:NO];
    
    [navigationController pushViewController:vcLevel animated:YES];
}

- (void) showMenuVCWithType : (menuTableType) type
{
  //  MenuViewController
    
    MenuViewController* menuVC = [storyBoard instantiateViewControllerWithIdentifier:@"menuVC"];
    
    menuVC.tableType = type;
    
    [navigationController pushViewController:menuVC animated:YES];

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
    UIStoryboard* autoBoard = [UIStoryboard storyboardWithName:@"AutoLayoutBoard" bundle:nil];
    //stormsVC
    
    RecentStormesViewController* stormsVC = [autoBoard instantiateViewControllerWithIdentifier:@"stormsVC"];
    [stormsVC.tblRecents reloadData];
    
    [navigationController pushViewController:stormsVC animated:animated];
    
}

- (void) showStormDetailesForStorm : (Storm*) storm
{
    UIStoryboard* autoBoard = [UIStoryboard storyboardWithName:@"AutoLayoutBoard" bundle:nil];
    //stormsVC
    
    StormDetailsViewController* stormVC = [autoBoard instantiateViewControllerWithIdentifier:@"stormsDetVC"];
    [stormVC setCurrentStorm:storm];
    
    [navigationController pushViewController:stormVC animated:YES];
    
}

- (void) showGraphForStorm : (Storm*) storm
{
    UIStoryboard* autoBoard = [UIStoryboard storyboardWithName:@"AutoLayoutBoard" bundle:nil];
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
    UIStoryboard* autoBoard = [UIStoryboard storyboardWithName:@"AutoLayoutBoard" bundle:nil];

    
    CreditsViewController* credits = [autoBoard instantiateViewControllerWithIdentifier:@"creditsVC"];
    
    [navigationController pushViewController:credits animated:YES];
}

- (void) ShowTutorialVC
{
    UIStoryboard* autoBoard = [UIStoryboard storyboardWithName:@"AutoLayoutBoard" bundle:nil];
    
    
    TutorialViewController* tutorial = [autoBoard instantiateViewControllerWithIdentifier:@"tutorialVC"];
    
    [tutorial setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [navigationController presentViewController:tutorial animated:YES completion:Nil];
    
}

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
