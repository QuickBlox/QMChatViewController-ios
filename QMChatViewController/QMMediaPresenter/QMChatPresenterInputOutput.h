//
//  QMMediaPresenterInput.h
//  QMPLayer
//
//  Created by Vitaliy Gurkovsky on 1/30/17.
//  Copyright © 2017 quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QMChatModelProtocol.h"

@class QBChatMessage;
@protocol QMChatPresenterInput <NSObject>

@property (nonatomic, strong, nullable) QBChatMessage *message;
@property (nonatomic, copy, nullable) NSString *modelID;

- (void)didTapContainer;
- (void)requestForMedia;
- (void)activateMedia;

@end

@protocol QMChatPresenterOutput <NSObject>

- (void)updateView;

@end

