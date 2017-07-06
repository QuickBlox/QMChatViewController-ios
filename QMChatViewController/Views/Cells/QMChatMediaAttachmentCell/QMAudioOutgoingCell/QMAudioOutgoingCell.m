//
//  QMAudioOutgoingCell.m
//  Pods
//
//  Created by Vitaliy Gurkovsky on 2/13/17.
//
//

#import "QMAudioOutgoingCell.h"

@implementation QMAudioOutgoingCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _progressView.layer.masksToBounds = YES;
    self.layer.masksToBounds = YES;
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    [self.progressView setProgress:0
                          animated:NO];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    UIImage *stretchableImage = self.containerView.backgroundImage;

    _progressView.layer.mask = [self maskLayerFromImage:stretchableImage withFrame:_progressView.bounds];
}

- (void)setIsActive:(BOOL)isActive {
    [super setIsActive:isActive];
}


- (void)setCurrentTime:(NSTimeInterval)currentTime {
    
    [super setCurrentTime:currentTime];
    
    NSTimeInterval duration = self.duration;
    NSString *timeStamp = [self timestampString:currentTime
                                    forDuration:duration];
    
    self.durationLabel.text = timeStamp;
    
    if (duration > 0) {
        BOOL animated = self.isActive && currentTime > 0;
        [self.progressView setProgress:currentTime/duration
                              animated:animated];
    }
}

@end
