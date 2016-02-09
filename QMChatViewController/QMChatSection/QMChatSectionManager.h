//
//  QMChatSectionManager.h
//  QMChatViewController
//
//  Created by Vitaliy Gorbachov on 2/2/16.
//  Copyright (c) 2016 QuickBlox Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBChatMessage;
@class QMChatSectionManager;

@protocol QMChatSectionManagerDelegate <NSObject>

@required
- (void)chatSectionManager:(QMChatSectionManager *)chatSectionManager didInsertSections:(NSIndexSet *)sectionsIndexSet andItems:(NSArray *)itemsIndexPaths;

@end

@interface QMChatSectionManager : NSObject

@property (nonatomic, weak) id <QMChatSectionManagerDelegate> delegate;

- (void)addMessage:(QBChatMessage *)message;
- (void)addMessages:(NSArray *)messages;

- (void)updateMessage:(QBChatMessage *)message;
- (void)updateMessages:(NSArray *)message;

- (void)deleteMessage:(QBChatMessage *)message;
- (void)deleteMessages:(NSArray *)messages;

@end
