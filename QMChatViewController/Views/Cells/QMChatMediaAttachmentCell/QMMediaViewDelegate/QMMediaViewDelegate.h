//
//  QMMediaViewDelegate.h
//  QMPLayer
//
//  Created by Vitaliy Gurkovsky on 1/30/17.
//  Copyright © 2017 quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QMMediaViewState) {
    QMMediaViewStateNotReady,
    QMMediaViewStateReady,
    QMMediaViewStateLoading,
    QMMediaViewStateActive
};

@protocol QMMediaHandler;

@protocol QMMediaViewDelegate <NSObject>

@required

@property (nonatomic, weak) id <QMMediaHandler> mediaHandler;
@property (nonatomic, strong) NSString *messageID;

@optional

@property (nonatomic, assign) QMMediaViewState viewState;
@property (nonatomic, assign) BOOL isReady;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, strong) UIImage *image;

- (void)showLoadingError:(NSError *)error;
- (void)showUploadingError:(NSError *)error;

@end

@protocol QMMediaHandler

- (void)didTapContainer:(id<QMMediaViewDelegate>)view;
- (void)didTapPlayButton:(id<QMMediaViewDelegate>)view;
- (void)shouldCancelOperation:(id<QMMediaViewDelegate>)view;

@end
