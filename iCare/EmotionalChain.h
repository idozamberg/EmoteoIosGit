//
//  EmotionalChain.h
//  iCare
//
//  Created by ido zamberg on 4/6/15.
//  Copyright (c) 2015 ido zamberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmotionalChain : NSObject <NSCoding>

@property (nonatomic,strong) NSMutableDictionary* chainElements;
@property (nonatomic,strong) NSDate             * date;
@property (nonatomic       ) NSNumber*            tension;

- (void) addNewSelection : (UIImage*) image ToKey :(NSNumber*) key;
- (void) addNewSelectionWithKeyImage : (UIImage*) keyImage numberImage : (UIImage*) image andKey :(NSNumber*) key;

@end
