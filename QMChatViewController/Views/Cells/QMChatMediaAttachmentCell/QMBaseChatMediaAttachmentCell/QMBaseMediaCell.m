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

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.mediaPlayButton.tintColor = [UIColor whiteColor];
    [self.mediaPlayButton setTitle:nil
                          forState:UIControlStateNormal];
    
    [self.mediaPlayButton addTarget:self
                             action:@selector(activateMedia:)
                   forControlEvents:UIControlEventTouchDown];
    
    self.circularProgress.hideProgressIcons = YES;
    self.circularProgress.tintColor = [UIColor whiteColor];
}

- (void)dealloc {
    
    NSLog(@"Dealock ");
}

- (void)setProgres:(CGFloat)progress {
    
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f", progress*100];
    [self.circularProgress setProgress:progress];
}

- (void)setDuration:(CGFloat)duration {
    
    self.durationLabel.text = [NSString stringWithFormat:@"%f", duration];
}

- (void)setIsReady:(BOOL)isReady {
    
    self.circularProgress.hidden = isReady;
    self.progressLabel.hidden = isReady;
    self.durationLabel.hidden = !isReady;
    self.mediaPlayButton.hidden = !isReady;
}

- (void)setThumbnailImage:(UIImage *)image {

    self.previewImageView.image = image;
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


@end
