//
//  QMBaseChatMediaAttachmentCell.h
//  Pods
//
//  Created by Vitaliy Gurkovsky on 2/07/17.
//
//

#import "QMChatCell.h"

@protocol QMMediaViewDelegate;

@interface QMBaseMediaCell : QMChatCell <QMMediaViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *previewImageView;
@property (nonatomic, weak) IBOutlet UIButton *mediaPlayButton;

@end
