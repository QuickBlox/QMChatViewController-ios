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
    
    self.circularProgress.tintColor = [UIColor grayColor];
    self.mediaPlayButton.tintColor = [UIColor whiteColor];
    self.durationLabel.textColor = [UIColor grayColor];
}


+ (QMChatCellLayoutModel)layoutModel {
    
    QMChatCellLayoutModel defaultLayoutModel = [super layoutModel];
    defaultLayoutModel.avatarSize = CGSizeMake(0, 0);
    defaultLayoutModel.containerInsets = UIEdgeInsetsMake(4, 12, 4, 4),
    defaultLayoutModel.topLabelHeight = 0;
    defaultLayoutModel.bottomLabelHeight = 14;
    return defaultLayoutModel;
}

@end
