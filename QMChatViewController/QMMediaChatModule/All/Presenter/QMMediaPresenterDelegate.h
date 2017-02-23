//
//  QMMediaController.h
//  QMPLayer
//
//  Created by Vitaliy Gurkovsky on 1/30/17.
//  Copyright © 2017 quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QBChatMessage;
@class QMMediaItem;

@protocol QMMediaViewDelegate;
@protocol QMMediaModelDelegate;

@protocol QMMediaInteractorInput;

@protocol QMMediaPresenterDelegate <NSObject>

@property (nonatomic, weak) id <QMMediaViewDelegate> view;
@property (nonatomic, strong) id <QMMediaInteractorInput> interactor;

//- (instancetype)initWithView:(id <QMMediaViewDelegate>)view message:(QBChatMessage *)message;
- (instancetype)initWithView:(id <QMMediaViewDelegate>)view;
- (void)updateView;
- (void)activateMedia;

- (void)updateWithMediaItem:(QMMediaItem *)mediaItem;
- (void)updateProgress:(CGFloat)progress;
- (void)setNeedsToUpdateLayout;


@end
