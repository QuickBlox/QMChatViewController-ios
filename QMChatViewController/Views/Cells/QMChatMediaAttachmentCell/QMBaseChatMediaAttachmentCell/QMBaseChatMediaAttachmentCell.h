//
//  QMBaseChatMediaAttachmentCell.h
//  Pods
//
//  Created by Vitaliy Gurkovsky on 2/07/17.
//
//

#import "QMChatCell.h"

@protocol QMMediaViewDelegate;

@interface QMBaseChatMediaAttachmentCell : QMChatCell <QMMediaViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *mediaImageView;
@property (nonatomic, weak) IBOutlet UIButton *mediaPlayButton;

@end
