//
//  QMMediaPresenter.m
//  QMMediaPresenter
//
//  Created by Vitaliy Gurkovsky on 1/30/17.
//  Copyright © 2017 quickblox. All rights reserved.
//

#import "QMMediaPresenter.h"
#import "QMMediaViewDelegate.h"

@implementation QMMediaPresenter

@synthesize message = _message;
@synthesize modelID = _modelID;
@synthesize view = _view;
@synthesize model = _model;

@synthesize playerService;
@synthesize mediaAssistant;
@synthesize eventHandler;

- (instancetype)initWithView:(id <QMMediaViewDelegate>)view {
    
    if (self = [super init]) {
        
        _view = view;
    }
    return self;
}

- (void)updateWithModel:(id <QMChatModelProtocol>)model {
    
    model = _model;
    
    [self updateView];
}

- (void)didTapContainer {
    
    [self.eventHandler didTapContainer:self];
}


- (void)activateMedia {
    
    [self.playerService activateMediaWithSender:self];
}

- (void)requestForMedia {
    
    if (self.model) {
        
    }
    [self.mediaAssistant requestForMediaWithSender:self];
}

- (void)updateProgress:(CGFloat)progress {
    
    [self.view setProgress:progress];
}

#pragma mark - Interactor output

- (void)didUpdateIsActive:(BOOL)isActive {
    
    [self.view setIsActive:isActive];
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
    
    [self.view setProgress:progress];
}

- (void)didUpdateDuration:(NSTimeInterval)duration {
    
    [self.view setDuration:duration];
}

- (void)didUpdateCurrentTime:(NSTimeInterval)currentTime
                    duration:(NSTimeInterval)duration {
    
    [self.view setDuration:duration];
    [self.view setCurrentTime:currentTime];
}

- (void)didUpdateImage:(UIImage *)image {
    
    [self.view setImage:image];
}

- (void)didUpdateThumbnailImage:(UIImage *)image {
    
    [self.view setThumbnailImage:image];
}


- (void)didUpdateLoadingProgress:(CGFloat)loadingProgress {
    
}

- (void)didOccureUploadError:(NSError *)error {
    
}

- (void)didOccureDownloadError:(NSError *)error {
    
}


- (NSString *)description {
    
    return [NSString stringWithFormat:@"<%@: %p; model = %@>",
            NSStringFromClass([self class]),
            self,
            self.model];
}



@end
