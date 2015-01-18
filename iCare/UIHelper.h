//
//  UIHelper.h
//  iCare
//
//  Created by ido zamberg on 1/10/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIHelper : NSObject

+ (void) showMessage : (NSString*) message;
+ (UIColor*) generateRandomColor;
+ (NSInteger) getRandomNumbergWithMaxNumber : (NSInteger) max;
+ (NSMutableDictionary*) dictionaryFromPlistWithName : (NSString*) plistName;

@end
