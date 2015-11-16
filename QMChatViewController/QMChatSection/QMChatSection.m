//
//  QMChatSection.m
//  Pods
//
//  Created by Vitaliy Gorbachov on 11/16/15.
//
//

#import "QMChatSection.h"

@interface QMChatSection()

@property (strong, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, readwrite) NSDate *date;
@property (strong, nonatomic, readwrite) NSMutableArray *messages;

@end

@implementation QMChatSection

- (instancetype)initWithDate:(NSDate *)date {
    if (self = [super init]) {
        self.messages = [[NSMutableArray alloc] init];
        self.name = [self formattedStringFromDate:date];
        self.date = date;
    }
    
    return self;
}

- (void)addMessage:(QBChatMessage *)message {
    [self.messages addObject:message];
}

- (NSString *)formattedStringFromDate:(NSDate *)date
{
    NSString *formattedString = nil;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSDateComponents *currentComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    NSString *sectionDate = [dateFormatter stringFromDate:date];
    
    if (components.day == currentComponents.day && components.month == currentComponents.month && components.year == currentComponents.year) {
        formattedString = [NSString stringWithFormat:@"%@", sectionDate];
    } else if (components.day == currentComponents.day-1 && components.month == currentComponents.month && components.year == currentComponents.year) {
        formattedString = [NSString stringWithFormat:@"Yesterday %@", sectionDate];
    } else if (components.year == components.year) {
        formattedString = [NSString stringWithFormat:@"%@ %ld %@", [self monthFromNumber:components.month], (long)components.day, sectionDate];
    } else {
        formattedString = [NSString stringWithFormat:@"%@ %ld %ld %@", [self monthFromNumber:components.month], (long)components.day, (long)components.year, sectionDate];
    }
    return formattedString;
}

- (NSString *)monthFromNumber:(NSInteger)number
{
    NSDictionary *dict = @{@1: @"January",
                           @2: @"February",
                           @3: @"March",
                           @4: @"April",
                           @5: @"May",
                           @6: @"June",
                           @7: @"July",
                           @8: @"August",
                           @9: @"September",
                           @10: @"October",
                           @11: @"November",
                           @12: @"December"};
    return dict[@(number)];
}

@end
