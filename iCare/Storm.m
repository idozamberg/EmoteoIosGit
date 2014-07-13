//
//  Storm.m
//  iCare
//
//  Created by ido zamberg on 1/14/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import "Storm.h"
#import "AppData.h"


@implementation Storm

- (id) init
{
    self = [super init];
    
    if (self)
    {
        self.exercises = [NSMutableArray new];
        self.tensions = [NSMutableArray new];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.exercises forKey:@"Exercises"];
    [aCoder encodeObject:self.date forKey:@"Date"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.date = [aDecoder decodeObjectForKey:@"Date"];
    self.exercises = [aDecoder decodeObjectForKey:@"Exercises"];
    
    return self;
}

- (void) addExercise : (Exercise*) newExercise
{
    // Only add if does not exist
    if (![self.exercises containsObject:newExercise])
    {
        [self.exercises addObject:newExercise];
    }
    
    // Saving storms
    [[AppData sharedInstance] saveStorms];
}

- (void) addTension :(NSNumber*) level
{
    [self.tensions addObject:level];
}

@end
