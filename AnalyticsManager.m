//
//  AnalyticsManager.m
//  365Scores
//
//  Created by ido zamberg on 4/5/13.
//  Copyright (c) 2013 for-each. All rights reserved.
//

#import "AnalyticsManager.h"
#import "GAIDictionaryBuilder.h"


@implementation AnalyticsManager
@synthesize googleParameters,flurryParameters,sendToFlurry,sendToGoogle,sendToUserVod;

static AnalyticsManager* theManager = nil;

+ (AnalyticsManager*) sharedInstance
{
    @synchronized (theManager)
    {
        if (theManager== nil)
        {
            theManager = [[AnalyticsManager alloc] init];
        }
    }
    
    return theManager;
}

- (void) setUpAnalyticsCollectors
{
    
    [Flurry setCrashReportingEnabled:YES];
    
    // If it's production
    // 2ZD3DGCZQKDSPYPZNSB3
       //2ZD3DGCZQKDSPYPZNSB3
    // Testing
    //NXJWC6WPMXSDZ6YYRQ49
    // Replace YOUR_API_KEY with the api key in the downloaded package
    [Flurry startSession:@"NXJWC6WPMXSDZ6YYRQ49"];
    //
    //PTRVWW6XGBKCHSTN78WM - ADHD
    // 2ZD3DGCZQKDSPYPZNSB3 - PROD
  
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [GAI sharedInstance].defaultTracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-52505827-1"];

}


// Functions clears all parameters - should be invoked after each time we use the glass
// in order for the next use will be with correct parameters
- (void) ClearAllParameters
{
    flurryParameters = Nil;
    googleParameters = Nil;
    sendToGoogle = NO;
    sendToUserVod = NO;
    sendToFlurry = NO;
}

// cooladata even is screen_name with property defining the actual name which is based on the category
-(void) CreateCoolaDataEventFromCategory:(NSString*)category WithName:(NSString*)name
{
   }

- (void) sendEventWithName : (NSString*) eventName Category : (NSString*) category Label: (NSString*) label
{
    
    if (sendToFlurry)
    {
        // Sending event to flurry
        if (!flurryParameters)
        {
            [Flurry logEvent:[NSString stringWithFormat:@"%@ %@", category ,eventName]];
        }
        else
        {
            // Sending with parameters
            [Flurry logEvent:[NSString stringWithFormat:@"%@ %@", category ,eventName] withParameters:flurryParameters];
        }
        
        NSLog(@"\n[FLURRY] CATEGORY: %@\t EVENT: %@", category ,eventName);
        
    }
    
    if (sendToGoogle)
    {
        // Sending event to google analytics
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder
                                                    createEventWithCategory:category
                                                    // Event category (required)
                                                    action:eventName  // Event action (required)
                                                    label:label          // Event label
                                                    value:googleParameters] build]];    // Event value
        
        NSLog(@"\n[GOOGLE] CATEGORY: %@\t EVENT: %@\tLABEL: %@\n", category ,eventName, label);
    }
    
  
    
    [self ClearAllParameters];
}

@end
