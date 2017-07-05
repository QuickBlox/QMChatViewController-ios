//
//  QMImageLoader.h
//  QMChatViewController
//
//  Created by Vitaliy Gorbachov on 9/12/16.
//  Copyright (c) 2016 Quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/SDWebImageManager.h>
#import "UIImage+Cropper.h"

NS_ASSUME_NONNULL_BEGIN

@class QMWebImageCombinedOperation;

typedef UIImage  * _Nullable (^QMCustomTransformBlock)(NSURL *imageURL, UIImage *originalImage);


typedef NS_ENUM(NSInteger, QMImageTransformType) {
    
    QMImageTransformTypeScaleAndCrop = 0,
    QMImageTransformTypeCircle,
    QMImageTransformTypeRounding,
    QMImageTransformTypeCustom
};


@interface QMImageTransform : NSObject

@property (assign, nonatomic, readonly) CGSize size;

+ (instancetype)transformWithType:(QMImageTransformType)transformType
                             size:(CGSize)size;

+ (instancetype)transformWithCustomTransformBlock:(QMCustomTransformBlock)transformBlock;
+ (instancetype)transformWithSize:(CGSize)size isCircle:(BOOL)isCircle; //deprecate???
- (NSString *)keyWithURL:(NSURL *)url;

@end

typedef void(^QMWebImageCompletionWithFinishedBlock)(UIImage *_Nullable image, UIImage *_Nullable transfomedImage, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL);

/**
 *  QMImageLoader class interface.
 *  This class is responsible for image caching, loading and size handling using
 *  SDWebImage component.
 */
@interface QMImageLoader : SDWebImageManager

@property (nonatomic, strong, class) QMImageLoader *instance;

+ (SDWebImageManager *)sharedManager NS_UNAVAILABLE;
- (UIImage *)originalImageWithURL:(NSURL *)url;
- (BOOL)hasImageOperationWithURL:(NSURL *)url;
- (QMWebImageCombinedOperation *)operationWithURL:(NSURL *)url;
- (void)cancelOperationWithURL:(NSURL *)url;

- (QMWebImageCombinedOperation *)downloadImageWithURL:(NSURL *)url
                                       transform:(nullable QMImageTransform *)transform
                                         options:(SDWebImageOptions)options
                                        progress:(_Nullable SDWebImageDownloaderProgressBlock)progressBlock
                                       completed:(QMWebImageCompletionWithFinishedBlock)completedBlock;

- (QMWebImageCombinedOperation *)downloadImageWithURL:(NSURL *)url
                                           token:(nullable NSString *)token
                                       transform:(QMImageTransform *)transform
                                         options:(SDWebImageOptions)options
                                        progress:(_Nullable SDWebImageDownloaderProgressBlock)progressBlock
                                       completed:(QMWebImageCompletionWithFinishedBlock)completedBlock;

@end


NS_ASSUME_NONNULL_END
