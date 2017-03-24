//
//  QMBaseMediaCell.m
//  Pods
//
//  Created by Vitaliy Gurkovsky on 2/07/17.
//
//

#import "QMBaseMediaCell.h"
#import "QMMediaViewDelegate.h"
#import "QMChatResources.h"
#import "QMMediaPresenter.h"

@implementation QMBaseMediaCell
@synthesize presenter = _presenter;

- (void)deallock {
    NSLog(@"deallock base cell");
}
- (void)awakeFromNib {
    
    [super awakeFromNib];
    NSString *imageName  = @"play_icon";
    UIImage *buttonImage = [QMChatResources imageNamed:imageName];
    
    if (buttonImage) {
        
        [self.mediaPlayButton setImage:buttonImage
                              forState:UIControlStateNormal];

    }
    self.mediaPlayButton.hidden = NO;
    self.mediaPlayButton.enabled = NO;
    
    [self.mediaPlayButton setTitle:nil
                          forState:UIControlStateNormal];
    
    [self.mediaPlayButton addTarget:self
                             action:@selector(activateMedia:)
                   forControlEvents:UIControlEventTouchDown];
    
    self.circularProgress.hideProgressIcons = YES;
    self.durationLabel.hidden = YES;
    self.durationLabel.text = nil;
    [self.circularProgress startSpinProgressBackgroundLayer];
    
    self.progressLabel.text = nil;
    
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFill;
}


- (void)prepareForReuse {
    
    [super prepareForReuse];
    [self setIsActive:NO];
    self.previewImageView.image = nil;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
           forDuration:(NSTimeInterval)duration {
    
    self.durationLabel.text = [self timestampString:currentTime forDuration:duration];
}

- (void)setProgres:(CGFloat)progress {
    
    if (progress > 0.0) {
        
        self.progressLabel.hidden = NO;
        self.circularProgress.hidden = NO;
        [self.circularProgress stopSpinProgressBackgroundLayer];
    }
    
    self.progressLabel.text = [NSString stringWithFormat:@"%2.0f%%", progress * 100.0f];
    [self.circularProgress setProgress:progress];
}

- (void)setDuration:(NSTimeInterval)duration {
    
    self.durationLabel.text = [self timestampString:duration];
}

- (void)setIsReady:(BOOL)isReady {
    
    if (isReady) {
        [self.circularProgress stopSpinProgressBackgroundLayer];
    }
    
    self.circularProgress.hidden = isReady;
    self.progressLabel.hidden = isReady;
    self.durationLabel.hidden = !isReady;
    self.mediaPlayButton.enabled = isReady;
}

- (void)setImage:(UIImage *)image {
    
    self.previewImageView.image = image;
    [self setNeedsLayout];
}

- (void)setIsActive:(BOOL)isActive {
    
    NSString *imageName = isActive ? @"pause_icon" : @"play_icon";
    UIImage *buttonImage = [QMChatResources imageNamed:imageName];
    
    if (buttonImage) {
        
        [self.mediaPlayButton setImage:buttonImage
                              forState:UIControlStateNormal];
        [self.mediaPlayButton setImage:buttonImage
                              forState:UIControlStateDisabled];
    }
}

- (IBAction)activateMedia:(id)sender {
    
    [self.presenter activateMedia];
}

- (NSString *)timestampString:(NSTimeInterval)duration {
    
    if (duration < 60)
    {
        
        return [NSString stringWithFormat:@"0:%02d", (int)round(duration)];
        
    }
    else if (duration < 3600)
    {
        return [NSString stringWithFormat:@"%d:%02d", (int)duration / 60, (int)duration % 60];
    }
    
    return [NSString stringWithFormat:@"%d:%02d:%02d", (int)duration / 3600, (int)duration / 60, (int)duration % 60];
}

- (NSString *)timestampString:(NSTimeInterval)currentTime forDuration:(NSTimeInterval)duration
{
    if (duration < 60)
    {
        
        if (currentTime < duration)
        {
            return [NSString stringWithFormat:@"0:%02d", (int)round(currentTime)];
        }
        return [NSString stringWithFormat:@"0:%02d", (int)ceil(currentTime)];
    }
    else if (duration < 3600)
    {
        return [NSString stringWithFormat:@"%d:%02d", (int)currentTime / 60, (int)currentTime % 60];
    }
    
    return [NSString stringWithFormat:@"%d:%02d:%02d", (int)currentTime / 3600, (int)currentTime / 60, (int)currentTime % 60];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    } else {
        return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
    }
}

@end
