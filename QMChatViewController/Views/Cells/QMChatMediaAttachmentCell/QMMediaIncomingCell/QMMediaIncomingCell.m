//
//  QMMediaIncomingCell.m
//  Pods
//
//  Created by Vitaliy Gurkovsky on 2/10/17.
//
//

#import "QMMediaIncomingCell.h"

@implementation QMMediaIncomingCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.circularProgress.tintColor = [UIColor darkGrayColor];
    self.progressLabel.textColor = [UIColor darkGrayColor];
}

- (void)setupInitialState {
    
}

@end
