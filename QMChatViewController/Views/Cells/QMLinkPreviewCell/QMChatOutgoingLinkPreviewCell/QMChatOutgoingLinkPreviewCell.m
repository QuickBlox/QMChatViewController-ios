//
//  QMChatOutgoingLinkPreviewCell.m
//  Pods
//
//  Created by Vitaliy Gurkovsky on 3/31/17.
//
//

#import "QMChatOutgoingLinkPreviewCell.h"


@implementation QMChatOutgoingLinkPreviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.siteDescriptionLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.urlLabel.textColor = [UIColor whiteColor];
}

@end
