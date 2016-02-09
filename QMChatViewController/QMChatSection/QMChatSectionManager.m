//
//  QMChatSectionManager.m
//  QMChatViewController
//
//  Created by Vitaliy Gorbachov on 2/2/16.
//  Copyright (c) 2016 QuickBlox Team. All rights reserved.
//

#import "QMChatSectionManager.h"

@interface QMChatSectionManager ()

@property (strong, nonatomic) NSMutableArray *chatSections;
@property (nonatomic) dispatch_queue_t serialQueue;

@end

@implementation QMChatSectionManager

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _chatSections = [NSMutableArray array];
        _serialQueue = dispatch_queue_create("com.q-municate.chatsection.queue", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

#pragma mark - Add messages

- (void)addMessage:(QBChatMessage *)message {
    
    
}

- (void)addMessages:(NSArray *)messages {
    
    NSUInteger sectionsToInsert = 0;
    NSMutableArray *indexPathToInsert = [NSMutableArray array];
    
    for (QBChatMessage *message in messages) {
        NSAssert(message.dateSent != nil, @"Message must have dateSent!");
        
        if ([self indexPathForMessage:message] != nil) continue;
        
        QMChatSection *firstSection = [self.chatSections firstObject];
        
        NSUInteger sectionIndex = [self.chatSections indexOfObject:firstSection];
        
        if ([message.dateSent timeIntervalSinceDate:[firstSection firstMessageDate]] > self.timeIntervalBetweenSections || firstSection == nil) {
            
            // move previous sections
            NSArray *indexPathToInsert_t = [indexPathToInsert copy];
            for (NSIndexPath *indexPath in indexPathToInsert_t) {
                NSIndexPath *updatedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + 1];
                [indexPathToInsert replaceObjectAtIndex:[indexPathToInsert indexOfObject:indexPath] withObject:updatedIndexPath];
            }
            
            QMChatSection* newSection = [QMChatSection chatSectionWithMessage:message];
            [self.chatSections insertObject:newSection atIndex:0];
            
            sectionIndex = [self.chatSections indexOfObject:newSection];
            sectionsToInsert++;
        } else {
            [firstSection.messages insertObject:message atIndex:0];
        }
        
        [indexPathToInsert addObject:[NSIndexPath indexPathForRow:0
                                                        inSection:sectionIndex]];
    }
    
    
    dispatch_async(_serialQueue, ^{
        
        for (QBChatMessage *message in messages) {
            NSAssert(message.dateSent != nil, @"Message must have dateSent!");
            
            
        }
    });
    
    
    @synchronized(self) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([self.delegate respondsToSelector:@selector(chatSectionManager:didInsertSections:andItems:)]) {
                
            }
        });
    }
}

#pragma mark - Update messages

- (void)updateMessage:(QBChatMessage *)message {
    
}

- (void)updateMessages:(NSArray *)message {
    
}

#pragma mark - Delete messages

- (void)deleteMessage:(QBChatMessage *)message {
    
}

- (void)deleteMessages:(NSArray *)messages {
    
}

@end
