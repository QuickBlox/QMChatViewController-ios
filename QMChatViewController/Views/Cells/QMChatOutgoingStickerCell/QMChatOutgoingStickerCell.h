//
//  QMOutgoingStickerCell.h
//  Pods
//
//  Created by Olya Lutsyk on 4/25/16.
//
//

#import <UIKit/UIKit.h>
#import "QMChatCell.h"

@interface QMChatOutgoingStickerCell : QMChatCell

@property (nonatomic, weak) IBOutlet UIImageView *stickerImage;

+ (QMChatCellLayoutModel)layoutModel;

@end
