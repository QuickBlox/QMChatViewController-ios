//
//  QMChatDataSource.m
//  Pods
//
//  Created by Vitaliy Gurkovsky on 8/10/16.
//
//

#import "QMChatDataSource.h"

typedef NS_ENUM(NSInteger, QMDataSourceUpdateType) {
    QMDataSourceUpdateTypeAdd = 0,
    QMDataSourceUpdateTypeRemove,
    QMDataSourceUpdateTypeUpdate
};

@interface QMChatDataSource()

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableSet *dateDividers;

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

#pragma mark -
#pragma mark Initialization

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _dateDividers = [NSMutableSet set];
        _messages = [NSMutableArray array];
    }
    
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"\n[QMDataSource] \n\t messages: %@", self.messages.copy];
}

#pragma mark -
#pragma mark Setting

- (void)setDataSourceMessages:(NSArray*)messages {
    
    NSUInteger numberOfMessages = messages.count;
    
    NSMutableArray *messagesIDs = [NSMutableArray arrayWithCapacity:numberOfMessages];
    
    for (QBChatMessage *message in messages) {
        
        NSAssert(message.dateSent != nil, @"Message must have dateSent!");
        
        if ([self messageExists:message]) {
            continue;
        }
        
        NSInteger messageIndex = NSNotFound;
        messageIndex = [self insertMessage:message];
        
        if (messageIndex != NSNotFound) {
            
            [messagesIDs addObject:message.ID];
            
            [self handleMessage:message forUpdateType:QMDataSourceUpdateTypeAdd];
            
        }
        
    }
    
    if (messagesIDs.count && [self.delegate respondsToSelector:@selector(chatDataSource:didSetMessagesWithIDs:)]) {
        [self.delegate chatDataSource:self didSetMessagesWithIDs:messagesIDs];
    }
    
}

#pragma mark -
#pragma mark Adding

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
            NSInteger divideMessageIndex = [self handleMessage:message forUpdateType:QMDataSourceUpdateTypeAdd];
            
            if (divideMessageIndex != NSNotFound) {
                [itemsIndexPaths addObject:[NSIndexPath indexPathForItem:divideMessageIndex
                                                               inSection:0]];
            }
        }
    }
    
    if (itemsIndexPaths.count && [self.delegate respondsToSelector:@selector(chatDataSource:didInsertItems:animated:)]) {
        [self.delegate chatDataSource:self didInsertItems:itemsIndexPaths animated:YES];
    }
}

#pragma mark -
#pragma mark Removing

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
        if (indexPath == nil) {
            // message doesn't exists
            continue;
        }
        
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
}

#pragma mark -
#pragma mark - Helpers

- (NSArray *)allMessages {
    return [self.messages copy];
}

- (NSInteger)messagesCount {
    
    return self.messages.count;
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
#pragma mark - Date Dividers

- (NSInteger)handleMessage:(QBChatMessage*)message forUpdateType:(QMDataSourceUpdateType)updateType {
    NSInteger divideMessageIndex = NSNotFound;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    switch (updateType) {
        case QMDataSourceUpdateTypeAdd: {
            
            NSDate * dateToAdd = [calendar startOfDayForDate:message.dateSent];
            
            if (![self.dateDividers containsObject:dateToAdd]) {
                
                QBChatMessage * message = [QBChatMessage new];
                
                message.text = [self qm_stringFromDate:dateToAdd];
                message.dateSent = dateToAdd;
                
                message.isDateDividerMessage = YES;
                
                [self.dateDividers addObject:dateToAdd];
                
                divideMessageIndex = [self insertMessage:message];
            }
            
            break;
        }
            
        case QMDataSourceUpdateTypeRemove:
            break;
            
        case QMDataSourceUpdateTypeUpdate:
            break;
            
        default:
            NSAssert(YES, @"undefined QMDataSourceUpdateType");
            break;
    }
    
    return divideMessageIndex;
}

- (NSString*)qm_stringFromDate:(NSDate*)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.timeZone = calendar.timeZone;
    [dateFormatter setDateFormat:@"d MMMM YYYY"];
    
    return [dateFormatter stringFromDate:date];
}


@end
