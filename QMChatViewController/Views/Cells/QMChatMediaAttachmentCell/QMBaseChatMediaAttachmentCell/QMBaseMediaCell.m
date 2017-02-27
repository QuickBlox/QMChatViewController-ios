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

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.previewImageView.image = nil;
}
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.mediaPlayButton.tintColor = [UIColor whiteColor];
    [self.mediaPlayButton setTitle:nil
                          forState:UIControlStateNormal];
    
    [self.mediaPlayButton addTarget:self
                             action:@selector(activateMedia:)
                   forControlEvents:UIControlEventTouchDown];
    self.circularProgress.hideProgressIcons = YES;
    self.durationLabel.hidden = YES;
    self.circularProgress.tintColor = [UIColor whiteColor];
    [self.circularProgress startSpinProgressBackgroundLayer];
    self.progressLabel.text = nil;
}

- (void)dealloc {
    
    NSLog(@"Dealock ");
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
    
    self.durationLabel.text = [NSString stringWithFormat:@"%2.0f",duration];
}

- (void)setIsReady:(BOOL)isReady {
    
    self.circularProgress.hidden = isReady;
    if (isReady) {
        [self.circularProgress stopSpinProgressBackgroundLayer];
    }
    self.progressLabel.hidden = isReady;
    self.durationLabel.hidden = !isReady;
    self.mediaPlayButton.hidden = !isReady;
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
    }
}

- (IBAction)activateMedia:(id)sender {
    
    [self.presenter activateMedia];
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
