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

@end
