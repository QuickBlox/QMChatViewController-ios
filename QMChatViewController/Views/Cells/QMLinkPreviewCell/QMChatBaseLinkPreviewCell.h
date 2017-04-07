//
//  QMChatBaseLinkPreviewCell.h
//  Pods
//
//  Created by Vitaliy Gurkovsky on 3/31/17.
//
//

#import "QMChatCell.h"
#import "QMImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMChatBaseLinkPreviewCell : QMChatCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *siteDescriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *urlLabel;
@property (nonatomic, weak) IBOutlet QMImageView *previewImageView;

@end

NS_ASSUME_NONNULL_END
