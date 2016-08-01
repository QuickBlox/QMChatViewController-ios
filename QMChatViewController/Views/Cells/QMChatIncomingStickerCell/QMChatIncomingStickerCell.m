//
//  QMChatIncomingStickerCell.m
//  Pods
//
//  Created by Olya Lutsyk on 4/25/16.
//
//

#import "QMChatIncomingStickerCell.h"

@implementation QMChatIncomingStickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.bgColor = [UIColor clearColor];
    self.containerView.highlightColor = [UIColor clearColor];
    self.bottomLabel.backgroundColor = [UIColor clearColor];
    
}

+ (QMChatCellLayoutModel)layoutModel {
    
    QMChatCellLayoutModel defaultLayoutModel = [super layoutModel];
    defaultLayoutModel.avatarSize = CGSizeMake(0, 0);
    defaultLayoutModel.containerInsets = UIEdgeInsetsMake(4, 4, 4, 15),
    defaultLayoutModel.topLabelHeight = 0;
    defaultLayoutModel.bottomLabelHeight = 14;
    
    return defaultLayoutModel;
}

@end
