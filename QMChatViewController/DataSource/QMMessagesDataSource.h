//
//  QMMessagesDataSource.h
//  Pods
//
//  Created by Vitaliy Gorbachov on 12/28/15.
//
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>
#import "QMChatCollectionViewDataSource.h"

@interface QMMessagesDataSource : NSObject <QMChatCollectionViewDataSource>

/**
 *  Determines whether data source is empty or not.
 */
@property (nonatomic, assign, readonly, getter=isEmpty) BOOL empty;

/**
 *  Total count of messages in all sections.
 *
 *  @discussion Use this to know how many messages are displayed in chat controller.
 */
@property (nonatomic, assign, readonly) NSUInteger totalMessagesCount;

/**
 *  Time interval between sections.
 */
@property (nonatomic, assign) NSTimeInterval timeIntervalBetweenSections;

- (NSDictionary *)addMessagesToTop:(NSArray QB_GENERIC(QBChatMessage *) *)messages;
- (NSDictionary *)addMessagesToBottom:(NSArray QB_GENERIC(QBChatMessage *) *)messages;

- (NSIndexPath *)replaceMessage:(QBChatMessage *)message;
- (NSArray QB_GENERIC(NSIndexPath *) *)replaceMessages:(NSArray QB_GENERIC(QBChatMessage *) *)messages;

- (NSDictionary *)removeMessages:(NSArray QB_GENERIC(QBChatMessage *) *)messages;

/**
 *  Message for index path.
 *
 *  @param indexPath    index path to find message
 *
 *  @return QBChatMessage instance that conforms to indexPath
 */
- (QBChatMessage *)messageForIndexPath:(NSIndexPath *)indexPath;

/**
 *  Index path for message.
 *
 *  @param message  message to return index path
 *
 *  @return NSIndexPath instance that conforms message or nil if not found
 */
- (NSIndexPath *)indexPathForMessage:(QBChatMessage *)message;

@end
