//
//  QMMediaPresenterDelegate.h
//  QMPLayer
//
//  Created by Vitaliy Gurkovsky on 1/30/17.
//  Copyright © 2017 quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMChatPresenterInputOutput.h"

@protocol QMMediaViewDelegate;

@protocol QMChatPresenterDelegate <QMChatPresenterInput, QMChatPresenterOutput>

@property (nonatomic, weak) id <QMMediaViewDelegate> view;
@property (nonatomic, strong, readonly) id <QMChatModelProtocol> model;

- (instancetype)initWithView:(id <QMMediaViewDelegate>)view;
- (void)updateWithModel:(id <QMChatModelProtocol>)model;

@end


