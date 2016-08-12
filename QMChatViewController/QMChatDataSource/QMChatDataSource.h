//
//  QMChatDataSource.h
//  Pods
//
//  Created by Vitaliy Gurkovsky on 8/10/16.
//
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>

@class QBChatMessage;

@protocol QMChatDataSourceDelegate;

@interface QMChatDataSource : NSObject

@property (strong, nonatomic, readonly) NSMutableArray *messages;

/**
 *  Time interval between messages.
 *  Default value: 300 seconds
 *
 *  @discussion Set this value to 0 (zero) to hide all separators.
 */
@property (assign, nonatomic) NSTimeInterval timeIntervalBetweenMessages;

@property(nonatomic, weak) id <QMChatDataSourceDelegate> delegate;


- (void)addMessage:(QBChatMessage *)message;
- (void)addMessages:(NSArray QB_GENERIC(QBChatMessage *) *)messages;

- (void)deleteMessage:(QBChatMessage *)message;
- (void)deleteMessages:(NSArray QB_GENERIC(QBChatMessage *) *)messages;

- (void)updateMessage:(QBChatMessage *)message;
- (void)updateMessages:(NSArray QB_GENERIC(QBChatMessage *) *)messages;

- (NSInteger)messagesCount;

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

- (BOOL)messageExists:(QBChatMessage *)message;

@end

@protocol QMChatDataSourceDelegate <NSObject>

@optional
/**
 *  QMChatDataSource delegate method about items that were inserted to data source.
 *
 *  @param chatDataSource     QMChatDataSource current instance
 *  @param itemsIndexPaths    array of items index paths
 *  @param animated           determines whether perform animated view update or not
 */
- (void)chatDataSource:(QMChatDataSource *)chatDataSource didInsertItems:(NSArray *)itemsIndexPaths animated:(BOOL)animated;

/**
 *  QMChatDataSource delegate method about items were updated in data source.
 *
 *  @param chatDataSource     QMChatDataSource current instance
 *  @param messagesIDs        ids of updated messages
 *  @param itemsIndexPaths    array of items index paths
 */
- (void)chatDataSource:(QMChatDataSource *)chatDataSource didUpdateMessagesWithIDs:(NSArray *)messagesIDs atIndexPaths:(NSArray *)itemsIndexPaths;

/**
 *  QMChatDataSource delegate method about items were deleted from data source.
 *
 *  @param chatDataSource     QMChatDataSource current instance
 *  @param messagesIDs        ids of deleted messages
 *  @param itemsIndexPaths    array of items index paths
 *  @param animated           determines whether perform animated view update or not
 */
- (void)chatDataSource:(QMChatDataSource *)chatDataSource didDeleteMessagesWithIDs:(NSArray *)messagesIDs atIndexPaths:(NSArray *)itemsIndexPaths animated:(BOOL)animated;

@end
