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
    self.progressView.progressBarColor = [UIColor redColor];
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    [self.progressView setProgress:0
                          animated:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = self.containerView.maskPath.CGPath;
    layer.frame = self.bounds;
    self.progressView.layer.mask = layer;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
           forDuration:(NSTimeInterval)duration {
    
    if (duration > 0) {
        NSString *timeStamp = [self timestampString:currentTime
                                         forDuration:duration];
        
        self.durationLabel.text = timeStamp;
        BOOL animated = currentTime > 0;
        [self.progressView setProgress:currentTime/duration animated:animated];
    }
}

- (NSString *)timestampString:(NSTimeInterval)currentTime forDuration:(NSTimeInterval)duration
{
 
    NSInteger time = round(currentTime);
    
    if (duration < 60)
    {
        if (currentTime < duration)
        {
            return [NSString stringWithFormat:@"0:%02d", time];
        }
        return [NSString stringWithFormat:@"0:%02d", time];
    }
    else if (duration < 3600)
    {
        return [NSString stringWithFormat:@"%d:%02d", time / 60, time % 60];
    }
    
    return [NSString stringWithFormat:@"%d:%02d:%02d", time / 3600, time / 60, time % 60];
}

@end
