//
//  QMMediaViewDelegate.h
//  QMPLayer
//
//  Created by Vitaliy Gurkovsky on 1/30/17.
//  Copyright © 2017 quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QMMediaPresenterDelegate.h"

@protocol QMMediaViewDelegate <NSObject>

@required

- (void)setupInitialState;

@property (strong, nonatomic) id <QMMediaPresenterDelegate> presenter;

@property (nonatomic, assign) BOOL isReady;
@property (nonatomic, assign) BOOL isActive;

@optional

@property (nonatomic, assign) NSInteger currentTime;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) CGFloat progress;

- (void)setThumbnailImage:(UIImage *)image;
- (void)setImage:(UIImage *)image;
- (void)showLoadingError:(NSError *)error;
- (void)showUploadingError:(NSError *)error;

@end
