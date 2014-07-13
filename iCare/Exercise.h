//
//  Exercise.h
//  iCare
//
//  Created by ido zamberg on 1/14/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Globals.h"

@interface Exercise : NSObject <NSCoding>



@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSNumber* level;
@property (nonatomic,strong) NSDate  * practiceTime;
@property (nonatomic)        exerciseType type;
@property (nonatomic,strong) NSMutableArray* levels;

@end
