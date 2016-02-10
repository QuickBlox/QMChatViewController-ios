//
//  QMChatSectionManager.m
//  QMChatViewController
//
//  Created by Vitaliy Gorbachov on 2/2/16.
//  Copyright (c) 2016 QuickBlox Team. All rights reserved.
//

#import "QMChatSectionManager.h"
#import "QMChatSection.h"
#import <Quickblox/Quickblox.h>

@interface QMChatSectionManager ()

@property (strong, nonatomic) NSArray *chatSections;
@property (strong, nonatomic) NSMutableArray *editableSections;
@property (nonatomic) dispatch_queue_t serialQueue;

@end

@implementation QMChatSectionManager

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _chatSections = [NSMutableArray array];
        _timeIntervalBetweenSections = 300.0f; // default time interval
        _serialQueue = dispatch_queue_create("com.q-municate.chatsectionmanager.queue", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

#pragma mark - Add messages

- (void)addMessage:(QBChatMessage *)message {
    
    [self addMessages:@[message]];
}

- (void)addMessages:(NSArray *)messages {
    
    dispatch_async(_serialQueue, ^{
        
        self.editableSections = self.chatSections.mutableCopy;
        
        NSMutableArray *itemsIndexPaths = [NSMutableArray array];
        NSMutableIndexSet *sectionsIndexSet = [NSMutableIndexSet indexSet];
        
        for (QBChatMessage *message in messages) {
            NSAssert(message.dateSent != nil, @"Message must have dateSent!");
            
            QMChatSection *correspondingSection = [self sectionThatCorrespondsToMessage:message];
            NSInteger sectionIndex = NSNotFound;
            NSInteger messageIndex = NSNotFound;
            
            if (correspondingSection != nil) {
                // section already exists or was created as older/newer one
                sectionIndex = [self.editableSections indexOfObject:correspondingSection];
                
                if (correspondingSection.isEmpty == 0) {
                    // section was newly created, need to add its index to sections index set
                    [sectionsIndexSet addIndex:sectionIndex];
                }
                
                messageIndex = [correspondingSection insertMessage:message];
            }
            else {
                // need to create new section for message
                correspondingSection = [self createSectionWithMessage:message];
                
                sectionIndex = [self.editableSections indexOfObject:correspondingSection];
                messageIndex = [correspondingSection insertMessage:message];
                
                [sectionsIndexSet addIndex:sectionIndex];
            }
            
            [itemsIndexPaths addObject:[NSIndexPath indexPathForItem:messageIndex
                                                           inSection:sectionIndex]];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            self.chatSections = self.editableSections.copy;
            self.editableSections = nil;
            
            if ([self.delegate respondsToSelector:@selector(chatSectionManager:didInsertSections:andItems:)]) {
                
                [self.delegate chatSectionManager:self didInsertSections:sectionsIndexSet.copy andItems:itemsIndexPaths.copy];
            }
        });
    });
}

#pragma mark - Update messages

- (void)updateMessage:(QBChatMessage *)message {
    
    [self updateMessages:@[message]];
}

- (void)updateMessages:(NSArray *)messages {
    
    dispatch_async(_serialQueue, ^{
        
        NSMutableArray *messagesIDs = [NSMutableArray array];
        NSMutableArray *itemsIndexPaths = [NSMutableArray array];
        
        for (QBChatMessage *message in messages) {
            NSIndexPath *indexPath = [self indexPathForMessage:message];
            if (indexPath == nil) continue;
            
            [itemsIndexPaths addObject:indexPath];
            [messagesIDs addObject:message.ID];
            
            QMChatSection *chatSection = self.chatSections[indexPath.section];
            [chatSection.messages replaceObjectAtIndex:indexPath.item withObject:message];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if ([self.delegate respondsToSelector:@selector(chatSectionManager:didUpdateMessagesWithIDs:atIndexPaths:)]) {
                
                [self.delegate chatSectionManager:self didUpdateMessagesWithIDs:messagesIDs.copy atIndexPaths:itemsIndexPaths.copy];
            }
        });
    });
}

#pragma mark - Delete messages

- (void)deleteMessage:(QBChatMessage *)message {
    
    [self deleteMessages:@[message]];
}

- (void)deleteMessages:(NSArray *)messages {
    
    NSMutableArray *messagesIDs = [NSMutableArray array];
    NSMutableArray *itemsIndexPaths = [NSMutableArray array];
    NSMutableIndexSet *sectionsIndexSet = [NSMutableIndexSet indexSet];
    
    dispatch_async(_serialQueue, ^{
        
        self.editableSections = self.chatSections.mutableCopy;
        
        for (QBChatMessage *message in messages) {
            NSIndexPath *indexPath = [self indexPathForMessage:message];
            if (indexPath == nil) continue;
            
            QMChatSection *chatSection = self.chatSections[indexPath.section];
            [chatSection.messages removeObjectAtIndex:indexPath.item];
            
            if (chatSection.isEmpty) {
                [sectionsIndexSet addIndex:indexPath.section];
                [self.editableSections removeObjectAtIndex:indexPath.section];
                
                // no need to remove elements whose section will be removed
                NSArray *items = [itemsIndexPaths copy];
                for (NSIndexPath *index in items) {
                    if (index.section == indexPath.section) {
                        [itemsIndexPaths removeObject:index];
                    }
                }
            } else {
                
                [itemsIndexPaths addObject:indexPath];
            }
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            self.chatSections = self.editableSections.copy;
            self.editableSections = nil;
            
            if ([self.delegate respondsToSelector:@selector(chatSectionManager:didDeleteMessagesWithIDs:atIndexPaths:withSectionsIndexSet:)]) {
                
                [self.delegate chatSectionManager:self didDeleteMessagesWithIDs:messagesIDs atIndexPaths:itemsIndexPaths withSectionsIndexSet:sectionsIndexSet];
            }
        });
    });
}

#pragma mark - Helpers

- (QMChatSection *)sectionThatCorrespondsToMessage:(QBChatMessage *)message {
    
    QMChatSection *firstSection = self.editableSections.firstObject;
    
    if ([firstSection.firstMessageDate compare:message.dateSent] == NSOrderedAscending) {
        // message is older then first message of first section
        
        if (fabs([message.dateSent timeIntervalSinceDate:firstSection.firstMessageDate]) > self.timeIntervalBetweenSections) {
            
            firstSection = [QMChatSection chatSection];
            [self.editableSections insertObject:firstSection atIndex:0];
        }
        
        return firstSection;
    }
    
    QMChatSection *lastSection = self.editableSections.lastObject;
    
    if ([lastSection.lastMessageDate compare:message.dateSent] == NSOrderedDescending) {
        // message is newer then last message of last section
        
        if (fabs([message.dateSent timeIntervalSinceDate:lastSection.lastMessageDate]) > self.timeIntervalBetweenSections) {
            
            lastSection = [QMChatSection chatSection];
            [self.editableSections addObject:lastSection];
        }
        
        return lastSection;
    }
    
    NSArray *chatSections = self.editableSections.copy;
    
    for (QMChatSection *chatSection in chatSections) {
        
        if (([chatSection.firstMessageDate compare:message.dateSent] == NSOrderedAscending
             && [chatSection.lastMessageDate compare:message.dateSent] == NSOrderedDescending)
            || fabs([message.dateSent timeIntervalSinceDate:chatSection.firstMessageDate]) <= self.timeIntervalBetweenSections) {
            
            return chatSection;
        }
    }
    
    return nil;
}

- (QMChatSection *)createSectionWithMessage:(QBChatMessage *)message {
    
    NSInteger index = 0;
    QMChatSection *newSection = [QMChatSection chatSection];
    
    if (self.editableSections.count > 0) {
        
        // finding new section spot between all existent sections
        NSArray *chatSections = self.editableSections.copy;
        for (NSInteger i = 0; i < chatSections.count - 1; ++i) {
            
            QMChatSection *chatSection = chatSections[i];
            QMChatSection *nextChatSection = chatSections[i + 1];
            
            if ([chatSection.lastMessageDate compare:message.dateSent] == NSOrderedDescending
                && [nextChatSection.firstMessageDate compare:message.dateSent] == NSOrderedAscending) {
                
                index = i + 1;
                break;
            }
        }
    }
    
    [self.editableSections insertObject:newSection atIndex:index];
    
    return newSection;
}

#pragma mark - Getters

- (BOOL)isEmpty {
    
    return self.chatSections.count == 0;
}

- (NSInteger)chatSectionsCount {
    
    return self.chatSections.count;
}

- (NSInteger)messagesCountForSectionAtIndex:(NSInteger)sectionIndex {
    
    if (sectionIndex > self.chatSections.count - 1) {
        
        return NSNotFound;
    }
    
    QMChatSection *chatSection = self.chatSections[sectionIndex];
    
    return chatSection.messages.count;
}

- (QMChatSection *)chatSectionAtIndex:(NSInteger)sectionIndex {
    
    if (sectionIndex > self.chatSections.count - 1) {
        
        return nil;
    }
    
    return self.chatSections[sectionIndex];
}

- (NSUInteger)totalMessagesCount {
    
    NSUInteger totalMessagesCount = 0;
    NSArray *chatSections = [self.chatSections copy];
    
    for (QMChatSection *chatSection in chatSections) {
        totalMessagesCount += [chatSection.messages count];
    }
    
    return totalMessagesCount;
}

- (QBChatMessage *)messageForIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == NSNotFound) {
        // If the update item's index path has an "item" value of NSNotFound, it means it was a section update, not an individual item.
        return nil;
    }
    
    QMChatSection *currentSection = self.chatSections[indexPath.section];
    return currentSection.messages[indexPath.item];
}

- (NSIndexPath *)indexPathForMessage:(QBChatMessage *)message {
    
    NSIndexPath *indexPath = nil;
    for (QMChatSection *chatSection in self.chatSections) {
        if ([chatSection.messages containsObject:message]) {
            indexPath = [NSIndexPath indexPathForItem:[chatSection.messages indexOfObject:message] inSection:[self.chatSections indexOfObject:chatSection]];
        }
    }
    
    return indexPath;
}

@end
