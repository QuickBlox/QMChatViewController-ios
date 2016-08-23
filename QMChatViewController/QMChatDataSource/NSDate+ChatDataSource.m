//
//  NSDate+ChatDataSource.m
//  sample-chat
//
//  Created by Vitaliy Gurkovsky on 8/23/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import "NSDate+ChatDataSource.h"
static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);

@implementation NSDate (ChatDataSource)

+ (NSCalendar *) currentCalendar
{
    static NSCalendar *sharedCalendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    });
    
    return sharedCalendar;
}

- (NSComparisonResult)compareWithDate:(NSDate*)dateToCompareWith {

    NSDateComponents *date1Components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *date2Components = [[NSDate currentCalendar] components:componentFlags fromDate:dateToCompareWith];
    
    NSComparisonResult comparison = [[[NSDate currentCalendar] dateFromComponents:date1Components] compare:[[NSDate currentCalendar] dateFromComponents:date2Components]];
    
    return comparison;
}

- (NSDate *)dateAtStartOfDay {
    return [[NSDate currentCalendar] startOfDayForDate:self];
}

- (NSDate *)dateAtEndOfDay {
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = 1;
    dateComponents.second = -1;
    
 
    NSDate * endDate =  [[NSDate currentCalendar] dateByAddingComponents:dateComponents
                                                  toDate:[self dateAtStartOfDay]
                                                 options:NSCalendarWrapComponents];
    return endDate;
}

- (NSString*)stringDate {
    
    return [self stringDateWithFormat:nil];
}

- (BOOL)isBetweenStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate {
    return ([self compare:startDate] == NSOrderedDescending &&
            [self compare:endDate]  == NSOrderedAscending);
}

- (NSString*)stringDateWithFormat:(NSString*)dateFormat {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale currentLocale];
        dateFormatter.timeZone = [NSDate currentCalendar].timeZone;
        [dateFormatter setDateFormat:@"d MMMM YYYY"];
    });
    
    if (dateFormat.length) {
        [dateFormatter setDateFormat:dateFormat];
    }
    
    return [dateFormatter stringFromDate:self];
}

@end
