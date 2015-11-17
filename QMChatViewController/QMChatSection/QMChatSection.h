//
//  QMChatSection.h
//  Pods
//
//  Created by Vitaliy Gorbachov on 11/16/15.
//
//

#import <Foundation/Foundation.h>

@class QBChatMessage;

@interface QMChatSection : NSObject

/** Section name */
@property (strong, nonatomic, readonly) NSString *name;

/** Messages in section */
@property (strong, nonatomic, readonly) NSArray *messages;

/**
 *  New QMChatSection instance.
 *
 *  @return new QMChatSection instance
 */
+ (QMChatSection *)chatSection;

/**
 *  Add message to section.
 *
 *  @param message  message to add
 */
- (void)addMessage:(QBChatMessage *)message;

@end
