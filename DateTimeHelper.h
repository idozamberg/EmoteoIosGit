//
//  DateTimeHelper.h
//  365Scores
//
//  Created by Tom Winter on 23/07/12.
//  Copyright (c) 2012 for-each. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTimeHelper : NSObject

+ (NSDate*) convertStringToDate:(NSString*) dateString withDateFormat:(NSString*) dateFormat;
+ (NSString*) getTimeFromDate:(NSDate*) date withTimeFormat:(NSString*) timefFormat;
+ (NSString*) getDate:(NSDate*) date withDateFormat:(NSString*) datefFormat;
+ (NSString*) getDate:(NSDate*) date withDateFormat:(NSString*) datefFormat withTimeZone:(NSTimeZone*) timeZone;
+ (double) TimeBetweenDate:(NSDate*)date1 toDate:(NSDate*)date2;
+ (NSDate*) addDaysToNow:(NSInteger) daysNum;
+ (NSString*) getCreationTimeSinceDate:(NSDate*) date;
+ (NSInteger) getDayOfMonth : (NSDate*) aDate;

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
+ (void) UpdateLocale;
+ (void) ResetLocale;
+ (NSDate*) simpleConvertStringToDate:(NSString*) dateString withDateFormat:(NSString*) dateFormat;
+ (NSDate*) convertStringToDate:(NSString*) dateString withDateFormat:(NSString*) dateFormat andTimeZone: (NSTimeZone*) timezone;
+ (NSDate *)userVisibleDateTimeStringForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString;
+ (NSDate*) convertStringToIsoDate : (NSString*) dateString;
+ (NSString*) getCreationTimeSinceDateForFacebookComments:(NSDate*) date;
+ (NSDate*) getDateFromHours:(NSInteger)hours andMinutes:(NSInteger)minutes;
+ (NSLocale*) getLocaleByLanguage:(NSInteger)languageIndex;
+ (BOOL)timeIs24HourFormat;
+ (NSDateFormatter*) getFormatter;
+ (NSString*) getGameStartTime:(NSDate*) date;

+ (NSDate*) getDateBySubstractingSeconds :(NSUInteger) seconds;

+ (NSString*) getCreationTimeSinceDateForChatConversation:(NSDate *)date;
+ (NSString*) getLastSeenDateString:(NSDate*) date;

@end
