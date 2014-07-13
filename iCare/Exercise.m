//
//  Exercise.m
//  iCare
//
//  Created by ido zamberg on 1/14/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import "Exercise.h"


@implementation Exercise


- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.practiceTime forKey:@"PracticeTime"];
    [aCoder encodeObject:self.level forKey:@"Level"];
    [aCoder encodeInteger:self.type forKey:@"Type"];

}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.name         = [aDecoder decodeObjectForKey:@"Name"];
    self.practiceTime = [aDecoder decodeObjectForKey:@"PracticeTime"];
    self.level        = [aDecoder decodeObjectForKey:@"Level"];
    self.type         = [aDecoder decodeIntegerForKey:@"Type"];
    
    return self;
}

@end
