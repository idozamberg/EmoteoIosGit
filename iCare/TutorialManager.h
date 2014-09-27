//
//  TutorialManager.h
//  iCare
//
//  Created by ido zamberg on 7/17/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlowManager.h"
#import "AppData.h"

@interface TutorialManager : NSObject


+ (TutorialManager*) sharedInstance;

- (void) showTutorial;


@end
