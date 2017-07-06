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

@synthesize messageID = _messageID;
@synthesize mediaHandler = _mediaHandler;
@synthesize duration = _duration;
@synthesize offset = _offset;
@synthesize currentTime = _currentTime;
@synthesize progress = _progress;
@synthesize isReady = _isReady;
@synthesize isActive = _isActive;
@synthesize image = _image;
@synthesize thumbnailImage = _thumbnailImage;
@synthesize isLoading = _isLoading;

//MARK: - NSObject

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
    self.durationLabel.text = nil;
    self.progressLabel.text = nil;
    self.circularProgress.hidden = YES;
    self.progressLabel.hidden = YES;
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.previewImageView.layer.cornerRadius = 4.0;
//    self.previewImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    self.previewImageView.layer.shouldRasterize = YES;
}

- (void)setIsLoading:(BOOL)isLoading {
    
    if (_isLoading != isLoading) {
        
        self.circularProgress.hidden = !isLoading;
        
        if (isLoading) {
            [self.circularProgress startSpinProgressBackgroundLayer];
        }
        else {
            self.progressLabel.hidden = YES;
            [self.circularProgress stopSpinProgressBackgroundLayer];
        }
        _isLoading = isLoading;
    }
}


- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    self.isReady = NO;
    self.isLoading = NO;
    self.isActive = NO;
    self.progressLabel.hidden = YES;
    self.circularProgress.hidden = YES;
    [self.circularProgress stopSpinProgressBackgroundLayer];
    self.circularProgress.hideProgressIcons = YES;
    self.progress = 0.0;
    self.previewImageView.image = nil;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    
    if (_currentTime == currentTime) {
        return;
    }
    
    _currentTime = currentTime;
    
    self.durationLabel.text = [self timestampString:currentTime forDuration:_duration];
    
}
- (void)showLoadingError:(NSError *)error {
    
}
- (void)setProgress:(CGFloat)progress {
    
    if (self.isReady) {
        return;
    }
    
    if (progress > 0.0) {
        
        self.progressLabel.hidden = NO;
        self.circularProgress.hidden = NO;
        [self.circularProgress stopSpinProgressBackgroundLayer];
    }
    
    self.progressLabel.text = [NSString stringWithFormat:@"%2.0f%%", progress * 100.0f];
    
    if (progress >= 1) {
        self.circularProgress.hidden = YES;
    }
    else {
        [self.circularProgress setProgress:progress];
    }
}

- (void)setDuration:(NSTimeInterval)duration {
    
    _duration = duration;
    
    self.durationLabel.text = [self timestampString:duration];
}

- (void)setIsReady:(BOOL)isReady {
    
    _isReady = isReady;
    if (isReady) {
    self.progressLabel.hidden = YES;
    }
    self.mediaPlayButton.enabled = isReady;
}

- (void)setThumbnailImage:(UIImage *)image {
    _thumbnailImage = image;
    self.previewImageView.image = image;
    [self.previewImageView setNeedsLayout];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.previewImageView.image = image;
    [self.previewImageView setNeedsLayout];
}

- (void)setIsActive:(BOOL)isActive {
    
    if (_isActive == isActive) {
        return;
    }
    _isActive = isActive;
    
    NSString *imageName = isActive ? @"pause_icon" : @"play_icon";
    UIImage *buttonImage = [QMChatResources imageNamed:imageName];
    
    if (buttonImage) {
        
        [UIView transitionWithView:self.mediaPlayButton
                          duration:0.15
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.mediaPlayButton setImage:buttonImage
                                                  forState:UIControlStateNormal];
                            [self.mediaPlayButton setImage:buttonImage
                                                  forState:UIControlStateDisabled];
                        } completion:nil];
        
        
    }
    
    if (!isActive) {
        self.durationLabel.text = [self timestampString:self.duration];
    }
}

- (IBAction)activateMedia:(id)sender {
    
    [self.mediaHandler didTapPlayButton:self];
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
    
    NSString *timestampString  = nil;
    if (duration < 60) {
        if (currentTime < duration)
        {
            timestampString = [NSString stringWithFormat:@"0:%02d", (int)round(currentTime)];
        }
        else {
            timestampString = [NSString stringWithFormat:@"0:%02d", (int)ceil(currentTime)];
        }
    }
    else if (duration < 3600)
    {
        timestampString = [NSString stringWithFormat:@"%d:%02d", (int)currentTime / 60, (int)currentTime % 60];
    }
    else {
        timestampString = [NSString stringWithFormat:@"%d:%02d:%02d", (int)currentTime / 3600, (int)currentTime / 60, (int)currentTime % 60];
    }
    
    return timestampString;
}


- (CALayer *)maskLayerFromImage:(UIImage *)image
                      withFrame:(CGRect)frame {
    
    CALayer *layer = [CALayer layer];
    
    layer.frame = frame;
    layer.contents = (id)[image CGImage];
    layer.contentsScale = [image scale];
    layer.rasterizationScale = [image scale];
    CGSize imageSize = [image size];
    
    NSAssert(image.resizingMode == UIImageResizingModeStretch || UIEdgeInsetsEqualToEdgeInsets(image.capInsets, UIEdgeInsetsZero),
             @"the resizing mode of image should be stretch; if not, then its insets must be all-zero");
    
    UIEdgeInsets insets = [image capInsets];
    
    // These are lifted from what UIImageView does by experimentation. Without these exact values, the stretching is slightly off.
    const CGFloat halfPixelFudge = 0.49f;
    const CGFloat otherPixelFudge = 0.02f;
    // Convert to unit coordinates for the contentsCenter property.
    CGRect contentsCenter = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    if (insets.left > 0 || insets.right > 0) {
        contentsCenter.origin.x = ((insets.left + halfPixelFudge) / imageSize.width);
        contentsCenter.size.width = (imageSize.width - (insets.left + insets.right + 1.f) + otherPixelFudge) / imageSize.width;
    }
    if (insets.top > 0 || insets.bottom > 0) {
        contentsCenter.origin.y = ((insets.top + halfPixelFudge) / imageSize.height);
        contentsCenter.size.height = (imageSize.height - (insets.top + insets.bottom + 1.f) + otherPixelFudge) / imageSize.height;
    }
    layer.contentsGravity = kCAGravityResize;
    layer.contentsCenter = contentsCenter;
    
    return layer;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    } else {
        return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
    }
}

@end
