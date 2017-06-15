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

@interface QMChatBaseLinkPreviewCell() <QMImageViewDelegate>

@end

@implementation QMChatBaseLinkPreviewCell

@synthesize siteURL = _siteURL;
@synthesize imageURL = _imageURL;
@synthesize siteTitle = _siteTitle;
@synthesize siteDescription = _siteDescription;

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    _previewImageView.image = nil;
    _iconImageView.image = nil;
    _linkPreviewView.backgroundColor = [UIColor clearColor];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _previewImageView.delegate = self;
    _previewImageView.contentMode = UIViewContentModeScaleToFill;
    _previewImageView.clipsToBounds = YES;
    
    _siteDescriptionLabel.textColor = [UIColor whiteColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _urlLabel.textColor = [UIColor whiteColor];
}

//MARK: -  QMImageViewDelegate

- (void)imageViewDidTap:(QMImageView *)imageView {
    
    if ([self.delegate respondsToSelector:@selector(chatCellDidTapContainer:)]) {
        [self.delegate chatCellDidTapContainer:self];
    }
}

//MARK: -  QMLinkPreviewDelegate

- (void)setSiteDescription:(NSString *)siteDescription {
    
    _siteDescription = [siteDescription copy];
}

- (void)setSiteTitle:(NSString *)siteTitle {
    
    _siteTitle = [siteTitle copy];
    _titleLabel.text = siteTitle;
}

- (void)setSiteURL:(NSString *)siteURL {

    _siteURL = [siteURL copy];
    
    NSString *siteHost = [NSURL URLWithString:siteURL].host;
    _siteDescriptionLabel.text = siteHost;
    
    NSURL *iconURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/favicon.ico", siteHost]];
    
    if (iconURL.scheme == nil) {
        NSString *urlString = [NSString stringWithFormat:@"http://%@",iconURL.absoluteString];
        iconURL = [NSURL URLWithString:urlString];
    }
    
    [_iconImageView setImageWithURL:iconURL];
}

- (void)setSiteURL:(NSString *)siteURL
          imageURL:(nullable NSString *)imageURL
         siteTitle:(NSString *)siteTitle
   siteDescription:(nullable NSString *)siteDescription
     onImageDidSet:(void(^)())imageDidSet {
    
    [self setSiteURL:siteURL];
    [self setSiteTitle:siteTitle];
    [self setSiteDescription:siteDescription];
    
    _imageURL = [imageURL copy];
    
    BOOL exists = [[self class] imageForURLKey:imageURL] != nil;
    
    SDWebImageOptions options = SDWebImageLowPriority;
    
    [_previewImageView setImageWithURL:[NSURL URLWithString:imageURL]
                           placeholder:nil
                               options:options
                              progress:nil
                        completedBlock:^(UIImage *image,
                                         NSError *__unused error,
                                         SDImageCacheType __unused cacheType,
                                         NSURL *__unused imageURL)
     {
         if (image) {
             
             _linkPreviewView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
             if (!exists) {
                 if (imageDidSet) {
                     imageDidSet();
                 }
             }
         }
         else {
             _linkPreviewView.backgroundColor = [UIColor clearColor];
         }
     }];
}

+ (UIImage *)imageForURLKey:(NSString *)urlKey {
    
     UIImage *image = [[QMImageLoader instance].imageCache imageFromDiskCacheForKey:urlKey];
    
    return image;
}

@end
