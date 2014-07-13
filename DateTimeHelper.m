//
//  DateTimeHelper.m
//  365Scores
//
//  Created by Tom Winter on 23/07/12.
//  Copyright (c) 2012 for-each. All rights reserved.
//

#import "DateTimeHelper.h"
#import "ISO8601DateFormatterHelper.h"


@implementation DateTimeHelper

static NSDateFormatter* staticDateFormatter;


+ (NSDateFormatter*) getFormatter
{
    if (staticDateFormatter == nil)
    {
        staticDateFormatter = [[NSDateFormatter alloc] init];
        [staticDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Zurich"]];
    }
    
    return (staticDateFormatter);
}

+ (void) ResetLocale
{
    staticDateFormatter = nil;
    [self getFormatter];
}

// Update locale region according to user's selected language

+ (NSDate*) simpleConvertStringToDate:(NSString*) dateString withDateFormat:(NSString*) dateFormat
{
    // Construct our own NSDateFormatter
    NSDateFormatter *dateFormatter = [DateTimeHelper getFormatter];
    
    [dateFormatter  setDateFormat:dateFormat];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDate* convertedDate = [dateFormatter dateFromString:dateString];
    
    return (convertedDate);
}

+ (NSDate *)userVisibleDateTimeStringForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString
// Returns a user-visible date time string that corresponds to the
// specified RFC 3339 date time string. Note that this does not handle
// all possible RFC 3339 date time strings, just one of the most common
// styles.
{
    static NSDateFormatter *    sRFC3339DateFormatter;
    static NSDateFormatter *    sUserVisibleDateFormatter;
    NSString *                  userVisibleDateTimeString;
    NSDate *                    date;
    
    // If the date formatters aren't already set up, do that now and cache them
    // for subsequence reuse.
    
    if (sRFC3339DateFormatter == nil) {
        NSLocale *                  enUSPOSIXLocale;
        
        sRFC3339DateFormatter = [[NSDateFormatter alloc] init];
        assert(sRFC3339DateFormatter != nil);
        
        enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];;
        assert(enUSPOSIXLocale != nil);
        
        [sRFC3339DateFormatter setLocale:enUSPOSIXLocale];
        [sRFC3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        [sRFC3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    if (sUserVisibleDateFormatter == nil) {
        sUserVisibleDateFormatter = [[NSDateFormatter alloc] init];
        assert(sUserVisibleDateFormatter != nil);
        
        [sUserVisibleDateFormatter setDateStyle:NSDateFormatterShortStyle];
        [sUserVisibleDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    // Convert the RFC 3339 date time string to an NSDate.
    // Then convert the NSDate to a user-visible date string.
    
    userVisibleDateTimeString = nil;
    
    date = [sRFC3339DateFormatter dateFromString:rfc3339DateTimeString];
    if (date != nil) {
        userVisibleDateTimeString = [sUserVisibleDateFormatter stringFromDate:date];
    }
    return date;
}


+ (NSDate*) convertStringToDate:(NSString*) dateString withDateFormat:(NSString*) dateFormat andTimeZone: (NSTimeZone*) timezone
{
    // Construct our own NSDateFormatter
    NSDateFormatter *dateFormatter = [DateTimeHelper getFormatter];
    
    // Save current locale
    NSLocale* temp = dateFormatter.locale;
    NSTimeZone* oldTimeZone = dateFormatter.timeZone;
    [dateFormatter setTimeZone:timezone];
        
    // Change local to fixed one - This code is importent for other than english dateformats
    // Solution from: http://developer.apple.com/library/ios/#qa/qa1480/_index.html
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter  setDateFormat:dateFormat];

    NSDate* convertedDate = [dateFormatter dateFromString:dateString];
    
    // Restore the old locale
    [dateFormatter setLocale:temp];
    [dateFormatter setTimeZone:oldTimeZone];
    
    return (convertedDate);
}

+ (NSDate*) convertStringToDate:(NSString*) dateString withDateFormat:(NSString*) dateFormat
{    
    // Construct our own NSDateFormatter
    NSDateFormatter *dateFormatter = [DateTimeHelper getFormatter];

    // Save current locale
    NSLocale* temp = dateFormatter.locale;
    NSTimeZone* oldTimeZone = dateFormatter.timeZone;
    
    //NSLog(@"%@",oldTimeZone);
    
    // Change local to fixed one - This code is importent for other than english dateformats
    // Solution from: http://developer.apple.com/library/ios/#qa/qa1480/_index.html
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    
    [dateFormatter  setDateFormat:dateFormat];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];

    NSDate* convertedDate = [dateFormatter dateFromString:dateString];

    // Restore the old locale
    [dateFormatter setLocale:temp];
    [dateFormatter setTimeZone:oldTimeZone];

    return (convertedDate);
}

+ (NSInteger) getDayOfMonth : (NSDate*) aDate
{
    // Getting day of month out of the date
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* compoNents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:aDate]; // Get necessary date components
    
    return [compoNents day];
}

+ (NSDate*) getDateBySubstractingSeconds :(NSUInteger) seconds
{
    // Get seconds number since reference date
    NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
    
    // Substract number of seconds
    interval = interval - seconds;
    
    // Get date from seconds 
    NSDate* theDate = [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
    
    return theDate;
}

// dateFormat Example: dd/MM
+ (NSString*) getDate:(NSDate*) date withDateFormat:(NSString*) datefFormat
{
    NSDateFormatter *dateFormatter = [DateTimeHelper getFormatter];
    dateFormatter.dateFormat = datefFormat;
    
    NSString* returnValue = [dateFormatter stringFromDate: date];
    
    if (!returnValue)
    {
        returnValue = @"";
    }
    
    return returnValue;
}

+ (NSString*) getDate:(NSDate*) date withDateFormat:(NSString*) datefFormat withTimeZone:(NSTimeZone*) timeZone
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = datefFormat;
    dateFormatter.timeZone = timeZone;
    return [dateFormatter stringFromDate: date];
}



// timeFormat Example: HH:mm
+ (NSString*) getTimeFromDate:(NSDate*) date withTimeFormat:(NSString*) timefFormat
{

    NSDateFormatter *timeFormatter = [DateTimeHelper getFormatter];
    
    // Ignore regional time prefixes
//    [timeFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    timeFormatter.dateFormat = timefFormat;
    
    return [timeFormatter stringFromDate: date];
}

// Return the num of minutes between 2 dates
+ (double) TimeBetweenDate:(NSDate*)date1 toDate:(NSDate*)date2
{
    NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:date2];
    double secondsInAnMinute = 60;
    
    return (distanceBetweenDates / secondsInAnMinute);
}





+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    if (toDateTime && fromDateTime)
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                     interval:NULL forDate:fromDateTime];
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                     interval:NULL forDate:toDateTime];
        
        NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                                   fromDate:fromDate toDate:toDate options:0];
        
        return [difference day];
    }
    else
    {
        return 0;
    }
}

+ (NSDate*) convertStringToIsoDate : (NSString*) dateString
{
    static ISO8601DateFormatterHelper *formatter; //Or, if you prefer, create it once in -init and own it until -dealloc
    
    if (formatter == Nil)
    {
        formatter = [[ISO8601DateFormatterHelper alloc] init];
        formatter.includeTime = YES;
    }
    
    //[formatter setFormat:@"dd-MM-yyyy HH:mm"];
    
    NSDate *parsedDate = [formatter dateFromString:dateString];

    return parsedDate;
}

+ (NSDate*) getDateFromHours:(NSInteger)hours andMinutes:(NSInteger)minutes
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]]; // force US locale, because other countries (e.g. the rest of the world) might use different weekday numbering
    
    NSDateComponents *nowComponents = [calendar components:NSYearCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:today];
    
    [nowComponents setWeekday:1]; //Sunday
    [nowComponents setHour:hours]; // 12:00 AM = midnight (12:00 PM would be 12)
    [nowComponents setMinute:minutes];
    [nowComponents setSecond:0];
    
    return [calendar dateFromComponents:nowComponents];
}

+ (BOOL)timeIs24HourFormat
{
    NSDateFormatter *formatter = [self getFormatter];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    BOOL is24Hour = amRange.location == NSNotFound && pmRange.location == NSNotFound;
    return is24Hour;
}

@end
