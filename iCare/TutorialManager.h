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
#import "TutorialView.h"

@interface TutorialManager : NSObject
@property (nonatomic,strong) TutorialView* tutorial;

+ (TutorialManager*) sharedInstance;

- (void) showTutorial;


@end
