//
//  QMChatSection.m
//  QMChatViewController
//
//  Created by Vitaliy Gorbachov on 11/16/15.
//  Copyright (c) 2016 QuickBlox Team. All rights reserved.
//

#import "QMChatSection.h"
#import <Quickblox/Quickblox.h>

@implementation QMChatSection

#pragma mark - Class methods

- (instancetype)init {
    if (self = [super init]) {
        self.messages = [NSMutableArray array];
    }
    
    return self;
}

- (instancetype)initWithMessage:(QBChatMessage *)message {
    if (self = [super init]) {
        self.messages = [NSMutableArray arrayWithObject:message];
    }
    
    return self;
}

+ (QMChatSection *)chatSection {
    return [[self alloc] init];
}

+ (QMChatSection *)chatSectionWithMessage:(QBChatMessage *)message {
    return [[self alloc] initWithMessage:message];
}

#pragma mark - Instance methods

- (NSUInteger)insertMessage:(QBChatMessage *)message {
    
    NSUInteger index = NSNotFound;
    
    NSArray *messages = self.messages.copy;
    
    for (QBChatMessage *message_t in messages) {
        
        if ([message_t.dateSent compare:message.dateSent] == NSOrderedDescending) {
            
            index = [messages indexOfObject:message_t];
        }
    }
    
    if (index == NSNotFound) {
        
        index = self.messages.count;
    }
    
    [self.messages insertObject:message atIndex:index];
    
    return index;
}

#pragma mark - Getters

- (BOOL)isEmpty {
    
    return self.messages.count == 0;
}

- (NSDate *)firstMessageDate {
    
    QBChatMessage *firstMessage = [self.messages firstObject];
    return firstMessage.dateSent;
}

- (NSDate *)lastMessageDate {
    
    QBChatMessage *lastMessage = [self.messages lastObject];
    return lastMessage.dateSent;
}

@end
