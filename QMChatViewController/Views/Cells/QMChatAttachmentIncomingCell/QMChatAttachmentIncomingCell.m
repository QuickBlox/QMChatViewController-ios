//
//  QMChatAttachmentIncomingCell.m
//  sample-chat-swift
//
//  Created by Injoit on 7/1/15.
//  Copyright (c) 2015 quickblox. All rights reserved.
//

#import "QMChatAttachmentIncomingCell.h"

@implementation QMChatAttachmentIncomingCell

+ (UINib *)nib {
    return [UINib nibWithNibName:[self cellReuseIdentifier] bundle:[NSBundle bundleForClass:[self class]]];
}

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self class]);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.attachmentImageView.image = nil;
}

@end
