//
//  QMVideoIncomingCell.m
//  Pods
//
//  Created by Vitaliy Gurkovsky on 2/13/17.
//
//

#import "QMVideoIncomingCell.h"

@implementation QMVideoIncomingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mediaPlayButton.tintColor = [UIColor grayColor];
    self.circularProgress.tintColor = [UIColor grayColor];
    
}


@end
