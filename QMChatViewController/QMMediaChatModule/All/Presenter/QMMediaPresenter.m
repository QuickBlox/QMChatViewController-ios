//
//  QMMediaPresenter.m
//  QMMediaPresenter
//
//  Created by Vitaliy Gurkovsky on 1/30/17.
//  Copyright © 2017 quickblox. All rights reserved.
//

#import "QMMediaPresenter.h"
#import "QMMediaPresenterDelegate.h"
#import "QMMediaViewDelegate.h"
#import "QMMediaModelDelegate.h"
#import "QMMediaItem.h"

@implementation QMMediaPresenter

@synthesize view = _view;
@synthesize interactor = _interactor;

- (instancetype)initWithView:(id <QMMediaViewDelegate>)view {
    
    if (self = [super init]) {
        
        _view = view;
        [_view setupInitialState];
    }
    
    return  self;
}
- (void)updateView {
    
}

- (void)updateWithMediaItem:(QMMediaItem *)mediaItem {
    
    [self.interactor updateWithMedia:mediaItem];
}

- (void)activateMedia {
    
    [self.interactor activateMedia];
}



- (void)updateProgress:(CGFloat)progress {
    
    [self.view setProgres:progress];
}

- (void)setNeedsToUpdateLayout {
    [self.view setOnLayoutUpdate];
}

#pragma mark - Interactor output

- (void)didUpdateIsActive:(BOOL)isActive {
    
    [self.view setIsActive:isActive];
}

- (void)didUpdatePlayingStatus:(NSUInteger)playingStatus {
    
    [self.view setPlayingStatus:playingStatus];
}
- (void)didUpdateOffset:(NSTimeInterval)offset {
    
    [self.view setOffset:offset];
}
- (void)didUpdateDuration:(NSTimeInterval)duration {
    
    [self.view setDuration:duration];
}


- (void)didUpdateIsReady:(BOOL)isReady {
    
    [self.view setIsReady:isReady];
}
- (void)didUpdateProgress:(CGFloat)progress {
    
    [self.view setProgres:progress];
}
- (void)didUpdateCurrentTime:(NSTimeInterval)currentTime duration:(CGFloat)duration {
    
    [self.view setCurrentTime:currentTime
                  forDuration:duration];
}

- (void)didUpdateThumbnailImage:(UIImage *)image {
    
    [self.view setThumbnailImage:image];
}
@end
