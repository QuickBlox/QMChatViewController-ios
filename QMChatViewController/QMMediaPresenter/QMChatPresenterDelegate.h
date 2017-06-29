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

- (instancetype)initWithView:(id <QMMediaViewDelegate>)view;

@end


