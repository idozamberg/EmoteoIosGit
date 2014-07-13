//
//  AppManager.m
//  iCare
//
//  Created by ido zamberg on 1/3/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import "AppManager.h"

@implementation AppManager

static AppManager* sharedManager;

+ (AppManager*) sharedInstance
{
    if (!sharedManager)
    {
        sharedManager = [AppManager new];
    }
    
    return sharedManager;
}

- (void) performStartupProcedures
{
    [self loadAllVideos];
    [self loadAllAudioFiles];
    [self loadUserDefaults];
    [self LoadStorms];
}

- (void) performShutDownProcedures
{
}

- (void) removeEmptyStorms
{
    // Removing empty storms
    for (Storm* currStorm in [AppData sharedInstance].stormsHistory)
    {
        if (currStorm.exercises.count == 0)
        {
            [[AppData sharedInstance].stormsHistory removeObject:currStorm];
        }
    }
   
   // [self saveStorms];
}

- (void) loadUserDefaults
{
    NSString* emergencyNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"emergency"];
    
    // Checking if it exist (first install)
    if (!emergencyNumber)
    {
        emergencyNumber = @"112";
    }
    
    // Setting in-app number
    [[AppData sharedInstance] setEmergencyNumber:emergencyNumber];
    
    NSString* defaultLevel = [[NSUserDefaults standardUserDefaults] objectForKey:@"level"];
    
    // Checking if it exist (first install)
    if (!defaultLevel)
    {
        defaultLevel = @"8";
    }
    
    // Setting in-app number
    [[AppData sharedInstance] setShakeLevel:defaultLevel];
    
    NSString* pinCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
    
    // Checking if it exist (first install)
    if (!pinCode)
    {
        pinCode = @"";
    }
    
    // Setting in-app number
    [[AppData sharedInstance] setPinCode:pinCode];    
    
}

- (void) loadAllAudioFiles
{
    AppData* data = [AppData sharedInstance];
    
    NSNumber* level7 = [NSNumber numberWithInt:7];
    
    NSMutableArray* audios7 = [NSMutableArray new];

    AudioFile* audio1 = [AudioFile new];
    audio1.fileName = @"eau.wav";
    audio1.title = @"EAU FROIDE";
    audio1.level = [NSNumber numberWithInteger:7];
    audio1.levels = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:7],[NSNumber numberWithInteger:8],[NSNumber numberWithInteger:9],[NSNumber numberWithInteger:10], nil];
    
    AudioFile* audio2 = [AudioFile new];
    audio2.fileName = @"apaisante.mp4";
    audio2.title = @"MUSIQUE APAISANTE";
    audio2.level = [NSNumber numberWithInteger:7];
    audio2.levels = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:7],[NSNumber numberWithInteger:8],[NSNumber numberWithInteger:9],[NSNumber numberWithInteger:10], nil];
    
    AudioFile* audio3 = [AudioFile new];
    audio3.fileName = @"body.m4v";
    audio3.title = @"BODY SCAN";
    audio3.level = [NSNumber numberWithInteger:7];
    audio3.levels = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:2],[NSNumber numberWithInteger:3],[NSNumber numberWithInteger:4],[NSNumber numberWithInteger:5],[NSNumber numberWithInteger:6], nil];
    
    AudioFile* audio4 = [AudioFile new];
    audio4.fileName = @"observation.m4v";
    audio4.title = @"OBSERVATION DE SOI";
    audio4.level = [NSNumber numberWithInteger:7];
    audio4.levels = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:2],[NSNumber numberWithInteger:3],[NSNumber numberWithInteger:4],[NSNumber numberWithInteger:5],[NSNumber numberWithInteger:6], nil];
    
    AudioFile* audio5 = [AudioFile new];
    audio5.fileName = @"marche.m4v";
    audio5.title = @"MARCHE";
    audio5.level = [NSNumber numberWithInteger:7];
    audio5.levels = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:2],[NSNumber numberWithInteger:3],[NSNumber numberWithInteger:4],[NSNumber numberWithInteger:5],[NSNumber numberWithInteger:6], nil];
    
    AudioFile* audio6 = [AudioFile new];
    audio6.fileName = @"respiration.m4v";
    audio6.title = @"RESPIRATION";
    audio6.level = [NSNumber numberWithInteger:7];
    audio6.levels = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:2],[NSNumber numberWithInteger:3],[NSNumber numberWithInteger:4],[NSNumber numberWithInteger:5],[NSNumber numberWithInteger:6], nil];
    
    AudioFile* audio7 = [AudioFile new];
    audio7.fileName = @"respirationC.m4v";
    audio7.title = @"RESPIRATION COUCHÉ";
    audio7.level = [NSNumber numberWithInteger:7];
    audio7.levels = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:2],[NSNumber numberWithInteger:3],[NSNumber numberWithInteger:4],[NSNumber numberWithInteger:5],[NSNumber numberWithInteger:6], nil];
    
    AudioFile* audio8 = [AudioFile new];
    audio8.fileName = @"morceaumix.m4v";
    audio8.title = @"MUSIQUE APAISANTE 2";
    audio8.levels = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:7],[NSNumber numberWithInteger:8],[NSNumber numberWithInteger:9],[NSNumber numberWithInteger:10], nil];
    
    
    [audios7 addObject:audio1];
    [audios7 addObject:audio2];
    [audios7 addObject:audio3];
    [audios7 addObject:audio4];
    [audios7 addObject:audio5];
    [audios7 addObject:audio6];
    [audios7 addObject:audio7];
    [audios7 addObject:audio8];
    
    //[data.audioFiles setObject:audios7 forKey:level7];
    
    [self createAudiosDictFromArray:audios7];
}

- (void) loadAllVideos
{
    AppData* data = [AppData sharedInstance];
    
    NSNumber* level8 = [NSNumber numberWithInt:8];
    
    NSMutableArray* videos8 = [NSMutableArray new];

    // Adding videos
    VideoFile* vdOne = [VideoFile new];
    vdOne.fileName = @"JZGB";
    vdOne.fileType = @"m4v";
    vdOne.title = @"EAU";
    vdOne.level = [NSNumber numberWithInt:8];
    vdOne.levels = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:7],[NSNumber numberWithInteger:8],[NSNumber numberWithInteger:9],[NSNumber numberWithInteger:10], nil];

    VideoFile* vdTwo = [VideoFile new];
    vdTwo.fileName = @"Ciel";
    vdTwo.fileType = @"m4v";
    vdTwo.title    = @"CIEL";
    vdTwo.level = [NSNumber numberWithInt:8];
    vdTwo.levels = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:7],[NSNumber numberWithInteger:8],[NSNumber numberWithInteger:9],[NSNumber numberWithInteger:10], nil];
    
    /*VideoFile* vdThree = [VideoFile new];
    vdThree.fileName = @"arbre";
    vdThree.fileType = @"m4v";
    vdThree.title    = @"ARBRE ET VENT";
    vdThree.level = [NSNumber numberWithInt:8];
    vdThree.levels = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:7],[NSNumber numberWithInteger:8],[NSNumber numberWithInteger:9],[NSNumber numberWithInteger:10], nil];*/
    
    VideoFile* vdFour = [VideoFile new];
    vdFour.fileName = @"fleur";
    vdFour.fileType = @"m4v";
    vdFour.title    = @"FLEURS";
    vdFour.level = [NSNumber numberWithInt:8];
    vdFour.levels = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:7],[NSNumber numberWithInteger:8],[NSNumber numberWithInteger:9],[NSNumber numberWithInteger:10], nil];
    
    VideoFile* vdFive = [VideoFile new];
    vdFive.fileName = @"pluie";
    vdFive.fileType = @"m4v";
    vdFive.title    = @"PLUIE";
    vdFive.level = [NSNumber numberWithInt:8];
    vdFive.levels = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:7],[NSNumber numberWithInteger:8],[NSNumber numberWithInteger:9],[NSNumber numberWithInteger:10], nil];
    
    VideoFile* vdSix = [VideoFile new];
    vdSix.fileName = @"VideoNN";
    vdSix.fileType = @"m4v";
    vdSix.title    = @"CHAMP";
    vdSix.level = [NSNumber numberWithInt:8];
    vdSix.levels = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:7],[NSNumber numberWithInteger:8],[NSNumber numberWithInteger:9],[NSNumber numberWithInteger:10], nil];

    
    // Adding videos to array
    [videos8 addObject:vdOne];
    [videos8 addObject:vdTwo];
    //[videos8 addObject:vdThree];
    [videos8 addObject:vdFour];
    [videos8 addObject:vdFive];
    [videos8 addObject:vdSix];

    // Adding array to dictionary
  //  [data.videos setObject:videos8 forKey:level8];
    [self createVideosDictFromArray:videos8];
    
}

- (void) deletePin
{
    [AppData sharedInstance].pinCode = Nil;
    [[NSUserDefaults standardUserDefaults] setObject:Nil forKey:@"pin"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) performGoingToBackgroundTasks
{
    [self removeEmptyStorms];
    [self saveStorms];
    [AppData sharedInstance].isInStorm = NO;
    
    [[FlowManager sharedInstance] showEnterPinVC:NO];

}

#pragma mark database

- (void) saveStorms
{
    [[AppData sharedInstance] saveStorms];
}

- (void) LoadStorms
{
    [[AppData sharedInstance] loadStorm];
}

#pragma mark data manipulation



- (void) createAudiosDictFromArray : (NSMutableArray*) audios
{
  
    AppData* data = [AppData sharedInstance];
    
    for (AudioFile* currFile in audios)
    {
        for (NSNumber* currLevel in currFile.levels)
        {
        // Getting exercises array
            NSMutableArray* levelArray = [data.audioFiles objectForKey:currLevel];
            
            // Check if we already created it
            if (levelArray == Nil)
            {
                levelArray = [NSMutableArray new];
                
            
                // Set the array inside the dictionary
                [data.audioFiles setObject:levelArray forKey:currLevel];
            }
            
            // Adding object to level
            [levelArray addObject:currFile];
        }
    }
}

- (void) createVideosDictFromArray : (NSMutableArray*) videos
{
    
    AppData* data = [AppData sharedInstance];
    
    for (VideoFile* currFile in videos)
    {
        for (NSNumber* currLevel in currFile.levels)
        {
            // Getting exercises array
            NSMutableArray* levelArray = [data.videos objectForKey:currLevel];
            
            // Check if we already created it
            if (levelArray == Nil)
            {
                levelArray = [NSMutableArray new];
                
                
                // Set the array inside the dictionary
                [data.videos setObject:levelArray forKey:currLevel];
            }
            
            // Adding object to level
            [levelArray addObject:currFile];
        }
    }
}
@end
