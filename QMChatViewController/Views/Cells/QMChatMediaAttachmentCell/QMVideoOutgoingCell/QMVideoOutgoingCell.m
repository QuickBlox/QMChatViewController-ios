//
//  QMVideoOutgoingCell.m
//  Pods
//
//  Created by Vitaliy Gurkovsky on 2/13/17.
//
//

#import "QMVideoOutgoingCell.h"

@implementation QMVideoOutgoingCell

- (void)awakeFromNib {
    
    [super awakeFromNib];

    self.progressLabel.text = nil;
    self.durationLabel.textColor = [UIColor whiteColor];
}

- (void)setDuration:(NSTimeInterval)duration {
    
    self.durationLabel.text = [self timestampStringForDuration:duration];
}

- (NSString *)timestampStringForDuration:(NSTimeInterval)duration {
    
    if (duration < 60) {
         return [NSString stringWithFormat:@"0:%02d", (int)round(duration)];
    }
    else if (duration < 3600) {
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
@end
