//
//  QMMediaPresenter.m
//  QMMediaPresenter
//
//  Created by Vitaliy Gurkovsky on 1/30/17.
//  Copyright © 2017 quickblox. All rights reserved.
//

#import "QMMediaPresenter.h"
#import "QMMediaViewDelegate.h"
#import <Quickblox/Quickblox.h>

@implementation QMMediaPresenter

@synthesize message = _message;
@synthesize view = _view;
@synthesize modelID = _modelID;

@synthesize playerService;
@synthesize mediaAssistant;
@synthesize eventHandler;

- (instancetype)initWithView:(id <QMMediaViewDelegate>)view {
    
    if (self = [super init]) {
        
        _view = view;
    }
    return self;
}

- (void)didTapContainer {
//    NSLog(@"self.view %@", self.view);
//    NSLog(@"self.messageID %@", self.message.ID);
    
    [self.eventHandler didTapContainer:self];
}

//- (void)setView:(id<QMMediaViewDelegate>)view {
//
//    if (_view != nil && ![view isEqual:_view]) {
//         [self.mediaAssistant shouldCancellOperationWithSender:self];
//    }
//    _view = view;
//}

- (void)activateMedia {
    [self.playerService activateMediaWithSender:self];
}

- (void)requestForMedia {
    
    [self.mediaAssistant requestForMediaWithSender:self];
}
- (void)cancellMediaOperation {
    [self.mediaAssistant shouldCancellOperationWithSender:self];
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


- (void)didOccureUploadError:(NSError *)error {
    
}

- (void)didOccureDownloadError:(NSError *)error {
    
}

- (void)updateView {
    
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"<%@: %p; messageID = %@; model = %@>",
            NSStringFromClass([self class]),
            self,
            self.message.ID,
            [self.message.attachments firstObject]];
}



@end
