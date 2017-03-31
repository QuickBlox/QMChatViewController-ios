//
//  QMInteractor.h
//  QMPLayer
//
//  Created by Vitaliy Gurkovsky on 1/30/17.
//  Copyright © 2017 quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class QBChatMessage;
@class QMMediaItem;
@class QBChatAttachment;

@protocol QMMediaInteractorInput <NSObject>

@property (copy, nonatomic) NSString *attachmentID;
@property (strong, nonatomic) QBChatMessage *message;

- (void)didTapContainer;
- (void)requestForMedia;
- (void)activateMedia;

@end

@protocol QMMediaInteractorOutput <NSObject>

- (void)didUpdateIsReady:(BOOL)isReady;
- (void)didUpdateIsActive:(BOOL)isActive;

- (void)didUpdateOffset:(NSTimeInterval)offset;
- (void)didUpdateDuration:(NSTimeInterval)duration;
- (void)didUpdateProgress:(CGFloat)progress;
- (void)didUpdateCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration;

- (void)didUpdatePlayingStatus:(NSUInteger)playingStatus;
- (void)didUpdateThumbnailImage:(UIImage *)image;
- (void)didUpdateLoadingStatus:(NSUInteger)loadingStatus;
- (void)didUpdateLoadingProgress:(CGFloat)loadingProgress;

- (void)didOccureUploadError:(NSError *)error;
- (void)didOccureDownloadError:(NSError *)error;

@end

