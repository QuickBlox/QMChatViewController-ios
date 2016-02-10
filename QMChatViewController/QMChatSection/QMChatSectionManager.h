//
//  QMChatSectionManager.h
//  QMChatViewController
//
//  Created by Vitaliy Gorbachov on 2/2/16.
//  Copyright (c) 2016 QuickBlox Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class QBChatMessage;
@class QMChatSectionManager;
@class QMChatSection;

@protocol QMChatSectionManagerDelegate <NSObject>

@required
- (void)chatSectionManager:(QMChatSectionManager *)chatSectionManager didInsertSections:(NSIndexSet *)sectionsIndexSet andItems:(NSArray *)itemsIndexPaths;

@end

@interface QMChatSectionManager : NSObject

@property (assign, nonatomic) NSTimeInterval timeIntervalBetweenSections;

/**
 *  Total count of messages in all sections.
 *
 *  @discussion Use this to know how many messages are displayed in chat controller.
 */
@property (assign, nonatomic, readonly) NSUInteger totalMessagesCount;

@property (weak, nonatomic) id <QMChatSectionManagerDelegate> delegate;

- (void)addMessage:(QBChatMessage *)message;
- (void)addMessages:(NSArray *)messages;

- (void)updateMessage:(QBChatMessage *)message;
- (void)updateMessages:(NSArray *)message;

- (void)deleteMessage:(QBChatMessage *)message;
- (void)deleteMessages:(NSArray *)messages;

- (BOOL)isEmpty;
- (NSInteger)chatSectionsCount;
- (NSInteger)messagesCountForSectionAtIndex:(NSInteger)sectionIndex;
- (QMChatSection *)chatSectionAtIndex:(NSInteger)sectionIndex;

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
