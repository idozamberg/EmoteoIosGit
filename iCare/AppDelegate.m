//
//  AppDelegate.m
//  iCare
//
//  Created by ido zamberg on 08/12/13.
//  Copyright (c) 2013 ido zamberg. All rights reserved.
//

#import "AppDelegate.h"
#import "AppManager.h"
#import "AppData.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AnalyticsManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Show Splash
    [self showSplashWithDuration:2];
    
    // Init Analytics manager
    [[AnalyticsManager sharedInstance] setUpAnalyticsCollectors];
    
    // Loading videos
    [[AppManager sharedInstance] performStartupProcedures];
    
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //[[AppManager sharedInstance] performGoingToBackgroundTasks];
    
    UINavigationController* mainNav = (UINavigationController *)self.window.rootViewController;
    
    [mainNav popToRootViewControllerAnimated:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [AppData sharedInstance].shouldEvaluateTension = NO;

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [AppData sharedInstance].shouldEvaluateTension = NO;

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[AppManager sharedInstance] performShutDownProcedures];
}

- (void)showSplashWithDuration:(CGFloat)duration
{
    // add splash screen subview ...
    
    UIImage *image          = [UIImage imageNamed:@"splashBig.png"];
    UIImageView *splash     = [[UIImageView alloc] initWithImage:image];
    splash.frame            = self.window.bounds;
    splash.autoresizingMask = UIViewAutoresizingNone;
    [self.window addSubview:splash];
    
    
    // block thread, so splash will be displayed for duration ...
    
    CGFloat fade_duration = (duration >= 0.5f) ? 0.5f : 0.0f;
    [NSThread sleepForTimeInterval:duration - fade_duration];
    
    
    // animate fade out and remove splash from superview ...
    
    [UIView animateWithDuration:fade_duration animations:^ {
        splash.alpha = 0.0f;
    } completion:^ (BOOL finished) {
        [splash removeFromSuperview];
    }];
}
@end
