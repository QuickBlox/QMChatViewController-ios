//
//  QMMediaPresenter.h
//  QMPLayer
//
//  Created by Vitaliy Gurkovsky on 1/30/17.
//  Copyright © 2017 quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QMMediaPresenterDelegate.h"
#import "QMInteractorDelegate.h"

@interface QMMediaPresenter : NSObject <QMMediaPresenterDelegate, QMMediaInteractorOutput, QMMediaInteractorInput>

@end


@protocol QMPlayerService <NSObject>

- (void)activateMediaWithSender:(QMMediaPresenter *)sender;
- (void)requestPlayingStatus:(QMMediaPresenter *)sender;

@end

@protocol QMMediaAssistant <NSObject>

- (void)requestForMediaWithSender:(QMMediaPresenter *)sender;
- (void)requestForMediaInfoWithSender:(QMMediaPresenter *)sender;

@end
