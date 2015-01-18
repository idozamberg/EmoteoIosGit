//
//  TutorialManager.m
//  iCare
//
//  Created by ido zamberg on 7/17/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import "TutorialManager.h"
#define MAX_TUTORIAL_TIMES 5

@implementation TutorialManager
@synthesize tutorial;

static TutorialManager* manager;

+ (TutorialManager*) sharedInstance
{
    if (!manager)
    {
        manager = [TutorialManager new];
    }
    
    return manager;
}

- (BOOL) shouldShowTutorial
{
    NSNumber* tutorialShownTimes = [[NSUserDefaults standardUserDefaults] objectForKey:@"TutorialShown"];
  
    if ([tutorialShownTimes integerValue] < MAX_TUTORIAL_TIMES)
    {
        return (YES);
    }
    
    return NO;
}

- (void) setTutorialShown
{
    NSNumber* tutorialShownTimes = [[NSUserDefaults standardUserDefaults] objectForKey:@"TutorialShown"];
    
    // Adding one to number of times shown
    tutorialShownTimes = [NSNumber numberWithInteger:  [tutorialShownTimes integerValue] + 1];
    
    // Saving object
    [[NSUserDefaults standardUserDefaults] setObject:tutorialShownTimes forKey:@"TutorialShown"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) showTutorial
{
    // Show tutorial only at app load and only when needed
    if ([self shouldShowTutorial] && ! [AppData sharedInstance].wasTutorialShown)
    {
        [AppData sharedInstance].wasTutorialShown = YES;
        //[[FlowManager sharedInstance] ShowTutorialVC];
        
        self.tutorial.alpha = 1;

    
        [self setTutorialShown];
    }
}



@end
