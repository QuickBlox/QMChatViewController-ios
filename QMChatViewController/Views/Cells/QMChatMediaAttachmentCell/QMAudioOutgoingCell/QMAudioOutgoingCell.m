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
    
    [self.progressView setProgress:currentTime/duration animated:YES];
}

@end
