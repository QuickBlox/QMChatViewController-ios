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
   

}

- (void)setCurrentTime:(NSTimeInterval)currentTime
           forDuration:(CGFloat)duration {
    
    self.progressLabel.text = [self timestampString:currentTime
                                        forDuration:duration];
    [self.progressView setProgress:currentTime/duration animated:YES];
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

@end
