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

@end

@implementation QMChatDataSource

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
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
        if (indexPath == nil) continue;
        [self.messages removeObjectAtIndex:indexPath.item];
        [itemsIndexPaths addObject:indexPath];
        [messagesIDs addObject:message.ID];
    }
    if (messagesIDs.count && [self.delegate respondsToSelector:@selector(chatDataSource:didDeleteMessagesWithIDs:atIndexPaths:animated:)]) {
        [self.delegate chatDataSource:self didDeleteMessagesWithIDs:messagesIDs.copy atIndexPaths:itemsIndexPaths.copy animated:NO];
    }
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

}

- (void)addMessage:(QBChatMessage *)message {
    [self addMessages:@[message]];
}
- (void)addMessages:(NSArray<QBChatMessage *> *)messages {
    
    NSMutableArray *itemsIndexPaths = [NSMutableArray arrayWithCapacity:messages.count];
   
    
    for (QBChatMessage *message in messages) {
        
        NSAssert(message.dateSent != nil, @"Message must have dateSent!");
        
        if ([self messageExists:message]) {
            // message already exists
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
    
    NSUInteger index = self.messages.count;
    NSArray *messages = self.messages.copy;
    
    for (QBChatMessage *message_t in messages) {
        
        NSComparisonResult dateSentComparison = [message.dateSent compare:message_t.dateSent];
        
        if ((dateSentComparison == NSOrderedDescending)
            // if date of messages is same compare them by their IDs
            // to determine whether message should be upper or lower in message stack
            // if messages IDs are same - return same index
            || (dateSentComparison == NSOrderedSame && [message.ID compare:message_t.ID] != NSOrderedAscending)) {
            
            index = [messages indexOfObject:message_t];
            break;
        }
    }
    
    return index;
}

- (NSIndexPath *)indexPathForMessage:(QBChatMessage *)message {
    
    NSIndexPath *indexPath = nil;
    
    if ([self.messages containsObject:message]) {
        
        indexPath = [NSIndexPath indexPathForItem:[self.messages indexOfObject:message] inSection:0];
        
    }
    return indexPath;
}

@end
