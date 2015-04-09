//
//  AppData.m
//  iCare
//
//  Created by ido zamberg on 20/12/13.
//  Copyright (c) 2013 ido zamberg. All rights reserved.
//

#import "AppData.h"

@implementation AppData

static AppData* shareData;

@synthesize shouldEvaluateTension,videos,audioFiles,chainsHistory;
@synthesize emergencyNumber = _emergencyNumber;
@synthesize shakeLevel = _shakeLevel;
@synthesize pinCode = _pinCode;
@synthesize isInStorm;
@synthesize currentLevel,wasTutorialShown;

+ (AppData*) sharedInstance
{
    if (!shareData)
   {
       shareData = [AppData new];
            
       shareData.shouldEvaluateTension = NO;
       shareData.videos = [NSMutableDictionary new];
       shareData.audioFiles = [NSMutableDictionary new];
       shareData.stormsHistory = [NSMutableArray new];
       shareData.chainsHistory = [NSMutableArray new];
       shareData.isInStorm = NO;
       shareData.currentLevel = 0;
   }
    
    return shareData;
}

- (NSArray*) getVideosForLevel : (NSNumber*) level
{
    return [videos objectForKey:level];
}

- (NSArray*) getAllVideos
{
    NSMutableArray* allVideos = [NSMutableArray new];
    
    for (NSArray* currectLevelArray in [videos allValues])
    {
        for (VideoFile* currentVideo in currectLevelArray)
        {
            // Addding video if doesnt exist
            if (![allVideos containsObject:currentVideo])
            {
                [allVideos addObject:currentVideo];
            }
        }
    }
    
    return allVideos;
}

- (NSArray*) getAllAudios
{
    NSMutableArray* allAudios = [NSMutableArray new];
    
    for (NSArray* currectLevelArray in [audioFiles allValues])
    {
        for (VideoFile* currentVideo in currectLevelArray)
        {
            // Addding video if doesnt exist
            if (![allAudios containsObject:currentVideo])
            {
                [allAudios addObject:currentVideo];
            }
        }
    }
    
    return allAudios;
}



// This function will create a new storm and return it
- (Storm*) addNewStorm
{
    //  Adding new storm to array
    Storm* newStorm = [Storm new];
    
    // Set storm's date
    newStorm.date = [NSDate date];
    
    // Add to history
    [self.stormsHistory addObject:newStorm];
    
    // Saving Storms
    [self saveStorms];
    
    
    return newStorm;
}

// This function will create a new storm and return it
- (EmotionalChain*) addNewEmotionalChain
{
    //  Adding new storm to array
    EmotionalChain* newChain = [EmotionalChain new];
    
    // Set storm's date and tension level
    newChain.date = [NSDate date];
    newChain.tension = [NSNumber numberWithInteger:self.currentLevel];
    
    // Add to history
    [self.chainsHistory addObject:newChain];
    
    // Saving Storms TODO
   // [self saveStorms];
    
    return newChain;
}

- (void) addNewChain : (EmotionalChain*) chain;
{
    [self.chainsHistory addObject:chain];
    
    // TODO - SAVE
}

- (NSMutableArray*) getExerciseListForLevel : (NSNumber*) level
{
    // Getting all videos
    NSMutableArray* allExercises = [NSMutableArray arrayWithArray:[self getVideosForLevel:level]];
    
    // Gettting all audio
    NSArray* allAudios = [self getAudiosForLevel:level];
    
    // Joining together
    [allExercises addObjectsFromArray:allAudios];
    
    return allExercises;
}

- (NSArray*) getAudiosForLevel : (NSNumber*) level
{
    return [audioFiles objectForKey:level];
}

- (void) setEmergencyNumber:(NSString *)emergencyNumber
{
    _emergencyNumber = emergencyNumber;
    
    [[NSUserDefaults standardUserDefaults] setObject:emergencyNumber forKey:@"emergency"];
}

- (void) setPinCode:(NSString *)pin
{
    _pinCode = pin;
    
    [[NSUserDefaults standardUserDefaults] setObject:pin forKey:@"pin"];
}

- (void) setShakeLevel:(NSString *)shakeLevel
{
    _shakeLevel = shakeLevel;
    
    [[NSUserDefaults standardUserDefaults] setObject:shakeLevel forKey:@"level"];
}

- (Storm*)   currentStorm
{
    if (self.stormsHistory.count > 0)
    {
        return ([self.stormsHistory objectAtIndex:self.stormsHistory.count - 1]);
    }
    
    return Nil;
}

- (EmotionalChain*) currentChain
{
    if (self.chainsHistory.count > 0)
    {
        return ([self.chainsHistory objectAtIndex:self.chainsHistory.count - 1]);
    }
    
    return Nil;
}

- (void) saveStorms
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"MyAppCache"];
    NSString *fullPath = [cacheDirectory stringByAppendingPathComponent:@"archive.data"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:fullPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }

    // Saving
    [NSKeyedArchiver archiveRootObject:self.stormsHistory toFile:fullPath];
}

- (void) loadStorm
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"MyAppCache"];
    NSString *fullPath = [cacheDirectory stringByAppendingPathComponent:@"archive.data"];
    
    self.stormsHistory = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
    
    // Checking if exists
    if (!self.stormsHistory)
    {
        self.stormsHistory = [NSMutableArray new];
    }
}

- (void) saveChains
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"MyAppCache"];
    NSString *fullPath = [cacheDirectory stringByAppendingPathComponent:@"chains.data"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:fullPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // Saving
    [NSKeyedArchiver archiveRootObject:self.chainsHistory toFile:fullPath];
}

- (void) loadChains
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"MyAppCache"];
    NSString *fullPath = [cacheDirectory stringByAppendingPathComponent:@"chains.data"];
    
    self.chainsHistory = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
    
    // Checking if exists
    if (!self.chainsHistory)
    {
        self.chainsHistory = [NSMutableArray new];
    }

}
@end
