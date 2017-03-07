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


@implementation QMMediaPresenter

@synthesize view = _view;
@synthesize mediaID = _mediaID;
@synthesize message = _message;
@synthesize playerService;
@synthesize mediaAssistant;
@synthesize eventHandler;

- (instancetype)initWithView:(id <QMMediaViewDelegate>)view {
    
    if (self = [super init]) {
        _view = view;
    }
    return  self;
}

- (void)dealloc {
    
    NSLog(@"Presenter deallock");
}
- (void)didTapContainer {
    
    [self.eventHandler didTapContainer:self];
}

//- (void)updateWithMediaItem:(QMMediaItem *)mediaItem {
//    
//
//    if (mediaItem.mediaDuration > 0) {
//        [self didUpdateDuration:mediaItem.mediaDuration];
//    }
//
//    if (mediaItem.contentType == QMMediaContentTypeVideo || mediaItem.contentType == QMMediaContentTypeImage ) {
//        UIImage *image = mediaItem.image;
//        if (image) {
//            [self didUpdateThumbnailImage:image];
//        }
//    }
//}


- (void)activateMedia {
    
    [self.playerService activateMediaWithSender:self];
}

- (void)requestForMedia {
    
    [self.mediaAssistant requestForMediaWithSender:self];
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

- (void)didUpdateIsReady:(BOOL)isReady {
    
    [self.view setIsReady:isReady];
    
    if (isReady) {
        [self.playerService requestPlayingStatus:self];
    }
    
}
- (void)didUpdateProgress:(CGFloat)progress {
    
    [self.view setProgres:progress];
}

- (void)didUpdateDuration:(NSTimeInterval)duration {
    
    [self.view setDuration:duration];
}

- (void)didUpdateCurrentTime:(NSTimeInterval)currentTime
                    duration:(NSTimeInterval)duration {
    
    [self.view setCurrentTime:currentTime
                  forDuration:duration];
}

- (void)didUpdateThumbnailImage:(UIImage *)image {
    
    [self.view setImage:image];
}
@end
