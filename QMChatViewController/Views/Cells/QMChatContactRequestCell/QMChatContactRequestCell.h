//
//  QMChatContactRequestCell.h
//  Q-municate
//
//  Created by Andrey Ivanov on 14.05.15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import "QMChatCell.h"
#import "QMChatActionsHandler.h"

@protocol QMChatContactRequestCellActions;

@interface QMChatContactRequestCell : QMChatCell

@property (weak, nonatomic) id <QMChatActionsHandler> actionsHandler;

@end

