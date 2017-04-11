//
//  QMChatIncomingLinkPreviewCell.m
//  Pods
//
//  Created by Vitaliy Gurkovsky on 3/31/17.
//
//

#import "QMChatIncomingLinkPreviewCell.h"

@implementation QMChatIncomingLinkPreviewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.siteDescriptionLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.urlLabel.textColor = [UIColor darkGrayColor];
}

@end
