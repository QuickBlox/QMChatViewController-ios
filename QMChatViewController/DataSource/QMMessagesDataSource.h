//
//  QMMessagesDataSource.h
//  QMChatViewController
//
//  Created by Vitaliy Gorbachov on 12/28/15.
//  Copyright (c) 2015 QuickBlox Team. All rights reserved.
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
 *  The time interval that used to split messages between sections.
 *
 *  @discussion The messages that have dateSent difference from the last message in section not greater then the one you set,
 *  will appear in one section under one date of the first message in section.
 */
@property (assign, nonatomic) NSTimeInterval timeIntervalBetweenSections;

/**
 *  Adding messages to the top of the data source.
 *
 *  @param messages messages to add
 *
 *  @return dictionary with added sections indexes and added items index paths
 */
- (NSDictionary *)addMessagesToTop:(NSArray QB_GENERIC(QBChatMessage *) *)messages;

/**
 *  Adding messages to the bottom of the data source.
 *
 *  @param messages messages to add
 *
 *  @return dictionary with added sections indexes and added items index paths
 */
- (NSDictionary *)addMessagesToBottom:(NSArray QB_GENERIC(QBChatMessage *) *)messages;

/**
 *  Replace message in the data source.
 *
 *  @param message message replace
 *
 *  @return index path of replaced message
 */
- (NSIndexPath *)replaceMessage:(QBChatMessage *)message;

/**
 *  Replace messages in the data source.
 *
 *  @param messages messages to replace
 *
 *  @return array of index paths of replaced messages
 */
- (NSArray QB_GENERIC(NSIndexPath *) *)replaceMessages:(NSArray QB_GENERIC(QBChatMessage *) *)messages;

/**
 *  Remove messages from the data source.
 *
 *  @param messages messages to remove
 *
 *  @return dictionary of removed sections indexes and items index paths
 */
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

/**
 *  Generating name for section with date.
 *
 *  @param date Date of section
 *
 *  @discussion override this method if you want to generate custom name for section with it's date.
 */
- (NSString *)nameForSectionWithDate:(NSDate *)date;

@end
