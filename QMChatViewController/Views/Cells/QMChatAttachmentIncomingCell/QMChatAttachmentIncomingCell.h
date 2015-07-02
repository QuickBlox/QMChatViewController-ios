//
//  QMChatAttachmentIncomingCell.h
//  sample-chat-swift
//
//  Created by Injoit on 7/1/15.
//  Copyright (c) 2015 quickblox. All rights reserved.
//

#import "QMChatCell.h"
#import "QMChatAttachmentCell.h"

@interface QMChatAttachmentIncomingCell : QMChatCell<QMChatAttachmentCell>

@property (nonatomic, weak) IBOutlet UIImageView *attachmentImageView;

@end
