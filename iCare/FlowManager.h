//
//  FlowManager.h
//  iCare
//
//  Created by ido zamberg on 1/3/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExerciseListViewController.h"
#import "AudioVideoControllerViewController.h"
#import "MediaFile.h"
#import "VideoFile.h"
#import "AudioFile.h"
#import "Globals.h"
#import "MenuViewController.h"
#import "EmergencyCallSettingsViewController.h"
#import "ShakeSettingsViewController.h"
#import "RecentStormesViewController.h"
#import "StormDetailsViewController.h"
#import "CPTStormGraphViewController.h"
#import "UrgenceViewController.h"
#import "SecurityConfigurationViewController.h"
#import "THViewController.h"
#import "THPinViewController.H"
#import "CreditsViewController.h"
#import "TutorialViewController.h"
#import "SpecificInformationViewController.h"
#import "NoteViewController.h"
#import "NoteBehaviorViewController.h"
#import "EstimateFeelingViewController.h"
#import "CotationViewController.h"
#import "FeelingsViewController.h"
#import "RecentsChainsViewController.h"
#import "NotesResumeViewController.h"

@interface FlowManager : NSObject <THPinViewControllerDelegate>

+ (FlowManager*) sharedInstance;

typedef void(^BubblesCompletionBlock)();

- (void) showExerciseListWithList : (NSArray*) list forLevel : (NSNumber*) level andType :(exerciseListType) type;
- (void) showExerciseListWithList : (NSArray*) list forLevel : (NSNumber*) level andType :(exerciseListType) type WithColorTherapy : (BOOL) shouldShowColorTherapy;
- (void) showVideoViewControllerWithVideo : (VideoFile*) video WithBackgroundColor : (UIColor*) color;
- (void) showAudioViewControllerWithAudioFile : (AudioFile*) file withBackgroundColor : (UIColor*) color;
- (void) showInformationsViewControllerWithText : (NSString*) text andTitle : (NSString*) title;

- (void) showVideoViewControllerWithVideo : (VideoFile*) video;
- (void) showAudioViewControllerWithAudioFile : (AudioFile*) file;
- (void) showMenuVCWithType : (menuTableType) type;
- (void) showEmergencySettings;
- (void) showShakeVC;
- (void) showRecentStormsAnimated : (BOOL) animated;
- (void) showStormDetailesForStorm : (Storm*) storm;
- (void) showGraphForStorm : (Storm*) storm;
- (void) showEmergencyVC;
- (void) showPinConfigurationVCanimated : (BOOL) animated;
- (void) showEnterPinVC : (BOOL) animated;
- (void) showCreditsVC;
- (void) ShowTutorialVC;
- (void) showNoteVC;
- (void) showNoteBehaviorVC;
- (void) showEstimateViewController;
- (void) showCotationViewControllerWithCenterImage : (UIImage*) image andText : (NSString*) text andBubbleIndex : (NSInteger) mainIndex;
- (void) showFeelingsViewController;
- (void) showScaleVC;
- (void) showRecentChains;
- (void) showNotesResumeWithChain : (EmotionalChain*) chainSelected;

@property (strong,nonatomic) UIStoryboard* storyBoard;
@property (strong,nonatomic) UINavigationController* navigationController;

@end
