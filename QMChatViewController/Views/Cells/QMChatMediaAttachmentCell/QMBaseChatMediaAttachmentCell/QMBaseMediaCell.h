//
//  QMBaseChatMediaAttachmentCell.h
//  Pods
//
//  Created by Vitaliy Gurkovsky on 2/07/17.
//
//

#import "QMChatCell.h"
#import "FFCircularProgressView.h"

@protocol QMMediaViewDelegate;

@interface QMBaseMediaCell : QMChatCell <QMMediaViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *previewImageView;
@property (nonatomic, weak) IBOutlet UIButton *mediaPlayButton;
@property (nonatomic, weak) IBOutlet UILabel *progressLabel;
@property (nonatomic, weak) IBOutlet UILabel *durationLabel;
@property (nonatomic, weak) IBOutlet FFCircularProgressView *circularProgress;

@end
