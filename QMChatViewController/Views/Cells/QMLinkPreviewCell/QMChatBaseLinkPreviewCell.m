//
//  QMChatBaseLinkPreviewCell.m
//  Pods
//
//  Created by Vitaliy Gurkovsky on 3/31/17.
//
//

#import "QMChatBaseLinkPreviewCell.h"
#import "QMChatResources.h"

@interface QMChatBaseLinkPreviewCell() <QMImageViewDelegate>
@end

@implementation QMChatBaseLinkPreviewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    _previewImageView.image = nil;
    _iconImageView.image = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _previewImageView.delegate = self;
    _previewImageView.contentMode = UIViewContentModeScaleAspectFit;
    _previewImageView.clipsToBounds = YES;
}


//MARK: -  QMImageViewDelegate
- (void)imageViewDidTap:(QMImageView *)imageView {
    
    if ([self.delegate respondsToSelector:@selector(chatCellDidTapContainer:)]) {
        [self.delegate chatCellDidTapContainer:self];
    }
}

+ (QMChatCellLayoutModel)layoutModel {
    
    QMChatCellLayoutModel defaultLayoutModel = [super layoutModel];
    defaultLayoutModel.avatarSize = CGSizeMake(0, 0);
    defaultLayoutModel.containerInsets = UIEdgeInsetsMake(4, 4, 4, 15),
    defaultLayoutModel.topLabelHeight = 0;
   // defaultLayoutModel.bottomLabelHeight = 14;
    
    return defaultLayoutModel;
}

@end
