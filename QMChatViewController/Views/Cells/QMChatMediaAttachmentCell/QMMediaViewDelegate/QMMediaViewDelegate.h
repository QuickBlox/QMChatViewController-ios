//
//  QMMediaViewDelegate.h
//  QMPLayer
//
//  Created by Vitaliy Gurkovsky on 1/30/17.
//  Copyright © 2017 quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class QMMediaPresenter;

@protocol QMMediaViewDelegate <NSObject>

@required

- (void)setupInitialState;
- (void)setOnLayoutUpdate;

@property (strong, nonatomic) QMMediaPresenter *presenter;

@optional

- (void)setDuration:(NSTimeInterval)duration;
- (void)setOffset:(CGFloat)offset;
- (void)setProgres:(CGFloat)progress;

- (void)setIsActive:(BOOL)isActive;

- (void)setPlayingStatus:(NSUInteger)playingStatus;

- (void)setCurrentTime:(NSTimeInterval)currentTime
           forDuration:(NSTimeInterval)duration;

- (void)setThumbnailImage:(UIImage *)image;

- (void)showLoadingError:(NSError *)error;
- (void)setIsReady:(BOOL)isReady;
- (void)showUploadingError:(NSError *)error;

@end
