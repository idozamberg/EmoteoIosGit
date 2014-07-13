//
//  AppManager.h
//  iCare
//
//  Created by ido zamberg on 1/3/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppData.h"
#import "VideoFile.h"
#import "AudioFile.h"
#import "FlowManager.h"

@interface AppManager : NSObject


+ (AppManager*) sharedInstance;

- (void) performStartupProcedures;
- (void) performGoingToBackgroundTasks;
- (void) performShutDownProcedures;
- (void) deletePin;

// Get exercises
- (NSMutableArray* ) getAudioExercisesByLevel : (NSNumber*) level;
- (NSMutableArray* ) getVideoExercisesByLevel : (NSNumber*) level;

@end
