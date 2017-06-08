//
//  QMMediaPresenter.h
//  QMMediaPresenter
//
//  Created by Vitaliy Gurkovsky on 1/30/17.
//  Copyright © 2017 quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QMChatPresenterDelegate.h"

@protocol QMPlayerService;
@protocol QMMediaAssistant;
@protocol QMEventHandler;

@interface QMMediaPresenter : NSObject <QMChatPresenterDelegate>

@property (weak, nonatomic) id <QMPlayerService> playerService;
@property (weak, nonatomic) id <QMMediaAssistant> mediaAssistant;
@property (weak, nonatomic) id <QMEventHandler> eventHandler;

- (void)didUpdateIsActive:(BOOL)isActive;
- (void)didUpdateOffset:(NSTimeInterval)offset;
- (void)didUpdateIsReady:(BOOL)isReady;
- (void)didUpdateProgress:(CGFloat)progress;
- (void)didUpdateDuration:(NSTimeInterval)duration;

- (void)didUpdateCurrentTime:(NSTimeInterval)currentTime
                    duration:(NSTimeInterval)duration;

- (void)didUpdateImage:(UIImage *)image;
- (void)didUpdateThumbnailImage:(UIImage *)image;
- (void)didUpdateLoadingProgress:(CGFloat)loadingProgress;
- (void)didOccureUploadError:(NSError *)error;
- (void)didOccureDownloadError:(NSError *)error;

@end

@protocol QMPlayerService <NSObject>

- (void)activateMediaWithSender:(QMMediaPresenter *)sender;
- (void)requestPlayingStatus:(QMMediaPresenter *)sender;

@end

@protocol QMMediaAssistant <NSObject>

- (void)requestForMediaWithSender:(QMMediaPresenter *)sender;

@end

@protocol QMEventHandler <NSObject>

- (void)didTapContainer:(QMMediaPresenter *)sender;

@end
