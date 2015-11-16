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

/** Section date */
@property (strong, nonatomic, readonly) NSDate *date;

/** Messages in section */
@property (strong, nonatomic, readonly) NSMutableArray *messages;


/** Constructor **/
- (instancetype)initWithDate:(NSDate *)date;

/**
 *  Add message to section.
 *
 *  @param message  message to add
 */
- (void)addMessage:(QBChatMessage *)message;

@end
