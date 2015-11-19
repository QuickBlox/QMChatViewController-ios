//
//  QMChatSection.m
//  Pods
//
//  Created by Vitaliy Gorbachov on 11/16/15.
//
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

+ (QMChatSection *)chatSection {
    return [[self alloc] init];
}

#pragma mark - Instance methods

- (NSDate *)firstMessageDate {
    QBChatMessage *firstMessage = [self.messages firstObject];
    return firstMessage.dateSent;
}

- (NSDate *)lastMessageDate {
    QBChatMessage *lastMessage = [self.messages lastObject];
    return lastMessage.dateSent;
}

@end
