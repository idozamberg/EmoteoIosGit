//
//  Storm.h
//  iCare
//
//  Created by ido zamberg on 1/14/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Exercise.h"

@interface Storm : NSObject <NSCoding>

@property (nonatomic,strong) NSMutableArray* exercises;
@property (nonatomic,strong) NSMutableArray* tensions;

@property (nonatomic,strong) NSDate        * date;

- (void) addExercise : (Exercise*) newExercise;
- (void) addTension :(NSNumber*) level;


@end
