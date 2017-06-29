//
//  QMChatBaseLinkPreviewCell.m
//  Pods
//
//  Created by Vitaliy Gurkovsky on 3/31/17.
//
//

#import "QMLinkPreviewDelegate.h"
#import "QMChatBaseLinkPreviewCell.h"
#import "QMChatResources.h"
#import "QMImageLoader.h"
#import <AVFoundation/AVFoundation.h>

@interface QMChatBaseLinkPreviewCell() <QMImageViewDelegate>
@end

@implementation QMChatBaseLinkPreviewCell

@synthesize siteURL = _siteURL;
@synthesize imageURL = _imageURL;
@synthesize siteTitle = _siteTitle;
@synthesize siteDescription = _siteDescription;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _previewImageView.contentMode = UIViewContentModeScaleToFill;
    _previewImageView.clipsToBounds = YES;
}

//MARK: -  QMImageViewDelegate

- (void)imageViewDidTap:(QMImageView *)imageView {
    
    if ([self.delegate respondsToSelector:@selector(chatCellDidTapContainer:)]) {
        [self.delegate chatCellDidTapContainer:self];
    }
}

//MARK: -  QMLinkPreviewDelegate

- (void)setSiteURL:(NSString *)siteURL
      previewImage:(UIImage *)previewImage
           favicon:(UIImage *)favicon {
    
    _siteURL = [siteURL copy];
    
    NSMutableAttributedString *resultHostString = [[NSMutableAttributedString alloc] init];
    
    if (favicon) {
        
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = favicon;
        
        UIFont *font = _urlLabel.font;
        CGFloat mid = font.descender + font.capHeight;
        
        CGSize imageSize = AVMakeRectWithAspectRatioInsideRect(favicon.size,
                                                               CGRectMake(0, 0, 16, 16)).size;
        attachment.bounds = CGRectIntegral(
                                           CGRectMake(0,
                                                      font.descender - imageSize.height / 2 + mid + 2,
                                                      imageSize.width,
                                                      imageSize.height));
        
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
   
        [resultHostString appendAttributedString:attachmentString];
    }
    
    NSString *hostSring = [NSString stringWithFormat:@" %@", [NSURL URLWithString:siteURL].host];
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : UIColor.whiteColor };
    NSAttributedString *host = [[NSAttributedString alloc] initWithString:hostSring attributes:attrs];
    [resultHostString appendAttributedString:host];
    
    _urlLabel.attributedText = resultHostString;
    _previewImageView.image = previewImage;
}

@end
