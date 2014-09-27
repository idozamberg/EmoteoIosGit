//
//  AppData.h
//  iCare
//
//  Created by ido zamberg on 20/12/13.
//  Copyright (c) 2013 ido zamberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIHelper.h"
#import "Storm.h"
#import "DateTimeHelper.h"
#import "UIView+Framing.h"
#import "VideoFile.h"
#import "AudioFile.h"
#import "AnalyticsManager.h"

@interface AppData : NSObject

+ (AppData*) sharedInstance;

- (NSArray*) getVideosForLevel : (NSNumber*) level;
- (NSArray*) getAudiosForLevel : (NSNumber*) level;
- (NSArray*) getAllVideos;
- (NSArray*) getAllAudios;
- (Storm*)   currentStorm;
- (Storm*) addNewStorm;
- (void)   saveStorms;
- (void)   loadStorm;
- (NSMutableArray*) getExerciseListForLevel : (NSNumber*) level;


@property (nonatomic) BOOL shouldEvaluateTension;
@property (nonatomic,strong) NSMutableDictionary* videos;
@property (nonatomic,strong) NSMutableDictionary* audioFiles;
@property (nonatomic,strong) NSString* emergencyNumber;
@property (nonatomic,strong) NSString* pinCode;
@property (nonatomic,strong) NSString* shakeLevel;
@property (nonatomic,strong) NSMutableArray * stormsHistory;
@property (nonatomic)        BOOL             isInStorm;
@property (nonatomic)        NSInteger        currentLevel;
@property (nonatomic)        BOOL             wasTutorialShown;


@end
