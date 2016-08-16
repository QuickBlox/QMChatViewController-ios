//
//  QMChatDataSource.m
//  Pods
//
//  Created by Vitaliy Gurkovsky on 8/10/16.
//
//

#import "QMChatDataSource.h"


@interface QMChatDataSource()

@property (strong, nonatomic, readwrite) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray * dividers;
@end

static NSComparator messageComparator = ^(QBChatMessage* obj1, QBChatMessage * obj2) {
    if ([obj1 isEqual:obj2]) {
        return (NSComparisonResult)NSOrderedSame;
    }
    else {
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *date1Components = [cal components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSCalendarUnitHour|  NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:obj1.dateSent];
        NSDateComponents *date2Components = [cal components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSCalendarUnitHour|  NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:obj2.dateSent];
        
        NSComparisonResult comparison = [[cal dateFromComponents:date2Components] compare:[cal dateFromComponents:date1Components]];
        if (comparison == NSOrderedSame) {
            return [obj2.ID compare:obj1.ID];
        }
        else {
            return comparison;
        }
    }
};

@implementation QMChatDataSource

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        _dividers = [NSMutableArray array];
        _messages = [NSMutableArray array];
        _timeIntervalBetweenMessages = 300.0f; // default time interval
    }
    
    return self;
}

- (void)deleteMessage:(QBChatMessage *)message  {
    [self deleteMessages:@[message]];
}

- (void)deleteMessages:(NSArray<QBChatMessage *> *)messages {
    NSUInteger numberOfMessages = messages.count;
    
    NSMutableArray *messagesIDs = [NSMutableArray arrayWithCapacity:numberOfMessages];
    NSMutableArray *itemsIndexPaths = [NSMutableArray arrayWithCapacity:numberOfMessages];
    
    for (QBChatMessage *message in messages) {
        
        NSIndexPath *indexPath = [self indexPathForMessage:message];
        if (indexPath == nil) {
            continue;
        }
        
        [self.messages removeObjectAtIndex:indexPath.item];
        [itemsIndexPaths addObject:indexPath];
        [messagesIDs addObject:message.ID];
    }
    
    if (messagesIDs.count && [self.delegate respondsToSelector:@selector(chatDataSource:didDeleteMessagesWithIDs:atIndexPaths:animated:)]) {
        [self.delegate chatDataSource:self didDeleteMessagesWithIDs:messagesIDs.copy atIndexPaths:itemsIndexPaths.copy animated:YES];
    }
    [self setupDataSource];
}

- (NSInteger)messagesCount {
    
    return self.messages.count;
}

- (void)updateMessage:(QBChatMessage *)message {
    [self updateMessages:@[message]];
}

- (void)updateMessages:(NSArray<QBChatMessage *> *)messages {
    NSUInteger numberOfMessages = messages.count;
    
    NSMutableArray *messagesIDs = [NSMutableArray arrayWithCapacity:numberOfMessages];
    NSMutableArray *itemsIndexPaths = [NSMutableArray arrayWithCapacity:numberOfMessages];
    
    for (QBChatMessage *message in messages) {
        NSIndexPath *indexPath = [self indexPathForMessage:message];
        if (indexPath == nil) continue; // message doesn't exists
        
        NSUInteger updatedMessageIndex = [self indexThatConformsToMessage:message];
        if (updatedMessageIndex != indexPath.item) {
            
            // message will have new indexPath due to date changes
            [self deleteMessages:@[message]];
            [self addMessages:@[message]];
        }
        else {
        
            [itemsIndexPaths addObject:indexPath];
            [messagesIDs addObject:message.ID];
            [self.messages replaceObjectAtIndex:indexPath.item withObject:message];
        }
    }
    
    if (messagesIDs.count && [self.delegate respondsToSelector:@selector(chatDataSource:didUpdateMessagesWithIDs:atIndexPaths:)]) {
        [self.delegate chatDataSource:self didUpdateMessagesWithIDs:messagesIDs.copy atIndexPaths:itemsIndexPaths.copy];
    }
    
    [self setupDataSource];
}

- (void)addMessage:(QBChatMessage *)message {
    [self addMessages:@[message]];
}

- (void)addMessages:(NSArray<QBChatMessage *> *)messages {
    
    NSMutableArray *itemsIndexPaths = [NSMutableArray arrayWithCapacity:messages.count];
   
    
    for (QBChatMessage *message in messages) {
        
        NSAssert(message.dateSent != nil, @"Message must have dateSent!");
        
        if ([self messageExists:message]) {
            continue;
        }
        
        NSInteger messageIndex = NSNotFound;
        messageIndex = [self insertMessage:message];
        
        if (messageIndex != NSNotFound) {
            [itemsIndexPaths addObject:[NSIndexPath indexPathForItem:messageIndex
                                                           inSection:0]];
        }
    }
    
    if (itemsIndexPaths.count && [self.delegate respondsToSelector:@selector(chatDataSource:didInsertItems:animated:)]) {
        [self.delegate chatDataSource:self didInsertItems:itemsIndexPaths animated:YES];
    }
    
    [self setupDataSource];
}

- (NSUInteger)insertMessage:(QBChatMessage *)message {
    
    NSUInteger index = [self indexThatConformsToMessage:message];
    [self.messages insertObject:message atIndex:index];
    
    return index;
}

- (QBChatMessage *)messageForIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == NSNotFound) {
        return nil;
    }

    return self.messages[indexPath.item];
}


- (BOOL)messageExists:(QBChatMessage *)message {
    
    return [self.messages containsObject:message];
}

- (NSUInteger)indexThatConformsToMessage:(QBChatMessage *)message {
    
    NSArray * messagesArray = self.messages.copy;
    
    NSUInteger newIndex = [messagesArray indexOfObject:message
                                         inSortedRange:(NSRange){0,[messagesArray count]}
                                               options:(NSBinarySearchingFirstEqual | NSBinarySearchingInsertionIndex)
                                       usingComparator:messageComparator];
    
    
    //NSLog(@"text:%@ ___index %d",message.text,newIndex);
    
    return newIndex;
}

- (NSIndexPath *)indexPathForMessage:(QBChatMessage *)message {
    
    NSIndexPath *indexPath = nil;
    
    if ([self.messages containsObject:message]) {
        
        indexPath = [NSIndexPath indexPathForItem:[self.messages indexOfObject:message] inSection:0];
        
    }
    return indexPath;
}

#pragma mark -
#pragma mark - Helpers

- (void)setupDataSource {
    return;
    NSArray *uniqueDateTimes = [self.messages valueForKeyPath:@"@distinctUnionOfObjects.dateSent"];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];

    NSMutableArray * dividerDates = [NSMutableArray arrayWithCapacity:0];
    
    NSUInteger dateComponents = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSInteger previousYear = -1;
    NSInteger previousDay = -1;
    NSInteger previousMonth = -1;

    for (NSDate * dateSent in uniqueDateTimes)
    {
        NSDateComponents* components = [calendar components:dateComponents fromDate:dateSent];
        
        NSInteger year = [components year];
        NSInteger month = [components month];
        NSInteger day = [components day];
        
        if (year != previousYear || month != previousMonth || day != previousDay)
        {
            previousYear = year;
            previousMonth = month;
            previousDay = day;
            [dividerDates addObject:[calendar startOfDayForDate:dateSent]];
        }
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.timeZone = calendar.timeZone;
    [dateFormatter setDateFormat:@"d MMMM YYYY"];
    
    for (NSDate * date in dividerDates) {
        
        if (![self.dividers containsObject:date]) {
            
            QBChatMessage * message = [QBChatMessage new];
    
            message.text = [dateFormatter stringFromDate:date];
            message.dateSent = date;
            [self.dividers addObject:date];
            [self addMessage:message];
        }
    }
}
@end
