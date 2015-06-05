//
//  QMChatActionsHandler.h
//  Q-municate
//
//  Created by Andrey Ivanov on 29.05.15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QMChatActionsHandler <NSObject>

- (void)chatContactRequestDidAccept:(BOOL)accept sender:(id)sender;

@end
