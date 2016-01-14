//
//  DailyReadings.m
//  Appostolic
//
//  Created by Robert Stein on 1/13/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "DailyReadings.h"

static const NSUInteger DateDescriptionIndexOfMonth = 6;
static const NSUInteger DateDescriptionIndexOfDay = 9;
static const NSUInteger DateDescriptionIndexOfYear = 2;
static const NSUInteger DateDescriptionSubstringLength = 2;
NSString *const USSCBUrlFormat = @"http://www.usccb.org/bible/readings/%@%@%@.cfm";

@implementation DailyReadings

- (instancetype)initForDate:(NSDate *)date {
    if (self = [super init]) {
        NSString *url = [self USCCBURLForDate:date];        
    }
    return self;
}

- (NSString *)USCCBURLForDate:(NSDate *)date {
    NSString *dateStr = [date descriptionWithLocale:[NSLocale systemLocale]];
    NSString *month = [dateStr substringWithRange:NSMakeRange(DateDescriptionIndexOfMonth, DateDescriptionSubstringLength)];
    NSString *day = [dateStr substringWithRange:NSMakeRange(DateDescriptionIndexOfDay, DateDescriptionSubstringLength)];
    NSString *year = [dateStr substringWithRange:NSMakeRange(DateDescriptionIndexOfYear, DateDescriptionSubstringLength)];
    
    NSString *url = [NSString stringWithFormat:USSCBUrlFormat, month, day, year];
    return url;
}

@end

