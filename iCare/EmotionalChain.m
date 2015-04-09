//
//  EmotionalChain.m
//  iCare
//
//  Created by ido zamberg on 4/6/15.
//  Copyright (c) 2015 ido zamberg. All rights reserved.
//

#import "EmotionalChain.h"
#import "UIImage-NSCoding.h"

@implementation EmotionalChain

@synthesize tension;

- (id) init
{
    self = [super init];
    
    if (self)
    {
        self.chainElements = [NSMutableDictionary new];
        
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.date          = [aDecoder decodeObjectForKey:@"Date"];
    self.chainElements = [aDecoder decodeObjectForKey:@"chainElements"];
    self.tension       = [aDecoder decodeObjectForKey:@"tension"];
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.date forKey:@"Date"];
    [aCoder encodeObject:self.chainElements forKey:@"chainElements"];
    [aCoder encodeObject:self.tension forKey:@"tension"];

}

- (void) addNewSelection : (UIImage*) image ToKey :(NSNumber*) key
{

    // If it's not the first object
    if ([self.chainElements objectForKey:key])
    {
        // Adding object
        [[self.chainElements objectForKey:key] addObject:image];
    }
    // Create array
    else
    {
        // Setting array
        NSMutableArray* elements = [[NSMutableArray alloc] init];
        [elements addObject:image];
        
        // Inserting to dictionary
        [self.chainElements setObject:elements forKey:key];
        
    }
    
}

- (void) addNewSelectionWithKeyImage : (UIImage*) keyImage numberImage : (UIImage*) image andKey :(NSNumber*) key
{
    // If it's not the first object
    if ([self.chainElements objectForKey:key])
    {
        // Removing old objects
        [self.chainElements removeAllObjects];
        
        // Adding object
        [[self.chainElements objectForKey:key] addObject:keyImage];
        // Adding object
        [[self.chainElements objectForKey:key] addObject:image];
    }
    // Create array
    else
    {
        // Setting array
        NSMutableArray* elements = [[NSMutableArray alloc] init];
        [elements addObject:keyImage];
        [elements addObject:image];
        
        // Inserting to dictionary
        [self.chainElements setObject:elements forKey:key];
    }

}



@end
